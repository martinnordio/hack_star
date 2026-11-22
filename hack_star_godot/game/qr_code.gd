class_name QrCode
extends RefCounted
## QR codes (ISO/IEC 18004) in byte mode, error correction level M, versions 1–10. Pure: a text
## in, a square matrix of booleans out (`true` = dark), without the quiet zone. The mask is
## chosen like the reference encoder of the tests (segno): the lowest penalty score of the
## four standard rules, scored before the format and version information are drawn; the first
## mask wins a tie.

const MAX_VERSION: int = 10
## Level M, index = version - 1.
const ECC_PER_BLOCK: Array[int] = [10, 16, 26, 18, 24, 16, 18, 22, 22, 26]
const BLOCKS: Array[int] = [1, 1, 1, 2, 2, 4, 4, 4, 5, 5]
## Centres of the alignment patterns, index = version - 1.
const ALIGNMENT: Array[Array] = [
	[],
	[6, 18],
	[6, 22],
	[6, 26],
	[6, 30],
	[6, 34],
	[6, 22, 38],
	[6, 24, 42],
	[6, 26, 46],
	[6, 28, 50],
]
const MODE_BYTE: int = 0b0100
const LEVEL_M: int = 0b00
const PAD_BYTES: Array[int] = [0xEC, 0x11]
const FORMAT_POLY: int = 0x537
const FORMAT_XOR: int = 0x5412
const VERSION_POLY: int = 0x1F25
const GF_POLY: int = 0x11D
const PENALTY_RUN: int = 3
const PENALTY_BLOCK: int = 3
const PENALTY_FINDER_LIKE: int = 40
const PENALTY_BALANCE: int = 10
const FINDER_LIKE: Array[int] = [1, 0, 1, 1, 1, 0, 1]


## The matrix of `text` (UTF-8 bytes), or an empty array when it does not fit version 10.
static func encode(text: String) -> Array[Array]:
	var data: PackedByteArray = text.to_utf8_buffer()
	var version: int = _version_for_length(data.size())
	var result: Array[Array] = []
	if version == 0:
		return result
	var size: int = size_for_version(version)
	var modules: Array[PackedByteArray] = _grid(size)
	var reserved: Array[PackedByteArray] = _grid(size)
	_draw_function_patterns(modules, reserved, version)
	_draw_codewords(modules, reserved, _codewords(data, version))
	var best: Array[PackedByteArray] = []
	var best_mask: int = 0
	var best_score: int = -1
	for mask: int in 8:
		var masked: Array[PackedByteArray] = _masked(modules, reserved, mask)
		var score: int = _penalty(masked)
		if best_score < 0 or score < best_score:
			best = masked
			best_mask = mask
			best_score = score
	_draw_format(best, best_mask)
	_draw_version(best, version)
	for row: PackedByteArray in best:
		var line: Array[bool] = []
		for value: int in row:
			line.append(value == 1)
		result.append(line)
	return result


## The smallest version that holds `text`, or 0 when it is too long.
static func version_for(text: String) -> int:
	return _version_for_length(text.to_utf8_buffer().size())


static func size_for_version(version: int) -> int:
	return 17 + 4 * version


static func _version_for_length(length: int) -> int:
	for version: int in range(1, MAX_VERSION + 1):
		if 4 + _count_bits(version) + 8 * length <= 8 * _data_codewords(version):
			return version
	return 0


static func _count_bits(version: int) -> int:
	return 8 if version < 10 else 16


static func _total_codewords(version: int) -> int:
	var modules: int = (16 * version + 128) * version + 64
	if version >= 2:
		var count: int = version / 7 + 2
		modules -= (25 * count - 10) * count - 55
		if version >= 7:
			modules -= 36
	return modules / 8


static func _data_codewords(version: int) -> int:
	return _total_codewords(version) - ECC_PER_BLOCK[version - 1] * BLOCKS[version - 1]


static func _grid(size: int) -> Array[PackedByteArray]:
	var grid: Array[PackedByteArray] = []
	for row: int in size:
		var line: PackedByteArray = PackedByteArray()
		line.resize(size)
		grid.append(line)
	return grid


static func _set_function(
	modules: Array[PackedByteArray],
	reserved: Array[PackedByteArray],
	row: int,
	col: int,
	dark: bool
) -> void:
	modules[row][col] = 1 if dark else 0
	reserved[row][col] = 1


