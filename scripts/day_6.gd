extends AoC_Day

func sum(vals):
	var s = 0
	for v in vals:
		s += v
	return s

func product(vals):
	var p = 1
	for v in vals:
		p *= v
	return p

func str_table(table):
	var stable = []
	
	for ri in range(len(table)):
		var srow = []
		for ci in range(len(table[ri])):
			srow.append(str(table[ri][ci]))
		stable.append(srow)
	
	var lines = []
	for row in stable:
		var line = ""
		for col in row:
			if line != "":
				line = line + " "
			line = line + col.rpad(5)
		lines.append(line)
	return "\n".join(lines)

func split_on_whitespace(line):
	var vals = []
	var this_val = ""
	for ch in line:
		if ch in [" ","\t"]:
			if this_val != "":
				vals.append(this_val)
				this_val = ""
		else:
			this_val += ch
	if this_val != "":
		vals.append(this_val)
	return vals

func parse_table(inp):
	var table = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		table.append(split_on_whitespace(line))
	
	for ri in range(len(table)-1):
		for ci in range(len(table[ri])):
			table[ri][ci] = int(table[ri][ci])
	return table

func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day6",TEST_MODE)
	
	var table = parse_table(inp)
	print(str_table(table))
	
	var sum = 0
	for ci in range(len(table[0])):
		var vals = []
		for ri in range(len(table)-1):
			vals.append(table[ri][ci])
		var op = table[-1][ci]
		var res = 0
		if op == "+":
			res = sum(vals)
		elif op == "*":
			res = product(vals)
		if AoC.DEBUG:
			print("%s = %d" % [(" %s " % op).join(vals), res])
		sum += res
	AoC.dprint("the grand total is %d" % sum)
	return sum

func split_blocks(mat):
	var blocks = []
	var block_ranges = []
	var this_range = [-1,-1]
	for ch_idx in range(len(mat[-1])):
		var ch = mat[-1][ch_idx]
		if ch != " ":
			if this_range[0] == -1:
				this_range[0] = 0
				continue
			else:
				this_range[1] = ch_idx-1
				block_ranges.append(this_range)
				this_range = [ch_idx, -1]
	this_range[1] = len(mat[-1])
	block_ranges.append(this_range)
	for br in block_ranges:
		#print(br)
		var block = []
		for r in range(len(mat)):
			var row = []
			for c in range(br[0],br[1]):
				#print("r:%d,c:%d"%[r,c])
				row.append(mat[r][c])
				#print(row)
			block.append(row)
			#print(block)
		blocks.append(block)
	return blocks

func block_to_math(blk):
	#print(blk)
	var op = blk[-1][0]
	var nums = []
	for col in range(len(blk[0])):
		nums.append("")
	for row in range(len(blk)-2,-1,-1):
		#print(blk[row])
		for col in range(len(blk[row])):
			var n = blk[row][col]
			#print(n * mult)
			if n != " ":
				nums[col] = n + nums[col]
	for i in range(len(nums)):
		nums[i] = int(nums[i])
	return [op,nums]

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day6",TEST_MODE)
	
	var ch_matrix = []
	for line in inp.split("\n"):
		if AoC.strip(line) == "":
			continue
		var row = []
		for ch in line:
			if ch == "\n":
				continue
			row.append(ch)
		ch_matrix.append(row)
	
	var sum = 0
	var blocks = split_blocks(ch_matrix)
	for block in blocks:
		var res = 0
		var math = block_to_math(block)
		var op = math[0]
		var vals = math[1]
		if op == "+":
			res = sum(vals)
		elif op == "*":
			res = product(vals)
		if AoC.DEBUG:
			print("%s = %d" % [(" %s " % op).join(vals), res])
		sum += res
	AoC.dprint("the grand total is %d" % sum)
	return sum
