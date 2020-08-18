extends Control

var numbers = {
	0 : "Erase",
	1 : "One",
	2 : "Two",
	3 : "Three",
	4 : "Four",
	5 : "Five",
	6 : "Six",
	7 : "Seven",
	8 : "Eight",
	9 : "Nine"
}

var NumberPressed :int = 0
var busy :bool = false

func handle_active_button():
	var an = get_parent().active_number
	if NumberPressed != -1:
		if NumberPressed != 0:
			busy = true
			get_node(numbers[an]).pressed = false
			busy = false
		else:
			busy = true
			get_node(numbers[0]).pressed = true
			NumberPressed = 0
			busy = false
	else:
		if an != 0:
			busy = true
			get_node(numbers[an]).pressed = false
			NumberPressed = 0
			busy = false
		else:
			busy = true
			get_node(numbers[0]).pressed = true
			NumberPressed = 0
			busy = false
	get_parent().active_number = NumberPressed

func _on_One_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 1
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Two_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 2
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Three_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 3
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Four_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 4
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Five_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 5
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Six_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 6
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Seven_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 7
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Eight_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 8
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Nine_toggled(button_pressed):
	if !busy:
		if button_pressed:
			NumberPressed = 9
		else:
			NumberPressed = 0
		handle_active_button()

func _on_Erase_pressed():
		NumberPressed = -1
		handle_active_button()
