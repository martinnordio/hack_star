class_name DrawnFighters
extends RefCounted
## The fighters drawn by children (spec 09, part A, D14): one row per fighter, its look in its own
## file `scenes/drawn/<id>_model.gd` (a `LOOKS` table per skin, the `IDEA_PARTS` that make the
## drawing recognisable and a static `build(model: FighterModel, look: Dictionary)` that adds
## shapes to the model's rig, body and head; optionally a static `animate(model, time, state)`
## for its own moves, D53). `FighterModel.setup` asks here first. Removing a
## drawn fighter = its file, its row here, its entry in `Fighters.LIST` and its `SampleProgress`
## numbers (`docs/drawing_to_fighter.md`); nothing else names it.

const MODELS: Dictionary[String, GDScript] = {
	"beatbolt": preload("res://scenes/drawn/beatbolt_model.gd"),
	"beatbolt2": preload("res://scenes/drawn/beatbolt2_model.gd"),
}


static func has(fighter_id: String) -> bool:
	return MODELS.has(fighter_id)


## The looks of a drawn fighter per skin id, like `FighterModel.LOOKS[fighter_id]`.
static func looks(fighter_id: String) -> Dictionary:
	var model_script: Variant = MODELS[fighter_id]
	return model_script.LOOKS


## The names of the parts that make the drawing recognisable.
static func idea_parts(fighter_id: String) -> Array[String]:
	var model_script: Variant = MODELS[fighter_id]
	return model_script.IDEA_PARTS


## Builds the drawn fighter's shapes into `model` (already cleared by `FighterModel.setup`).
static func build(fighter_id: String, model: FighterModel, look: Dictionary) -> void:
	var model_script: Variant = MODELS[fighter_id]
	model_script.build(model, look)


## Moves a drawn fighter's own parts on top of `FighterModel.animate` (spec 09 D53), when its look
## file has a static `animate(model, time, state)`; `state` has `running` (bool) and `attack` (the
## recoil, 0 → 1 → 0 over a shot). Nothing for a fighter without one.
static func animate(
	fighter_id: String, model: FighterModel, time: float, state: Dictionary
) -> void:
	var model_script: Variant = MODELS.get(fighter_id)
	if model_script != null and (model_script as GDScript).has_method("animate"):
		model_script.animate(model, time, state)
