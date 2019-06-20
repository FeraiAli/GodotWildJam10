extends Node

var _Player = null
signal GameGenerateWorld
signal CameraZoomIn
signal CameraZoomOut

signal RequestGlitchingTile

signal OnRepeairBegin
signal OnObjectFixed
signal ObjectIsGlitching

var _Malfunctions = []

func _input(event):
	if event.is_action_pressed("game_generate_world"):
		emit_signal("GameGenerateWorld")
	if event.is_action_pressed("game_camera_zoom_in"):
		emit_signal("CameraZoomIn")
	if event.is_action_pressed("game_camera_zoom_out"):
		emit_signal("CameraZoomOut")
		
	if event.is_action_pressed("game_glitch_rabbits"):
		AlternateMalfunction("Rabbit")
	if event.is_action_pressed("game_glitch_flowers"):
		AlternateMalfunction("Flower")

func AlternateMalfunction(groupId):
	if _Malfunctions.has(groupId):
		TrySolution(groupId)
	else:
		CreateGlitch(groupId)

func CreateGlitch(groupId):
	_Malfunctions.push_back(groupId)
	get_tree().call_group(groupId, "ChangeToGlitch")

func TrySolution(groupId):
	_Malfunctions.erase(groupId)
	#FindSolutions.push_back(groupId)
	get_tree().call_group(groupId, "ChangeToNormal")
	
func GetPlayer():
	if _Player == null:
		_Player = get_tree().get_nodes_in_group("Player").front()
	return _Player
	
func OnGameOver():
	get_tree().paused = true
	
func RestartTheGame():
	get_tree().paused = false
	emit_signal("GameGenerateWorld")