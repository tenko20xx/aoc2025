extends Node

var DEBUG = false

func _ready() -> void:
	pass

func dprint(msg):
	if DEBUG:
		print(msg)
		
func dir_contents(path,files_only=true):
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dprint("Found directory: " + file_name)
				if not files_only:
					files.append(file_name)
			else:
				dprint("Found file: " + file_name)
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files

func load_input_from_file(day="day1",test=false):
	var res_name = ""
	if day.ends_with(".txt"):
		res_name = day
	else:
		res_name = day + ".input" + (".test" if test else "") + ".txt"
	if FileAccess.file_exists("res://inputs/%s" % res_name):
		var file = FileAccess.open("res://inputs/%s" % res_name, FileAccess.READ)
		var content = file.get_as_text()
		return content
	else:
		print("lmao the file isnt there")
	return null

func strip(string):
	return string.rstrip(" \t\n").lstrip(" \t\n")

func strnum(n):
	var m = ["zero","one","two","three","four","five","six","seven","eight","nine","ten"]
	if n <= len(m):
		return m[n]
	return str(n)

func plural(n,suffix="s"):
	if n == 1:
		return ""
	return suffix
	
func inv_plural(n,suffix="s"):
	if n != 1:
		return ""
	return suffix

func list_out(l):
	if len(l) == 0:
		return ""
	if len(l) == 1:
		return str(l[0])
	return "%s and %s" % [", ".join(l.slice(0,len(l)-1)), l[len(l)-1]]
