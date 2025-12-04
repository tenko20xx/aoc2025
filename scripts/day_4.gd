extends AoC_Day

func print_map(map,col_delim="",row_delim="\n"):
	var printable_rows = []
	for row in map:
		printable_rows.append(col_delim.join(row))
	var printable_map = row_delim.join(printable_rows)
	print(printable_map)
	
func parse_paper_map(inp):
	var paper_map = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		paper_map.append(line)
	return paper_map

func paper_map_get_offset(paper_map, row, col, offset_y = 0, offset_x = 0):
	if offset_x == 0 and offset_y == 0:
		return paper_map[row][col]
	if row + offset_y < 0:
		return "."
	if row + offset_y >= len(paper_map):
		return "."
	if col + offset_x < 0:
		return "."
	if col + offset_x >= len(paper_map[row+offset_y]):
		return "."
	return paper_map[row + offset_y][col + offset_x]

func paper_map_get_adjcent_positions(paper_map, row, col):
	var adj_pos = []
	for y in range(-1,2):
		for x in range(-1,2):
			if y == 0 and x == 0:
				continue
			adj_pos.append(paper_map_get_offset(paper_map, row, col, y, x))
	return adj_pos

func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day4",TEST_MODE)
	
	var paper_map = parse_paper_map(inp)
	var sum = 0
	var fork_map = []
	for row in range(len(paper_map)):
		var fm_row = []
		for col in range(len(paper_map[row])):
			if paper_map[row][col] != "@":
				fm_row.append(".")
				continue
			var adj_pos = paper_map_get_adjcent_positions(paper_map, row, col)
			if adj_pos.count("@") < 4:
				sum += 1
				fm_row.append("x")
			else:
				#if row == 0:
				#	print("Row: %d, Col: %d" % [row, col])
				#	print(adj_pos)
				fm_row.append("@")
		fork_map.append(fm_row)
	if AoC.DEBUG:
		print_map(fork_map)
	AoC.dprint("There are %d rolls of paper that can be accessed." % sum)
	return sum

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day4",TEST_MODE)
	
	var paper_map = parse_paper_map(inp)
	var sum = 0
	var fork_map = []
	var updated = true
	while updated:
		updated = false
		var empty_pos = []
		for row in range(len(paper_map)):
			var fm_row = []
			for col in range(len(paper_map[row])):
				if paper_map[row][col] != "@":
					fm_row.append(".")
					continue
				var adj_pos = paper_map_get_adjcent_positions(paper_map, row, col)
				if adj_pos.count("@") < 4:
					sum += 1
					fm_row.append("x")
					empty_pos.append([row,col])
					updated = true
				else:
					#if row == 0:
					#	print("Row: %d, Col: %d" % [row, col])
					#	print(adj_pos)
					fm_row.append("@")
			fork_map.append(fm_row)
		if AoC.DEBUG:
			print_map(fork_map)
			print(" ")
		for pos in empty_pos:
			var row = pos[0]
			var col = pos[1]
			paper_map[row][col] = "."
	AoC.dprint("There are %d rolls of paper that can be accessed." % sum)
	return sum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
