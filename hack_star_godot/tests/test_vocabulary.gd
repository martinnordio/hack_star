extends GutTest

const WORDS: Array[String] = [
	"Brawler / fighter",
	"Trophies",
	"Prestige",
	"Power level",
	"Rarity",
	"Skin",
	"Legendary skin",
	"Credits",
	"Super",
	"Gadget",
	"Star Power",
	"Hypercharge",
	"Showdown",
	"Gem Grab",
	"Brawl Ball",
	"Bush",
	"Main",
	"Push / pushing",
	"Camping",
	"Tank",
	"Starr Drop",
	"Brawl Pass",
	"GG",
	"Hack code",
]


func test_has_every_word_of_the_vocabulary() -> void:
	var words: Array[String] = []
	for entry: Dictionary in Vocabulary.LIST:
		words.append(entry["word"])
	assert_eq(words, WORDS)


func test_every_word_has_a_meaning() -> void:
	for entry: Dictionary in Vocabulary.LIST:
		assert_false(String(entry["meaning"]).strip_edges().is_empty(), entry["word"])
