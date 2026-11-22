class_name DrawnFighters
extends RefCounted
## The fighters drawn by children (spec 09, part A, D14): one row per fighter, its look in its own
## file `scenes/drawn/<id>_model.gd` (a `LOOKS` table per skin and a static
## `build(model: FighterModel, look: Dictionary)` that adds shapes to the model's rig, body and
## head). `FighterModel.setup` asks here first. Removing a drawn fighter = its file, its row here
## and its entry in `Fighters.LIST` (and `SampleProgress`); nothing else names it.

const MODELS: Dictionary[String, GDScript] = {
	"beatbolt": preload("res://scenes/drawn/beatbolt_model.gd"),
}


static func has(fighter_id: String) -> bool:
	return MODELS.has(fighter_id)


## The looks of a drawn fighter per skin id, like `FighterModel.LOOKS[fighter_id]`.
static func looks(fighter_id: String) -> Dictionary:
	var model_script: Variant = MODELS[fighter_id]
	return model_script.LOOKS


## Builds the drawn fighter's shapes into `model` (already cleared by `FighterModel.setup`).
static func build(fighter_id: String, model: FighterModel, look: Dictionary) -> void:
	var model_script: Variant = MODELS[fighter_id]
	model_script.build(model, look)
