extends AoC_Day

func parse_points(inp):
	var list = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		var pos = line.split(",")
		var vec = Vector2i(int(pos[0]),int(pos[1]))
		list.append(vec)
	return list

func get_max_area(points):
	var max_area = null
	for i in range(len(points)):
		for j in range(i+1,len(points)):
			var area = calc_area(points[i],points[j])
			if max_area == null or area > max_area[0]:
				max_area = [area,[points[i],points[j]]]
	return max_area

func get_max_area2(points):
	var max_area = null
	for i in range(len(points)):
		var line_idx = [i,(i+1) % len(points)]
		var line = [points[line_idx[0]],points[line_idx[1]]]
		var prev_idx = line_idx[0] - 1
		if prev_idx == -1:
			prev_idx = len(points)-1
		var next_idx = line_idx[1] + 1
		if next_idx == len(points):
			next_idx = 0
		var prev_p = points[prev_idx]
		var next_p = points[next_idx]
		var rect = null
		if line[0].x == line[1].x:
			# shared axis is x
			var lx = line[0].x
			var prev_sign = sign(prev_p.x - lx)
			var next_sign = sign(next_p.x - lx)
			if prev_sign == next_sign:
				if prev_sign == 0:
					rect = [line[0],next_p]
				elif prev_sign == -1:
					if next_p.x >= prev_p.x:
						rect = [line[0],next_p]
				else:
					assert(prev_sign == 1)
					if next_p.x <= prev_p.x:
						rect = [line[0],next_p]
		else:
			# the should share a y axis coord
			assert(line[0].y == line[1].y)
			var ly = line[0].y
			var prev_sign = sign(prev_p.y - ly)
			var next_sign = sign(next_p.y - ly)
			if prev_sign == next_sign:
				if prev_sign == 0:
					rect = [line[0],next_p]
				elif prev_sign == -1:
					if next_p.y >= prev_p.y:
						rect = [line[0],next_p]
				else:
					assert(prev_sign == 1)
					if next_p.y <= prev_p.y:
						rect = [line[0],next_p]
		if rect != null:
			var area = calc_area(rect[0],rect[1])
			if max_area == null or area > max_area[0]:
				max_area = [area,[rect[0],rect[1]]]
	return max_area

func calc_move(p1:Vector2i,p2:Vector2i):
	var dir = [sign(p1.x - p2.x), sign(p1.y - p2.y)]
	var move = ""
	if dir[0] == -1:
		move = "right"
	elif dir[0] == 1:
		move = "left"
	elif dir[1] == -1:
		move = "down"
	elif dir[1] == 1:
		move = "up"
	return move

func check_rects(points,idx,step):
	var rects = []
	var prev = idx
	var moves = []
	for i in range(1,4):
		var next = prev + step
		if next < 0:
			next += len(points)
		if next >= len(points):
			next -= len(points)
		var p1:Vector2i = points[prev]
		var p2:Vector2i = points[next]
		var dir = [sign(p1.x - p2.x), sign(p1.y - p2.y)]
		var move = ""
		if dir[0] == -1:
			move = "left"
		elif dir[0] == 1:
			move = "right"
		elif dir[1] == -1:
			move = "up"
		elif dir[1] == 1:
			move = "down"
		assert(move != "")
		if move in moves:
			break
		moves.append(move)
		rects.append([idx,next])
		prev = next
	return rects
	
func calc_area(p1:Vector2i,p2:Vector2i):
	return (abs(p2.x - p1.x)+1) * (abs(p2.y - p1.y)+1)

func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day9", TEST_MODE)
	
	var points = parse_points(inp)
	var biggest = get_max_area(points)
	print("The largest rectangle you can make has area %d." % biggest[0])
	print("One way to do this is between %s and %s" % [biggest[1][0], biggest[1][1]])
	return biggest[0]

func compress_coords(points):
	var Xmap = {}
	var Ymap = {}
	var XRmap = {}
	var YRmap = {}
	var X = []
	var Y = []
	for p in points:
		X.append(p.x)
		Y.append(p.y)
	X.sort()
	Y.sort()
	var xi = 0
	var yi = 0
	for x in X:
		if x in Xmap:
			continue
		Xmap[x] = xi
		XRmap[xi] = x
		xi += 1
	for y in Y:
		if y in Ymap:
			continue
		Ymap[y] = yi
		YRmap[yi] = y
		yi += 1
	var compressed_coords = []
	for p in points:
		compressed_coords.append(Vector2i(Xmap[p.x],Ymap[p.y]))
	return [compressed_coords,[Xmap,Ymap],[XRmap,YRmap]]

