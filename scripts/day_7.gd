extends AoC_Day

class BTreeNode:
	var pos = null
	var val = null
	var left:BTreeNode = null
	var right:BTreeNode = null
	
func find_next_node(node_map,pos):
	var row = pos[0]
	var col = pos[1]
	while row < len(node_map):
		if node_map[row][col] != null:
			return node_map[row][col]
		row += 1
	return null

func build_node_map(map):
	var node_map = []
	for ri in range(len(map)):
		var row = []
		for ci in range(len(map[ri])):
			var ch = map[ri][ci]
			if ch == ".":
				row.append(null)
			elif ch == "^":
				var node = BTreeNode.new()
				node.pos = [ri,ci]
				row.append(node)
		node_map.append(row)
	return node_map

func beam_tree(map):
	var node_map = build_node_map(map)
	var start = find_start(map)
	var root = find_next_node(node_map,start)
	
	var visited_map = []
	for mr in map:
		var row = []
		for mc in mr:
			row.append(false)
		visited_map.append(row)
	
	var nodes = [root]
	while nodes:
		var node = nodes.pop_front()
		var row = node.pos[0]
		var col = node.pos[1]
		if visited_map[row][col]:
			continue
		col = node.pos[1] - 1
		if col >= 0:
			row = node.pos[0]
			var next = find_next_node(node_map,[row,col])
			if next != null:
				node.left = next
				var pos = next.pos
				if not visited_map[pos[0]][pos[1]]:
					nodes.append(next)
		col = node.pos[1] + 1
		if col < len(map):
			row = node.pos[0]
			var next = find_next_node(node_map,[row,col])
			if next != null:
				node.right = next
				var pos = next.pos
				if not visited_map[pos[0]][pos[1]]:
					nodes.append(next)
		visited_map[node.pos[0]][node.pos[1]] = true
	return root

func count_nodes(node):
	if node == null:
		return 0
	if node.val == 1:
		return 0
	node.val = 1
	return 1 + count_nodes(node.left) + count_nodes(node.right)

func count_branches(node):
	if node == null:
		return 0
	if node.val:
		return node.val
	var c = 0
	if node.left != null:
		c += count_branches(node.left)
	else:
		c += 1
	if node.right != null:
		c += count_branches(node.right)
	else:
		c += 1
	node.val = c
	return c

func parse_map(inp):
	var map = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		var row = []
		for ch in line:
			row.append(ch)
		map.append(row)
	return map

func find_start(map):
	for ri in range(len(map)):
		for ci in range(len(map[ri])):
			if map[ri][ci] == "S":
				return [ri, ci]
	return null

func advance_beam(map, beam):
	var pos = [beam[0], beam[1]]
	while pos[0] < len(map) and map[pos[0]][pos[1]] != "^":
		pos[0] += 1
	return pos

func copy_map(map):
	var copy = []
	for mr in map:
		var row = []
		for mc in mr:
			row.append(mc)
		copy.append(row)
	return copy

func str_map(map):
	var str_rows = []
	for row in map:
		str_rows.append("".join(row))
	return "\n".join(str_rows)

func solve_part1():
	return solve_part1_method2()

func solve_part1_method1():
	var inp = ""
	inp = AoC.load_input_from_file("day7",TEST_MODE)
	var map = parse_map(inp)
	var beam_map = copy_map(map)
	var beams = [find_start(map)]
	var sum = 0
	while beams:
		#print(beams)
		var beam = beams.pop_front()
		var new_pos = advance_beam(map,beam)
		if new_pos[0] < len(map):
			# must have hit a splitter
			if beam_map[new_pos[0]][new_pos[1]] != "^":
				continue
			beam_map[new_pos[0]][new_pos[1]] = "#"
			sum += 1
			var beam_row = beam_map[new_pos[0]]
			#print(beam_row)
			#print("".join(beam_row.slice(new_pos[1]-1,new_pos[1]+2)))
			if new_pos[1] > 0:
				if beam_row[new_pos[1]-1] == ".":
					beams.append([new_pos[0],new_pos[1]-1])
					beam_map[new_pos[0]][new_pos[1]-1] = "|"
			if new_pos[1] < len(map[new_pos[0]]) - 1:
				if beam_row[new_pos[1]+1] == ".":
					beams.append([new_pos[0],new_pos[1]+1])
					beam_map[new_pos[0]][new_pos[1]+1] = "|"
		var ri_start = beam[0]
		var ri_end = new_pos[0]
		for ri in range(ri_start,ri_end):
			beam_map[ri][beam[1]] = "|"
		if AoC.DEBUG:
			#if beam[0] != last_row:
			#	last_row = beam[0]
			print(str_map(beam_map))
			print(" -- %d splits -- " % sum)
	
	AoC.dprint("A tachyon beam is split a total of %d times" % [sum])
	return sum

func solve_part1_method2():
	var inp = ""
	inp = AoC.load_input_from_file("day7",TEST_MODE)
	var map = parse_map(inp)
	var root = beam_tree(map)
	var total_nodes = count_nodes(root)
	AoC.dprint("A tachyon beam is split a total of %d times" % [total_nodes])
	return total_nodes
	
func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day7",TEST_MODE)
	var map = parse_map(inp)
	var root = beam_tree(map)
	var total_timelines = count_branches(root)
	AoC.dprint("the particle ends up on %d different timelines" % [total_timelines])
	return total_timelines
	
