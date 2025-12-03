extends Node

class_name AoC_Day

func dprint(msg):
	if AoC.DEBUG:
		print(msg)

@export var SOLVE_PART1:bool = true
@export var SOLVE_PART2:bool = false
@export var TEST_MODE:bool = false
@export var FILE_INPUT:bool = true

func solve(returning: bool):
	if returning:
		return [solve_part1() if SOLVE_PART1 else null, solve_part2() if SOLVE_PART2 else null]
	else:
		if SOLVE_PART1:
			solve_part1()
		if SOLVE_PART2:
			solve_part2()

func solve_part1():
	pass

func solve_part2():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