func build_grid(points):
	var grid = []
	var maxX = null
	var maxY = null
	for p in points:
		if maxX == null or p.x > maxX:
			maxX = p.x
		if maxY == null or p.y > maxY:
			maxY = p.y
	for y in range(maxY+1):
		var row = []
		for x in range(maxX+1):
			row.append(" ")
		grid.append(row)
	for idx in range(len(points)):
		var p1 = points[idx]
		grid[p1.y][p1.x] = "#"
		var p2 = points[0]
		if idx != len(points) - 1:
			p2 = points[idx+1]
		var x = p1.x
		var y = p1.y
		while x < p2.x:
			x += 1
			if x != p2.x:
				grid[y][x] = "X"
		while x > p2.x:
			x -= 1
			if x != p2.x:
				grid[y][x] = "X"
		while y < p2.y:
			y += 1
			if y != p2.y:
				grid[y][x] = "X"
		while y > p2.y:
			y -= 1
			if y != p2.y:
				grid[y][x] = "X"
	
	var next = [[0,0],[len(grid[0])-1,0],[0,len(grid)-1],[len(grid[0])-1,len(grid)-1]]
	while len(next) > 0:
		var p = next.pop_front()
		if grid[p[1]][p[0]] != " ":
			continue
		grid[p[1]][p[0]] = "."
		if p[0] > 0:
			next.append([p[0]-1,p[1]])
		if p[0] < len(grid[0]) - 1:
			next.append([p[0]+1,p[1]])
		if p[1] > 0:
			next.append([p[0],p[1]-1])
		if p[1] < len(grid) - 1:
			next.append([p[0],p[1]+1])
	for row in grid:
		for i in range(len(row)):
			if row[i] == " ":
				row[i] = "X"
	return grid

func str_grid(grid):
	var s = ""
	for row in grid:
		s = s + "".join(row) + "\n"
	return s

func find_points_in_rect(points,rect):
	var inner_points = []
	var p1 = rect[0]
	var p2 = rect[1]
	var min_x = min(p1.x,p2.x)
	var max_x = max(p1.x,p2.x)
	var min_y = min(p1.y,p2.y)
	var max_y = max(p1.y,p2.y)
	for p in points:
		if p == p1:
			continue
		if p.x >= min_x and p.x <= max_x and p.y >= min_y and p.y <= max_y:
			inner_points.append(p)
	return inner_points

func valid_rect(grid,p1,p2):
	for x in range(p1.x,p2.x+1):
		if grid[p1.y][x] == ".":
			return false
		if grid[p2.y][x] == ".":
			return false
	for x in range(p2.x,p1.x+1):
		if grid[p1.y][x] == ".":
			return false
		if grid[p2.y][x] == ".":
			return false
	for y in range(p1.y,p2.y+1):
		if grid[y][p1.x] == ".":
			return false
		if grid[y][p2.x] == ".":
			return false
	for y in range(p2.y,p1.y+1):
		if grid[y][p1.x] == ".":
			return false
		if grid[y][p2.x] == ".":
			return false
	return true

func verify_rects(grid,start,candidates):
	var valid = []
	for c in candidates:
		if valid_rect(grid,start,c):
			valid.append([start,c])
	return valid

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day9", TEST_MODE)
	
	var points = parse_points(inp)
	var compressed = compress_coords(points)
	var comp_points = compressed[0]
	var XYmap = compressed[1]
	var XYRmap = compressed[2]
	#print(compressed)
	var grid = build_grid(comp_points)
	if TEST_MODE:
		print(str_grid(grid))
	else:
		var sgrid = str_grid(grid)
		var file:FileAccess = FileAccess.open("res://day9.out", FileAccess.WRITE)
		file.store_string(sgrid)
		file.close()
	var max_x = len(grid[0])-1
	var max_y = len(grid)-1
	var biggest = null
	for p1 in comp_points:
		var next_x = p1.x
		var next_y = p1.y
		if p1.x == 0 or grid[p1.y][p1.x-1] == ".":
			next_x = p1.x + 1
			while next_x < max_x and grid[p1.y][next_x] != ".":
				next_x += 1
		elif p1.x == max_x or grid[p1.y][p1.x+1] == ".":
			next_x = p1.x - 1
			while next_x > 0 and grid[p1.y][next_x] != ".":
				next_x -= 1
		if p1.y == 0 or grid[p1.y-1][p1.x] == ".":
			next_y = p1.y + 1
			while next_y < max_y and grid[next_y][p1.x] != ".":
				next_y += 1
		elif p1.y == max_y or grid[p1.y+1][p1.x] == ".":
			next_y = p1.y - 1
			while next_y > 0 and grid[next_y][p1.x] != ".":
				next_y -= 1
		var p2 = Vector2i(next_x,next_y)
		print("Possible Rect Area: [%s,%s]" % [p1,p2])
		var candidates = find_points_in_rect(comp_points,[Vector2i(0,0),Vector2i(max_x,max_y)])
		print("Rect candidates: %s" % [candidates])
		var valid_rects = verify_rects(grid,p1,candidates)
		print("Of those, these are valid: %s" % [ valid_rects ])
		for rect in valid_rects:
			var cp1 = rect[0]
			var cp2 = rect[1]
			var ucp1 = Vector2i(XYRmap[0][cp1.x],XYRmap[1][cp1.y])
			var ucp2 = Vector2i(XYRmap[0][cp2.x],XYRmap[1][cp2.y])
			var area = (abs(ucp1.x - ucp2.x)+1) * (abs(ucp1.y - ucp2.y)+1)
			if biggest == null or area > biggest[0]:
				biggest = [area,[ucp1,ucp2]]
	print("The largest rectangle you can make has area %d." % biggest[0])
	print("One way to do this is between %s and %s" % [biggest[1][0], biggest[1][1]])
	return biggest[0]
