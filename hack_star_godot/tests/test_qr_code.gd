extends GutTest
## The references in tests/fixtures/qr_<name>.txt (one row per line, 1 = dark, no quiet zone)
## were made once with segno 1.6.6, from hack_star_godot/, for each <text> and <name> below:
##   uv run --no-project --with segno==1.6.6 python -c "import segno, sys; q = segno.make(
##   sys.argv[1], error='m', mode='byte', boost_error=False, micro=False); open('tests/fixtures/
##   qr_' + sys.argv[2] + '.txt', 'w', newline='\n').write(''.join(''.join(str(v) for v in r)
##   + '\n' for r in q.matrix)); print(q.version, q.mask)" "<text>" <name>

const LINK: String = "http://localhost:8060/?hack=OPENSESAME"
const LINK_START: String = "http://localhost:8060/?hack=OPENSESAME&from=qr-page&pad="


func _link_of_length(length: int) -> String:
	return LINK_START + "x".repeat(length - LINK_START.length())


func _reference(name: String) -> Array[Array]:
	var text: String = FileAccess.get_file_as_string("res://tests/fixtures/qr_%s.txt" % name)
	var result: Array[Array] = []
	for line: String in text.split("\n", false):
		var row: Array[bool] = []
		for module: String in line.strip_edges():
			row.append(module == "1")
		result.append(row)
	return result


func _assert_matches_reference(text: String, name: String) -> void:
	var expected: Array[Array] = _reference(name)
	assert_gt(expected.size(), 0, "reference %s is missing" % name)
	assert_eq(QrCode.encode(text), expected, name)


func test_infinity_matches_the_reference() -> void:
	_assert_matches_reference("INFINITY", "infinity")


func test_link_matches_the_reference() -> void:
	_assert_matches_reference(LINK, "link")


func test_100_character_link_matches_the_reference() -> void:
	var text: String = _link_of_length(100)
	assert_eq(text.length(), 100)
	_assert_matches_reference(text, "link100")


func test_150_character_link_with_version_information_matches_the_reference() -> void:
	_assert_matches_reference(_link_of_length(150), "link150")


func test_versions_and_sizes() -> void:
	assert_eq(QrCode.version_for("INFINITY"), 1)
	assert_eq(QrCode.version_for(LINK), 3)
	assert_eq(QrCode.version_for(_link_of_length(100)), 6)
	assert_eq(QrCode.version_for(_link_of_length(150)), 8)
	assert_eq(QrCode.version_for("x".repeat(14)), 1)
	assert_eq(QrCode.version_for("x".repeat(15)), 2)
	assert_eq(QrCode.version_for("x".repeat(213)), 10)
	assert_eq(QrCode.size_for_version(1), 21)
	assert_eq(QrCode.size_for_version(10), 57)
	var matrix: Array[Array] = QrCode.encode("x".repeat(213))
	assert_eq(matrix.size(), 57)
	assert_eq(matrix[0].size(), 57)


func test_too_long_text_gives_an_empty_matrix() -> void:
	assert_eq(QrCode.version_for("x".repeat(214)), 0)
	assert_eq(QrCode.encode("x".repeat(214)), [])
