extends SceneTree
## Bakes Glimmer Isles (spec 09, D12): loads `scatter_source.tscn`, rebuilds every
## `ProtonScatter` on the main thread (`dbg_disable_thread`) with its fixed seed, and saves the
## result as plain `MultiMeshInstance3D`s in `baked.tscn`, which references no addon script — the
## game loads only that file, so no thread and no addon code run while it plays.
## Each prop part (`GlimmerProp.parts()`) gets one MultiMesh over every place of its prop kind,
## with the part's own mesh and toon material, so each part keeps its own outline.
## Run it with `tools/bake_world.ps1` after changing the source scene or the props.

const SOURCE: String = "res://scenes/worlds/glimmer_isles/scatter_source.tscn"
const OUTPUT: String = "res://scenes/worlds/glimmer_isles/baked.tscn"
const PROPS: String = "res://scenes/worlds/glimmer_isles/props/"
const SCATTER_SCRIPT: String = "res://addons/proton_scatter/src/scatter.gd"
const MAX_FRAMES: int = 600

var _pending: int = 0


func _initialize() -> void:
	_bake.call_deferred()


func _bake() -> void:
	var source: Node3D = (load(SOURCE) as PackedScene).instantiate()
	var scatters: Array[Node3D] = []
	for child: Node in source.get_children():
		if child.get_script() == load(SCATTER_SCRIPT):
			scatters.append(child)
			child.set("dbg_disable_thread", true)
			child.set("enable_updates_in_game", true)
			child.set("force_rebuild_on_load", true)
			child.connect("build_completed", _on_build_completed)
	_pending = scatters.size()
	root.add_child(source)
	var frames: int = 0
	while _pending > 0 and frames < MAX_FRAMES:
		await process_frame
		frames += 1
	if _pending > 0:
		printerr("bake: %d scatter(s) did not finish" % _pending)
		quit(1)
		return

	var places: Dictionary[String, Array] = {}
	for scatter: Node3D in scatters:
		_collect(source, scatter, places)
	var baked: Node3D = Node3D.new()
	baked.name = "GlimmerIslesBaked"
	var kinds: Array = places.keys()
	kinds.sort()
	for kind: String in kinds:
		_add_kind(baked, kind, places[kind])
	var scene: PackedScene = PackedScene.new()
	var packed: Error = scene.pack(baked)
	var saved: Error = ResourceSaver.save(scene, OUTPUT) if packed == OK else packed
	baked.free()
	if saved != OK:
		printerr("bake: could not save %s (error %d)" % [OUTPUT, saved])
		quit(1)
		return
	for kind: String in kinds:
		print("bake: %s %d" % [kind, places[kind].size()])
	print("bake: saved %s" % OUTPUT)
	quit(0)


func _on_build_completed() -> void:
	_pending -= 1


# Every place of every item of `scatter`, relative to the source scene's root, by prop kind (the
# item's scene file name). Read from the scatter's transform list and split between its items as
# ProtonScatter does for its MultiMeshes (`_update_multimeshes`, chunks off): the output's own
# MultiMeshes hold no transforms without a renderer.
func _collect(source: Node3D, scatter: Node3D, places: Dictionary[String, Array]) -> void:
	var base: Transform3D = source.global_transform.affine_inverse() * scatter.global_transform
	var list: Array = scatter.get("transforms").get("list")
	var total: int = scatter.get("total_item_proportion")
	var offset: int = 0
	for item: Node in scatter.get("items"):
		var kind: String = String(item.get("path")).get_file().get_basename()
		if not places.has(kind):
			places[kind] = []
		var count: int = roundi(float(item.get("proportion")) / total * list.size())
		for index: int in count:
			if offset + index >= list.size():
				break
			var place: Transform3D = item.call("process_transform", list[offset + index])
			places[kind].append(base * place)
		offset += count


func _add_kind(baked: Node3D, kind: String, places: Array) -> void:
	var prop: GlimmerProp = (load(PROPS + kind + ".tscn") as PackedScene).instantiate()
	var parts: Array[MeshInstance3D] = prop.parts()
	for part_index: int in parts.size():
		var part: MeshInstance3D = parts[part_index]
		var multimesh: MultiMesh = MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.mesh = part.mesh
		var transforms: Array[Transform3D] = []
		for place: Transform3D in places:
			transforms.append(place * part.transform)
		var material: ShaderMaterial = part.material_override
		var instances: MultiMeshInstance3D = MultiMeshInstance3D.new()
		instances.name = kind.to_pascal_case() + part.name
		instances.multimesh = multimesh
		instances.set_meta("kind", kind)
		instances.set_meta("part_index", part_index)
		instances.set_meta("transforms", transforms)
		instances.set_meta("albedo", material.get_shader_parameter("albedo"))
		instances.set_meta("glow", material.get_shader_parameter("emission"))
		instances.set_meta("glow_strength", material.get_shader_parameter("emission_energy"))
		instances.set_meta("outlined", material.next_pass != null)
		baked.add_child(instances)
		instances.owner = baked
	prop.free()
