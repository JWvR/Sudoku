extends Node2D

var numbers = [
			preload("res://Scenes/Erase.tscn"),
			preload("res://Scenes/One.tscn"),
			preload("res://Scenes/Two.tscn"),
			preload("res://Scenes/Three.tscn"),
			preload("res://Scenes/Four.tscn"),
			preload("res://Scenes/Five.tscn"),
			preload("res://Scenes/Six.tscn"),
			preload("res://Scenes/Seven.tscn"),
			preload("res://Scenes/Eight.tscn"),
			preload("res://Scenes/Nine.tscn")
]

var x_start :int = 160
var y_start :int = 160
var mouse_active :bool = false

var active_number :int
var active_cell :Vector2
var last_time :int #remembers the last count of solved cells
var solved :bool
var solve_pressed :bool 
var play_solution :bool
var number_steps :int
var size :int
var playing :bool
var colored_cell :Vector2

var sudoku :Array
var saved_sudoku :Array
var movie_sudoku :Array
var solution :Array #array to be used to solve Sudoku by player
var step_by_step_solution :Array


func _ready():
	new()

#function to solve sodoku by player

#missing logic to fill empty cell when number key is pressed and cell selected
func _process(_delta):
	if !solve_pressed:
		if mouse_active:
			if Input.is_action_just_pressed("mouse1"):
				active_cell = pos_to_cell(get_global_mouse_position())
				if check_cell(active_cell[0], active_cell[1]):
					if active_number != 0:
						sudoku[active_cell[0]][active_cell[1]] = String(active_number)
					else:
						sudoku[active_cell[0]][active_cell[1]] = String("123456789")
					draw_sudoku(sudoku)
				else:
					print("fout")
	else:
		if play_solution && size < number_steps:
			if Input.is_action_just_pressed("next"):
				play(step_by_step_solution, size)
				size += 1

func new() -> void:

#set active button to erase when new sudoku is setup
	$NumberButtons.handle_active_button()
	active_number = 0
	$NumberButtons.NumberPressed = -1
	$NumberButtons.handle_active_button()
#set all global variables to their start values
	sudoku = create_empty_sudoku(9, 9)
	movie_sudoku.clear()
	solution.clear()
	step_by_step_solution.clear()
	last_time = -1 
	solved = false
	solve_pressed = false
	play_solution = false
	number_steps = 0
	size = 0
	playing = false
	colored_cell = Vector2(-1, -1)
	draw_sudoku(sudoku)

func create_empty_sudoku(r, c) -> Array:
	var array :Array = []
	for i in range(r):
		array.append([])
		array[i].resize(c)
	for i in range(r):
		for j in range(c):
			array[i][j] = "123456789"
	return array

func pos_to_cell(pos :Vector2) -> Vector2:
	var x :int = int(pos[1])
	var y :int = int(pos[0])
# warning-ignore:integer_division
	x = (x - 128)/64
# warning-ignore:integer_division
	y = (y - 128)/64
	return Vector2(x,y)

func cell_to_pos(r, c) -> Vector2:
	var x = x_start + c * 64
	var y = y_start + r * 64
	return Vector2(x, y)

func trim_array(a :Array, b :Array) -> void:
	for i in b:
		if a.has(i):
			a.erase(i)

func draw_sudoku(sud) -> void:
	var child
	for c in $Screen/Grid.get_children():
		c.queue_free()
	for i in range(9):
		for j in range(9):
			pass
			if len(sud[i][j]) != 1:
				child =numbers[0].instance()
			else:
				child = numbers[int(sud[i][j])].instance()
			child.position = cell_to_pos(i, j)
			if playing:
				if Vector2(i, j) == colored_cell:
					child.modulate = Color(0,1,0) #Green
			$Screen/Grid.add_child(child)

func check_cell(r, c) -> bool:
	return check_row(r, c) && check_column(r, c) && check_square(r, c)

func check_row(r, c) -> bool:
	var r_a :Array = []
	var result :bool = true
	r_a = create_row_values(r, c)
	for i in r_a:
		if active_number == i:
			result = false
	return result

