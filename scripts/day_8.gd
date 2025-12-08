extends AoC_Day

func parse_positions(inp):
	var list = []
	for line in inp.split("\n"):
		line = AoC.strip(line)
		if line == "":
			continue
		var pos = line.split(",")
		var vec = Vector3i(int(pos[0]),int(pos[1]),int(pos[2]))
		list.append(vec)
	return list

func count_circuits(circuits):
	var circuit_counts = {}
	for c in circuits:
		if c not in circuit_counts:
			circuit_counts[c] = 0
		circuit_counts[c] += 1
	return circuit_counts

func calc_distance_matrix(positions):
	var dist_mat = []
	for i in range(len(positions)):
		var row = []
		var pos1:Vector3i = positions[i]
		for j in range(len(positions)):
			var pos2:Vector3i = positions[j]
			if i == j:
				row.append(0)
			elif j < i:
				row.append(dist_mat[j][i])
			else:
				var d = pos1.distance_to(pos2)
				row.append(d)
		dist_mat.append(row)
	return dist_mat

func find_mins(dist_mat,n_mins=10):
	var mins = []
	for r in range(len(dist_mat)):
		for c in range(r+1,len(dist_mat[0])):
			var pos = [r,c]
			var val = dist_mat[r][c]
			if len(mins) == 0:
				mins.append([val,pos])
			elif val >= mins[-1][0]:
				if len(mins) < n_mins:
					mins.append([val,pos])
			else:
				var last_v = mins[-1][0]
				var last_p = mins[-1][1]
				mins[-1] = [val,pos]
				var i = len(mins) - 2
				if len(mins) < n_mins:
					mins.append([last_v,last_p])
				while i >= 0 and val < mins[i][0]:
					mins[i+1][0] = mins[i][0]
					mins[i+1][1] = mins[i][1]
					mins[i] = [val,pos]
					i -= 1
			#print(mins)
	return mins

func get_sorted_distances(positions):
	var distances = []
	for i in range(len(positions)):
		for j in range(i+1,len(positions)):
			distances.append([positions[i].distance_to(positions[j]),[i,j]])
	distances.sort_custom(func(a,b): return a[0] < b[0])
	return distances

func get_sorted_positions(dist_mat):
	var positions = []
	for r in range(len(dist_mat)):
		for c in range(r+1,len(dist_mat[0])):
			positions.append([dist_mat[r][c],[r,c]])
	positions.sort_custom(func(a,b): return a[0] < b[0])
	return positions

func solve_part1():
	var inp = ""
	inp = AoC.load_input_from_file("day8", TEST_MODE)
	
	var junc_boxes = parse_positions(inp)
	#var dist_mat = calc_distance_matrix(junc_boxes)
	var num_connections = 10 if TEST_MODE else 1000
	#var mins = find_mins(dist_mat, num_connections)
	#var mins = get_sorted_positions(dist_mat)
	var mins = get_sorted_distances(junc_boxes)
	
	var circuits = []
	for i in range(len(junc_boxes)):
		circuits.append(0)
	var last_new_circuit = 0
	for m in mins.slice(0,num_connections):
		var pos = m[1]
		var jbi1 = pos[0]
		var jbi2 = pos[1]
		var jb1 = junc_boxes[jbi1]
		var jb2 = junc_boxes[jbi2]
		if circuits[jbi1] == 0 and circuits[jbi2] == 0:
			last_new_circuit += 1
			circuits[jbi1] = last_new_circuit
			circuits[jbi2] = last_new_circuit
			AoC.dprint("Connecting %s to %s in a new circuit(%d)" % [jb1,jb2,last_new_circuit])
		elif circuits[jbi1] == 0:
			circuits[jbi1] = circuits[jbi2]
			AoC.dprint("Connecting %s to %s in circuit %d" % [jb1,jb2,circuits[jbi2]])
		elif circuits[jbi2] == 0:
			circuits[jbi2] = circuits[jbi1]
			AoC.dprint("Connecting %s to %s on circuit %d" % [jb2,jb1,circuits[jbi1]])
		elif circuits[jbi1] != circuits[jbi2]:
			var c1 = circuits[jbi1]
			var c2 = circuits[jbi2]
			last_new_circuit += 1
			for ci in range(len(circuits)):
				if circuits[ci] == c1 or circuits[ci] == c2:
					circuits[ci] = last_new_circuit
			AoC.dprint("Connecting %s to %s and merging circuits %d and %d to new circuit(%d)" % [jb2,jb1,c1,c2,last_new_circuit])
		else:
			#AoC.dprint("Junction boxes %s and %s are already connected in circuit %d" % [jb1,jb2,circuits[jbi1]])
			pass
		#print(circuits)
	
	var counts = count_circuits(circuits)
	var uniq_circuits = 0
	var sorted_counts = []
	var num_singles = 0
	for key in counts:
		var c = counts[key]
		if key == 0:
			uniq_circuits += c
			num_singles = c
		else:
			uniq_circuits += 1
			sorted_counts.append(c)
	sorted_counts.sort()
	sorted_counts.reverse()
	print("After making the ten shortest connections, there are %d circuits:" % uniq_circuits)
	var product = 1
	var products = 0
	for cnt in sorted_counts:
		if products < 3:
			product *= cnt
			products += 1
	if AoC.DEBUG:
		var how_many = {}
		var uniq_cnts = []
		for cnt in sorted_counts:
			if cnt not in how_many:
				uniq_cnts.append(cnt)
				how_many[cnt] = 0
			how_many[cnt] += 1
		for cnt in uniq_cnts:
			var n = how_many[cnt]
			print(" - %s circuit%s which contain%s %d junction box%s" % [AoC.strnum(n),AoC.plural(n),AoC.inv_plural(n),cnt,AoC.plural(cnt,"es")])
		print(" - and %s circuits which each contain a single junction box" % AoC.strnum(num_singles))
	print("Multiplying together the sizes of the three largest circuits produces %d" % product)
	return product

