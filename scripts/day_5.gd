extends AoC_Day

func parse_ingredients(inp):
	var fresh_ranges = []
	var available_ingredients = []
	var state = 0
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			state += 1
			continue
		if state > 1:
			break
		if state == 0:
			var rng = IntRange.new()
			rng.parse_and_apply(line)
			var is_present = false
			var rem_ranges = []
			for i in range(len(fresh_ranges)):
				var fr:IntRange = fresh_ranges[i]
				if rng.low >= fr.low and rng.high <= fr.high:
					print("Range %s is inside range %s" % [rng.to_str(), fr.to_str()])
					is_present = true
					break
				elif fr.low >= rng.low and fr.high <= rng.high:
					print("Range %s is inside range %s" % [fr.to_str(), rng.to_str()])
					rem_ranges.append(i)
				elif rng.low < fr.low and rng.high >= fr.low - 1:
					print("Range %s extends range %s from below" % [rng.to_str(), fr.to_str()])
					rng.high = fr.high
					rem_ranges.append(i)
				elif rng.high > fr.high and rng.low <= fr.high + 1:
					print("Range %s extends range %s from above" % [rng.to_str(), fr.to_str()])
					rng.low = fr.low
					rem_ranges.append(i)
			rem_ranges.sort()
			rem_ranges.reverse()
			for ri in rem_ranges:
				fresh_ranges.remove_at(ri)
			if not is_present:
				fresh_ranges.append(rng)
		elif state == 1:
			available_ingredients.append(int(line))
	return [fresh_ranges, available_ingredients]
	
func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day5",TEST_MODE)
	
	var parsed = parse_ingredients(inp)
	var fresh_ranges = parsed[0]
	var available_ingredients = parsed[1]
	
	print(len(fresh_ranges))
	
	var sum = 0
	var first_spoil = true
	for ing in available_ingredients:
		var found = false
		for rng:IntRange in fresh_ranges:
			if rng.in_range(ing):
				AoC.dprint("Ingredient ID %d is fresh because it falls into range %s" % [ing, rng.to_str()])
				found = true
				break
		if found:
			sum += 1
		else:
			if first_spoil:
				AoC.dprint("Ingredient ID %d is spoiled because it does not fall into any range" % ing)
				first_spoil = false
			else:
				AoC.dprint("Ingredient ID %d is spoiled" % ing)
	AoC.dprint("%d of the available ingredient IDs are fresh" % sum)
	return sum

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day5",TEST_MODE)
	
	var parsed = parse_ingredients(inp)
	var fresh_ranges = parsed[0]
	
	print(len(fresh_ranges))
	
	var sum = 0
	for rng:IntRange in fresh_ranges:
		var diff = rng.high - rng.low + 1
		AoC.dprint("Range %s has %d values" %[rng.to_str(), diff])
		sum += diff
	AoC.dprint("The fresh ingredient ID ranges consider a total of %d ingredient IDs to be fresh" % sum)
	return sum