func create_row_values(r, _c) -> Array:
	var v_a :Array = []
	for i in range(9):
		if len(sudoku[r][i]) == 1:
			v_a.append(int(sudoku[r][i]))
	return v_a

func check_column(r, c) -> bool:
	var a :Array = []
	var result :bool = true
	a = create_column_values(r, c)
	for i in a:
		if active_number == i:
			result = false
	return result

func create_column_values(_r, c) -> Array:
	var c_a :Array = []
	for i in range(9):
		if len(sudoku[i][c]) == 1:
			c_a.append(int(sudoku[i][c]))
	return c_a

func check_square(r, c) -> bool:
	var a :Array = []
	a = create_square_values(r, c)
	var result :bool = true
	for i in a:
		if active_number == i:
			result = false
	return result

func create_square(r, c) -> Array:
	var a :Array = []
	var b :Vector2
	var offset_x :int = int(r / 3)
	var offset_y : int = int(c / 3)
	for i in range(3):
		for j in range(3):
			b = Vector2(offset_x * 3 + i, offset_y * 3 + j)
			a.append(b)
	return a

func create_square_values(r, c) -> Array:
	var values :Array =[]
	var a = create_square(r, c)
	for i in a:
		if len(sudoku[i[0]][i[1]]) == 1:
			values.append(int(sudoku[i[0]][i[1]]))
	return values

func array_to_string(a :Array) -> String:
	var string :String = ""
	for i in range(a.size()):
		string += str(a[i])
	return string

func string_to_array(s :String) -> Array:
	var array :Array = []
	for i in range(len(s)):
		array.append(int(s[i]))
	return array

# discards value from cell if it is already in row, column or square
func trim_cell(r, c) -> int:
	if len(sudoku[r][c]) != 1:
		var cell_array :Array = string_to_array(sudoku[r][c])
		var row_array :Array = create_row_values(r, c)
		var column_array :Array = create_column_values(r, c)
		var square_array :Array = create_square_values(r, c)
		trim_array(cell_array, row_array)
		trim_array(cell_array, column_array)
		trim_array(cell_array, square_array)
		fill_sudoku("trim_cell ", r, c, cell_array)
		return 0
	else:
		return 1

# determines of a value is only once possible in row
func trim_row(r) -> bool:
	var t_r_a :Array = []
	var t_r_s :String = ""
	var onlyOnce :Array =[]
	for i in range(9):
		if len(sudoku[r][i]) != 1:
			t_r_s += sudoku[r][i]
	t_r_a = string_to_array(t_r_s)
	for i in range(9):
		if t_r_a.count(i+1) == 1:
			onlyOnce.append(i+1)
	for i in onlyOnce:
		for j in range(9):
			if string_to_array(sudoku[r][j]).has(i):
				fill_sudoku("trim row ", r, j, i)
	if onlyOnce.size() > 0:
		return true
	else:
		return false

# determines of a value is only once possible in column
func trim_column(c) -> void:
	var t_c_a :Array = []
	var t_c_s :String = ""
	var onlyOnce :Array =[]
	for i in range(9):
		if len(sudoku[i][c]) != 1:
			t_c_s += sudoku[i][c]
	t_c_a = string_to_array(t_c_s)
	for i in range(9):
		if t_c_a.count(i+1) == 1:
			onlyOnce.append(i+1)
	for i in onlyOnce:
		for j in range(9):
			if string_to_array(sudoku[j][c]).has(i):
				fill_sudoku("trim column ", j, c, i)

# determines of a value is only once possible in square
func trim_square(r, c) -> bool:
	var t_s_a :Array = []
	var t_s_s :String = ""
	var onlyOnce :Array =[]
	var square_cells = create_square(r, c)
	for i in square_cells:
		if len(sudoku[i[0]][i[1]]) != 1:
			t_s_s += sudoku[i[0]][i[1]]
	t_s_a = string_to_array(t_s_s)
	for i in range(9):
		if t_s_a.count(i+1) == 1:
			onlyOnce.append(i+1)
	for i in onlyOnce:
		for j in square_cells:
			if string_to_array(sudoku[j[0]][j[1]]).has(i):