func solve_part2():
	var inp = ""
	inp = AoC.load_input_from_file("day8", TEST_MODE)
	
	var junc_boxes = parse_positions(inp)
	#var dist_mat = calc_distance_matrix(junc_boxes)
	#var mins = find_mins(dist_mat, num_connections)
	#var mins = get_sorted_positions(dist_mat)
	var mins = get_sorted_distances(junc_boxes)
	
	var circuits = []
	for i in range(len(junc_boxes)):
		circuits.append(0)
	var last_new_circuit = 0
	var num_circuits = len(circuits)
	var last_two_Xs = [-1,-1]
	for m in mins:
		var pos = m[1]
		var jbi1 = pos[0]
		var jbi2 = pos[1]
		var jb1:Vector3i = junc_boxes[jbi1]
		var jb2:Vector3i = junc_boxes[jbi2]
		if circuits[jbi1] == 0 and circuits[jbi2] == 0:
			last_new_circuit += 1
			circuits[jbi1] = last_new_circuit
			circuits[jbi2] = last_new_circuit
			AoC.dprint("Connecting %s to %s in a new circuit(%d)" % [jb1,jb2,last_new_circuit])
		elif circuits[jbi1] == 0:
			circuits[jbi1] = circuits[jbi2]
			num_circuits -= 1
			AoC.dprint("Connecting %s to %s in circuit %d" % [jb1,jb2,circuits[jbi2]])
		elif circuits[jbi2] == 0:
			circuits[jbi2] = circuits[jbi1]
			num_circuits -= 1
			AoC.dprint("Connecting %s to %s on circuit %d" % [jb2,jb1,circuits[jbi1]])
		elif circuits[jbi1] != circuits[jbi2]:
			var c1 = circuits[jbi1]
			var c2 = circuits[jbi2]
			last_new_circuit += 1
			for ci in range(len(circuits)):
				if circuits[ci] == c1 or circuits[ci] == c2:
					circuits[ci] = last_new_circuit
			num_circuits -= 1
			AoC.dprint("Connecting %s to %s and merging circuits %d and %d to new circuit(%d)" % [jb2,jb1,c1,c2,last_new_circuit])
		else:
			AoC.dprint("Junction boxes %s and %s are already connected in circuit %d" % [jb1,jb2,circuits[jbi1]])
			continue
		num_circuits -= 1
		last_two_Xs[0] = jb1.x
		last_two_Xs[1] = jb2.x
		if num_circuits == 1:
			break
	
	var product = last_two_Xs[0] * last_two_Xs[1]
	print("Multiplying the X coordinates of those two junction boxes (%d and %d) produces %d" % [last_two_Xs[0], last_two_Xs[1], product])
	return product
