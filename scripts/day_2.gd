extends AoC_Day

func str_range(rng):
	return str(rng[0]) + "-" + str(rng[1])
	
func parse_ranges(inp):
	inp = inp.replace(" ","").replace("\n","")
	var ranges = []
	for rng in inp.split(","):
		var parts = rng.split("-")
		var m = parts[0]
		var M = parts[1]
		
		#print("min: %s, max: %s" % [m,M])
		ranges.append([m,M])
	return ranges
	
func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day2",TEST_MODE)
	
	
	var ranges = parse_ranges(inp)
	var sum = 0
	for rng in ranges:
		var m = rng[0]
		var M = rng[1]
		if len(m) == len(M) and len(m) % 2 == 1:
			continue
		if len(m) % 2 == 1:
			var l = len(m)
			m = "1"
			for i in range(l):
				m += "0"
		if len(M) % 2 == 1:
			var l = len(M)-1
			M = ""
			for i in range(l):
				M += "9"
		#print("min: %s, max: %s" % [m, M])
		
		@warning_ignore_start("integer_division")
		var mt = int(m.substr(0,len(m)/2))
		var Mt = int(M.substr(0,len(M)/2))
		
		m = int(m)
		M = int(M)
		@warning_ignore_restore("integer_division")
		#print("mt: %d mb: %d, Mt: %d Mb: %d" % [mt, mb, Mt, Mb])
		var inv_ids = []
		for i in range(mt,Mt+1):
			var check = int(str(i) + str(i))
			if check >= m and check <= M:
				inv_ids.append(check)
				sum += check
		if AoC.DEBUG:
			if len(inv_ids) > 0:
				print("%s has %s invalid ID%s, %s" % [str_range(rng), AoC.strnum(len(inv_ids)), AoC.plural(len(inv_ids)), AoC.list_out(inv_ids)])
	AoC.dprint("Adding up all the invalid IDs produces %d" % sum)
	return sum
	
func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day2",TEST_MODE)
	
	
	var ranges = parse_ranges(inp)
	var sum = 0
	for rng in ranges:
		var sm = rng[0]
		var sM = rng[1]
		var m = int(sm)
		var M = int(sM)
		
		var inv_ids = []
		var i = 1
		var done = false
		while not done:
			var nr = 1 # number of repeats
			while true:
				nr += 1
				var n = ""
				for x in range(nr):
					n += str(i)
				n = int(n)
				#print(n)
				if n < m:
					continue
				if n > M:
					if nr == 2:
						done = true
					break
				if n >= m and n <= M:
					if n not in inv_ids:
						inv_ids.append(n)
						sum += n
			i += 1
		
		if AoC.DEBUG:
			if len(inv_ids) > 0:
				inv_ids.sort()
				print("%s has %s invalid ID%s, %s" % [str_range(rng), AoC.strnum(len(inv_ids)), AoC.plural(len(inv_ids)), AoC.list_out(inv_ids)])
	AoC.dprint("Adding up all the invalid IDs produces %d" % sum)
	return sum
