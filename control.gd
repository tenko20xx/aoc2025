extends Control


func button_pressed(node):
	var toggles = [$MarginContainer/VBoxContainer/HBoxContainer/Part1, $MarginContainer/VBoxContainer/HBoxContainer/Part2, $MarginContainer/VBoxContainer/HBoxContainer/Test, $MarginContainer/VBoxContainer/HBoxContainer/Debug, $MarginContainer/VBoxContainer/HBoxContainer/Debug]
	node.SOLVE_PART1 = toggles[0].button_pressed
	node.SOLVE_PART2 = toggles[1].button_pressed
	node.TEST_MODE = toggles[2].button_pressed
	#node.FILE_INPUT = toggles[3].button_pressed
	AoC.DEBUG = toggles[4].button_pressed
	if AoC.DEBUG:
		var strt_time = Time.get_ticks_usec()
		node.solve(false)
		print("Completed in %sms" % ((Time.get_ticks_usec() - strt_time)/1000.0))
	else:
		$MarginContainer.hide()
		$Results.show()
		var returns = [$Results/VBoxContainer/Part1, $Results/VBoxContainer/Part2, $Results/VBoxContainer/Label]
		returns[0].visible = node.SOLVE_PART1
		returns[1].visible = node.SOLVE_PART2
		var strt_time = Time.get_ticks_usec()
		var results = node.solve(true)
		var elapsed = Time.get_ticks_usec() - strt_time
		returns[2].text = "Completed in %.3fms" % (elapsed/1000.0)
		returns[0].text = "Part 1 result: "+str(results[0])
		returns[1].text = "Part 2 result: "+str(results[1])
		returns[0].result = str(results[0])
		returns[1].result = str(results[1])
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in $Problems.get_children():
		var butt = preload("res://button.tscn").instantiate()
		$MarginContainer/VBoxContainer/GridContainer.add_child(butt)
		#var name = f.replace(".gd","").replace("_"," ").replace("day","Day")
		butt.text = node.name
		butt.pressed.connect(button_pressed.bind(node))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	$Results.hide()
	$MarginContainer.show()