static func _draw_function_patterns(
	modules: Array[PackedByteArray], reserved: Array[PackedByteArray], version: int
) -> void:
	var size: int = modules.size()
	for i: int in size:
		_set_function(modules, reserved, 6, i, i % 2 == 0)
		_set_function(modules, reserved, i, 6, i % 2 == 0)
	for centre: Vector2i in [Vector2i(3, 3), Vector2i(3, size - 4), Vector2i(size - 4, 3)]:
		for dr: int in range(-4, 5):
			for dc: int in range(-4, 5):
				var row: int = centre.x + dr
				var col: int = centre.y + dc
				if row >= 0 and row < size and col >= 0 and col < size:
					var ring: int = maxi(absi(dr), absi(dc))
					_set_function(modules, reserved, row, col, ring != 2 and ring != 4)
	var positions: Array = ALIGNMENT[version - 1]
	var last: int = positions.size() - 1
	for i: int in positions.size():
		for j: int in positions.size():
			if (i == 0 and j == 0) or (i == 0 and j == last) or (i == last and j == 0):
				continue
			for dr: int in range(-2, 3):
				for dc: int in range(-2, 3):
					var dark: bool = maxi(absi(dr), absi(dc)) != 1
					_set_function(modules, reserved, positions[i] + dr, positions[j] + dc, dark)
	# Format and version areas and the dark module stay light while the masks are scored.
	for i: int in 9:
		if i == 6:
			continue
		_set_function(modules, reserved, 8, i, false)
		_set_function(modules, reserved, i, 8, false)
	for i: int in 8:
		_set_function(modules, reserved, 8, size - 1 - i, false)
		_set_function(modules, reserved, size - 1 - i, 8, false)
	if version >= 7:
		for i: int in 18:
			_set_function(modules, reserved, i / 3, size - 11 + i % 3, false)
			_set_function(modules, reserved, size - 11 + i % 3, i / 3, false)


static func _codewords(data: PackedByteArray, version: int) -> PackedByteArray:
	var capacity_bits: int = 8 * _data_codewords(version)
	var bits: Array[int] = []
	_append_bits(bits, MODE_BYTE, 4)
	_append_bits(bits, data.size(), _count_bits(version))
	for value: int in data:
		_append_bits(bits, value, 8)
	_append_bits(bits, 0, mini(4, capacity_bits - bits.size()))
	# Like the reference (segno), the padding to a whole byte is a full zero byte when the
	# stream already ends on one; readers stop at the terminator, so it changes nothing for them.
	_append_bits(bits, 0, 8 - bits.size() % 8)
	bits.resize(mini(bits.size(), capacity_bits))
	var pad: int = 0
	while bits.size() < capacity_bits:
		_append_bits(bits, PAD_BYTES[pad % 2], 8)
		pad += 1
	var data_codewords: PackedByteArray = PackedByteArray()
	for i: int in range(0, bits.size(), 8):
		var value: int = 0
		for bit: int in 8:
			value = (value << 1) | bits[i + bit]
		data_codewords.append(value)
	return _interleave_with_ecc(data_codewords, version)


static func _append_bits(bits: Array[int], value: int, count: int) -> void:
	for i: int in range(count - 1, -1, -1):
		bits.append((value >> i) & 1)


static func _interleave_with_ecc(data: PackedByteArray, version: int) -> PackedByteArray:
	var total: int = _total_codewords(version)
	var block_count: int = BLOCKS[version - 1]
	var ecc_length: int = ECC_PER_BLOCK[version - 1]
	var short_blocks: int = block_count - total % block_count
	var short_length: int = total / block_count - ecc_length
	var divisor: PackedByteArray = _rs_divisor(ecc_length)
	var data_blocks: Array[PackedByteArray] = []
	var ecc_blocks: Array[PackedByteArray] = []
	var start: int = 0
	for block: int in block_count:
		var length: int = short_length + (0 if block < short_blocks else 1)
		var part: PackedByteArray = data.slice(start, start + length)
		start += length
		data_blocks.append(part)
		ecc_blocks.append(_rs_remainder(part, divisor))
	var result: PackedByteArray = PackedByteArray()
	for i: int in short_length + 1:
		for part: PackedByteArray in data_blocks:
			if i < part.size():
				result.append(part[i])
	for i: int in ecc_length:
		for part: PackedByteArray in ecc_blocks:
			result.append(part[i])
	return result


static func _gf_multiply(a: int, b: int) -> int:
	var result: int = 0
	for i: int in range(7, -1, -1):
		result = (result << 1) ^ ((result >> 7) * GF_POLY)
		result ^= ((b >> i) & 1) * a
	return result


## Generator polynomial of the Reed–Solomon code, highest coefficient first, leading 1 left out.
static func _rs_divisor(degree: int) -> PackedByteArray:
	var result: PackedByteArray = PackedByteArray()
	result.resize(degree)
	result[degree - 1] = 1
	var root: int = 1
	for i: int in degree:
		for j: int in degree:
			result[j] = _gf_multiply(result[j], root)
			if j + 1 < degree:
				result[j] ^= result[j + 1]
		root = _gf_multiply(root, 0x02)
	return result


static func _rs_remainder(data: PackedByteArray, divisor: PackedByteArray) -> PackedByteArray:
	var result: PackedByteArray = PackedByteArray()
	result.resize(divisor.size())
	for value: int in data:
		var factor: int = value ^ result[0]
		result.remove_at(0)
		result.append(0)
		for i: int in divisor.size():
			result[i] ^= _gf_multiply(divisor[i], factor)
	return result


