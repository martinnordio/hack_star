class_name SampleProgress
extends RefCounted
## The progress every game starts with until matches exist (the values of the Svelte game).

const CREDITS: int = 500
const SELECTED_FIGHTER: String = "blaze"
const TROPHIES: Dictionary[String, int] = {
	"blaze": 1240,
	"rocko": 420,
	"turbo": 85,
	"frosty": 0,
	"luna": 0,
	"pixel": 0,
	"beatbolt": 0,
	"flarekid": 0,
	"echo": 0,
	"magmax": 0,
}
const POWER_LEVELS: Dictionary[String, int] = {
	"blaze": 7,
	"rocko": 4,
	"turbo": 2,
	"frosty": 1,
	"luna": 1,
	"pixel": 1,
	"beatbolt": 1,
	"flarekid": 1,
	"echo": 1,
	"magmax": 1,
}
