extends AoC_Day

func str_bank(bank):
	return "".join(bank)

func parse_banks(inp):
	var banks = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		var bank = []
		for c in line:
			bank.append(int(c))
		banks.append(bank)
	return banks

func get_max_joltage(bank,batteries):
	var subjolts = []
	var last_idx = -1
	for nb in range(1,batteries+1):
		var M = bank.slice(last_idx+1,len(bank) - (batteries-nb)).max()
		last_idx = bank.find(M,last_idx+1)
		subjolts.append(M)
	return int("".join(subjolts))
	
func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day3",TEST_MODE)
	
	var banks = parse_banks(inp)
	var sum = 0
	for bank in banks:
		var joltage = get_max_joltage(bank,2)
		sum += joltage
		AoC.dprint("For bank %s the best joltage is %d" % [str_bank(bank), joltage])
	AoC.dprint("Total output joltage: %d" % sum)
	return sum

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day3",TEST_MODE)
	
	var banks = parse_banks(inp)
	var sum = 0
	
	for bank in banks:
		var joltage = get_max_joltage(bank,12)
		sum += joltage
		AoC.dprint("For bank %s the best joltage is %d" % [str_bank(bank), joltage])
	AoC.dprint("Total output joltage: %d" % sum)
	return sum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
