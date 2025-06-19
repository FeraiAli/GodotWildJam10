extends Control

func OnExitPressed() -> void:
	get_tree().quit()

func OnEasyPressed() -> void:
	GameManager.Config = { 
		"PlayerSpeed": 70, 
		"FixingArea": 150, 
		"NormalDuration": 20.0, 
		"GlitchHappenChance": 0.0, 
		"GlitchIncreaseFactor": 0.05,
		"BeesCount": 10,
		"RabbitsCount": 20,
		"FlowerCount": 60,
		"PointMultiplier": 1.0 
	}
	get_tree().change_scene_to_file("res://Game/Game.tscn")

func OnMediumPressed() -> void:
	GameManager.Config = { 
		"PlayerSpeed": 60, 
		"FixingArea": 125, 
		"NormalDuration": 15.0, 
		"GlitchHappenChance": 0.1, 
		"GlitchIncreaseFactor": 0.05,
		"BeesCount": 15,
		"RabbitsCount": 25,
		"FlowerCount": 70,
		"PointMultiplier": 1.5 
	}
	get_tree().change_scene_to_file("res://Game/Game.tscn")

func OnHardPressed() -> void:
	GameManager.Config = { 
		"PlayerSpeed": 50, 
		"FixingArea": 100, 
		"NormalDuration": 10.0, 
		"GlitchHappenChance": 0.1, 
		"GlitchIncreaseFactor": 0.1,
		"BeesCount": 25,
		"RabbitsCount": 35,
		"FlowerCount": 80,
		"PointMultiplier": 2 
	}
	get_tree().change_scene_to_file("res://Game/Game.tscn")
