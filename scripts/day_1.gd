extends AoC_Day

func how_many_times(n):
	if n == 1:
		return "once"
	elif n == 2:
		return "twice"
	return "%d times" % n

func get_rotations(inp):
	var ret = []
	for line in inp.split("\n"):
		if not line:
			continue
		if line[0] == "L":
			ret.append(-1 * int(line.substr(1)))
		elif line[0] == "R":
			ret.append(int(line.substr(1)))
	return ret

func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day1",TEST_MODE)
	
	var rots = get_rotations(inp)
	var dial = 50
	var pw = 0
	AoC.dprint("The dial starts at %d" % dial)
	for rot in rots:
		dial += rot
		dial = dial % 100
		if dial < 0:
			dial += 100
		var srot = ("L" if rot < 0 else "R") + str(abs(rot))
		AoC.dprint("The dial is rotated %s to point to %d" % [srot, dial])
		if dial == 0:
			pw += 1
	return pw
	
func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day1",TEST_MODE)
	
	var rots = get_rotations(inp)
	var dial = 50
	var pw = 0
	AoC.dprint("The dial starts at %d" % dial)
	for rot in rots:
		var zeros = 0
		if dial == 0 and rot < 0:
			zeros -= 1
		dial += rot
		if dial == 0:
			pw += 1
		elif dial == 100:
			dial = 0
			pw += 1
		else:
			while dial < 0:
				dial += 100
				zeros += 1
				if dial == 0:
					pw += 1
			while dial > 99:
				dial -= 100
				zeros += 1
		var srot = ("L" if rot < 0 else "R") + str(abs(rot))
		var more = ""
		assert(zeros >= 0)
		if zeros > 0:
			more = "; during this rotation, it clicks at zero %s" % how_many_times(zeros)
		AoC.dprint("The dial is rotated %s to point to %d%s" % [srot, dial, more])
		pw += zeros
	AoC.dprint(pw)
	return pw

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
