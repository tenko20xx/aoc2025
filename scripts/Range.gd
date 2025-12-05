class_name IntRange
extends Node

@export var low : int = 0
@export var high : int = 0
@export var inclusive = true

func parse_and_apply(s):
	s = AoC.strip(s)
	var parts = s.split("-")
	low = int(parts[0])
	high = int(parts[1])

func in_range(val):
	if inclusive:
		return val >= low and val <= high
	else:
		return val > low and val < high

func to_str(show_inclusivity=false):
	var str_range = "%d-%d" % [low, high]
	if show_inclusivity:
		if inclusive:
			return "[%s]" % str_range
		else:
			return "(%s)" % str_range
	return str_range

func print_range(show_inclusivity=false):
	print(to_str(show_inclusivity))
