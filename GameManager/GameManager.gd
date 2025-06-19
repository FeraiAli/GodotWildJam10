extends Node

var Config: Dictionary = {}
var _Player: Node = null

signal GameGenerateWorld()
signal CameraZoomIn()
signal CameraZoomOut()
signal RequestGlitchingTile()
signal OnRepeairBegin()
signal OnObjectFixed(position: Vector2, points: int)
signal ObjectIsGlitching()
signal ScreenShake(length: float, power: float, priority: int)

var _Malfunctions: Array[String] = []

func _input(event: InputEvent) -> void:
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
	if event.is_action_pressed("game_glitch_bee"):
		AlternateMalfunction("Bee")

func AlternateMalfunction(groupId: String) -> void:
	if _Malfunctions.has(groupId):
		TrySolution(groupId)
	else:
		CreateGlitch(groupId)

func CreateGlitch(groupId: String) -> void:
	_Malfunctions.append(groupId)
	get_tree().call_group(groupId, "ChangeToGlitch")

func TrySolution(groupId: String) -> void:
	_Malfunctions.erase(groupId)
	#FindSolutions.push_back(groupId)
	get_tree().call_group(groupId, "ChangeToNormal")
	
func GetPlayer() -> Node:
	if _Player == null:
		_Player = get_tree().get_nodes_in_group("Player").front()
	return _Player
	
func OnGameOver(endScore: int) -> void:
#TODO - If Have Time Add HighScore System
#	var fileName = "res://DataBase/HighScore.json"
#
#	var file = File.new()
#	file.open(fileName, File.WRITE_READ)
#
#	var node_data = inst2dict(endScore)
#	file.store_string(to_json(node_data))
#	file.close()
	
	get_tree().paused = true
	
func RestartTheGame() -> void:
	get_tree().paused = false
	emit_signal("GameGenerateWorld")