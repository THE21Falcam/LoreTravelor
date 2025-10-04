extends Node

var TempVAR = 2604
var save_path = "res://save.dat"

func _on_save_pressed():
	var data = {
		"BDAY" : TempVAR ,
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func _on_load_pressed():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var _content = file.get_var()
	file.close()
