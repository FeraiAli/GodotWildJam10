extends Node
#TILES WAYS - LEFT - (0, 10-15)
#RIGHT - (39, 10-15)
#UP - (20-25, 0)
#DOWN - (20-25, 23)

var _Player = null

func Glitch(glitch):
	get_tree().call_group(glitch, "ToAnomaly")

func TrySolution(solution):
	get_tree().call_group(solution, "ToNormal")
	
func _input(event):
	var TestMalfunction = "Rabbit"
	if event.is_action_pressed("ui_page_up"):
		Glitch(TestMalfunction)
	if event.is_action_pressed("ui_page_down"):
		TrySolution(TestMalfunction)

func GetPlayer():
	if _Player == null:
		_Player = get_tree().get_nodes_in_group("Player").front()
	return _Player