extends Area2D

var mouse_active :bool = false

func _process(_delta):
	if mouse_active:
		print("active")


func _on_Grid_mouse_entered():
	mouse_active = true
	
func _on_Grid_mouse_exited():
	mouse_active = false
	