#				sudoku[j[0]][j[1]] = str(i)
				fill_sudoku("trim square ", j[0], j[1], i)
	if onlyOnce.size() > 0:
		return true
	else:
		return false

func trim_all_cells() -> bool:
	var counter :int = 0
	for i in range(9):
		for j in range(9):
			counter += trim_cell(i, j)
	if counter == 81:
		print("ready ok ", counter)
		solved = true
		return true
	elif counter == last_time:
		print("ready not ok ", counter)
		solved = false
		return true
	else:
		last_time = counter
		return false

func solve_sudoku() -> bool:
	if trim_all_cells():
		return true

	var j :int = 0
	for i in range(9):
		if trim_row(i):
			if trim_all_cells():
				return true
			else:
				i = 0

	for i in range(9):
		if trim_column(i):
			if trim_all_cells():
				return true
			else:
				i = 0

	var finished :bool = false
	var i = 0
	while i < 9:
		finished = true
		j = 0
		while j < 9 && finished:
			if trim_square(i, j):
				if trim_all_cells():
					return true
				else:
					j = 0
					i = 0
					finished = false
			else:
				j += 3
			if !finished:
				i = 0
			else:
				i += 3
	return false

func fill_sudoku(name_caller :String, r :int, c :int, value):
	var temp :int = 0
	if typeof(value) == TYPE_ARRAY:
		if value.size() > 1:
			sudoku[r][c] = array_to_string(value)
		else:
			if value != []:
				temp = int(value[0])
	else:
		temp = value
	if temp != 0 && len(sudoku[r][c]) != 1:
		sudoku[r][c] = str(temp)
		step_by_step_solution.append([name_caller, r, c, temp])

func play(sol, step) -> void:
	movie_sudoku[sol[step][1]][sol[step][2]] = str(sol[step][3])
	colored_cell = Vector2(sol[step][1], sol[step][2])
	# put in colored cellse for trim row / column / square
	draw_sudoku(movie_sudoku)

func _on_Save_pressed():
	$LayerFiles/SaveDialog.add_filter("*.sud ; Sudoku files")
	$LayerFiles/SaveDialog.set_current_path("res://Save/")
	$LayerFiles/SaveDialog.popup_centered()

func _on_Load_pressed():
	$LayerFiles/LoadDialog.add_filter("*.sud ; Sudoku files")
	$LayerFiles/LoadDialog.set_current_path("res://Save/")
	$LayerFiles/LoadDialog.popup_centered()
	solve_pressed = false

func _on_New_pressed():
	new()

func _on_PlaySolve_pressed():
	if !solve_pressed:
		print("not yet solved")
	else:
		if !playing:
			draw_sudoku(movie_sudoku)
			play_solution = true
			number_steps = step_by_step_solution.size()
			print(number_steps)
			playing = true

func _on_Temp_pressed():
	for i in range(9):
		print(sudoku[active_number][i], " ")

func _on_Panel_mouse_entered():
	mouse_active = true

func _on_Panel_mouse_exited():
	mouse_active = false

func _on_Button_pressed():
	if solve_pressed:
		print("already tried to solve")
	else:
		solve_pressed = true
		movie_sudoku = sudoku.duplicate(true)
		var i = 0
		while !solve_sudoku():
			i += 1
			print("count:", i)
		draw_sudoku(sudoku)

func _on_SaveDialog_file_selected(path):
	var f :File = File.new()
	if f.open(path, File.WRITE):
		print("cannot save")
	f.store_var(sudoku)
	f.close()

func _on_LoadDialog_file_selected(path):
	var f :File = File.new()
	if f.open(path, File.READ):
		print("cannot load")
	sudoku = f.get_var()
	f.close()
	draw_sudoku(sudoku)