static func _draw_codewords(
	modules: Array[PackedByteArray], reserved: Array[PackedByteArray], codewords: PackedByteArray
) -> void:
	var size: int = modules.size()
	var bit: int = 0
	var total_bits: int = codewords.size() * 8
	var right: int = size - 1
	while right >= 1:
		if right == 6:
			right = 5
		var upward: bool = ((right + 1) & 2) == 0
		for vertical: int in size:
			var row: int = size - 1 - vertical if upward else vertical
			for j: int in 2:
				var col: int = right - j
				if reserved[row][col] == 0 and bit < total_bits:
					modules[row][col] = (codewords[bit >> 3] >> (7 - (bit & 7))) & 1
					bit += 1
		right -= 2


static func _masked(
	modules: Array[PackedByteArray], reserved: Array[PackedByteArray], mask: int
) -> Array[PackedByteArray]:
	var result: Array[PackedByteArray] = []
	for row: int in modules.size():
		var line: PackedByteArray = modules[row].duplicate()
		for col: int in line.size():
			if reserved[row][col] == 0 and _mask_bit(mask, row, col):
				line[col] ^= 1
		result.append(line)
	return result


static func _mask_bit(mask: int, row: int, col: int) -> bool:
	match mask:
		0:
			return (row + col) % 2 == 0
		1:
			return row % 2 == 0
		2:
			return col % 3 == 0
		3:
			return (row + col) % 3 == 0
		4:
			return (row / 2 + col / 3) % 2 == 0
		5:
			return (row * col) % 2 + (row * col) % 3 == 0
		6:
			return ((row * col) % 2 + (row * col) % 3) % 2 == 0
		_:
			return ((row + col) % 2 + (row * col) % 3) % 2 == 0


static func _penalty(modules: Array[PackedByteArray]) -> int:
	var size: int = modules.size()
	var score: int = 0
	var dark: int = 0
	for i: int in size:
		var row: PackedByteArray = modules[i]
		var column: PackedByteArray = PackedByteArray()
		for j: int in size:
			column.append(modules[j][i])
			dark += row[j]
			if (
				i > 0
				and j > 0
				and row[j] == row[j - 1]
				and row[j] == modules[i - 1][j]
				and row[j] == modules[i - 1][j - 1]
			):
				score += PENALTY_BLOCK
		score += _run_penalty(row) + _run_penalty(column)
		score += _finder_like_penalty(row) + _finder_like_penalty(column)
	var total: int = size * size
	score += PENALTY_BALANCE * (absi(20 * dark - 10 * total) / total)
	return score


static func _run_penalty(line: PackedByteArray) -> int:
	var score: int = 0
	var run: int = 1
	for i: int in range(1, line.size() + 1):
		if i < line.size() and line[i] == line[i - 1]:
			run += 1
			continue
		if run >= 5:
			score += PENALTY_RUN + run - 5
		run = 1
	return score


## Dark-light-dark-dark-dark-light-dark with four light modules (or the edge) before or after;
## a match is counted once, and the search goes on after it.
static func _finder_like_penalty(line: PackedByteArray) -> int:
	var score: int = 0
	var index: int = _find_finder_like(line, 0)
	while index != -1:
		var next: int = index + FINDER_LIKE.size()
		if _is_light(line, index - 4, index) or _is_light(line, next, next + 4):
			score += PENALTY_FINDER_LIKE
		else:
			next = index + 4
		index = _find_finder_like(line, next)
	return score


static func _find_finder_like(line: PackedByteArray, from: int) -> int:
	for start: int in range(from, line.size() - FINDER_LIKE.size() + 1):
		var found: bool = true
		for k: int in FINDER_LIKE.size():
			if line[start + k] != FINDER_LIKE[k]:
				found = false
				break
		if found:
			return start
	return -1


static func _is_light(line: PackedByteArray, from: int, to: int) -> bool:
	for i: int in range(maxi(from, 0), mini(to, line.size())):
		if line[i] == 1:
			return false
	return true


static func _draw_format(modules: Array[PackedByteArray], mask: int) -> void:
	var size: int = modules.size()
	var data: int = (LEVEL_M << 3) | mask
	var remainder: int = data
	for i: int in 10:
		remainder = (remainder << 1) ^ ((remainder >> 9) * FORMAT_POLY)
	var bits: int = ((data << 10) | remainder) ^ FORMAT_XOR
	for i: int in 15:
		var value: int = (bits >> i) & 1
		if i < 6:
			modules[i][8] = value
		elif i < 8:
			modules[i + 1][8] = value
		elif i == 8:
			modules[8][7] = value
		else:
			modules[8][14 - i] = value
		if i < 8:
			modules[8][size - 1 - i] = value
		else:
			modules[size - 15 + i][8] = value
	modules[size - 8][8] = 1


static func _draw_version(modules: Array[PackedByteArray], version: int) -> void:
	if version < 7:
		return
	var size: int = modules.size()
	var remainder: int = version
	for i: int in 12:
		remainder = (remainder << 1) ^ ((remainder >> 11) * VERSION_POLY)
	var bits: int = (version << 12) | remainder
	for i: int in 18:
		var value: int = (bits >> i) & 1
		modules[i / 3][size - 11 + i % 3] = value
		modules[size - 11 + i % 3][i / 3] = value
