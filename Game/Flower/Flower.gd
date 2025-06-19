extends "res://Game/BehaviorChanger.gd"

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")
const NORMAL_BEHAVIOR = preload("res://Game/Flower/Normal.tscn")

func Init():
	$Anim.speed_scale = randf() * 2.0 + 0.5
	Normal = NORMAL_BEHAVIOR.instantiate()
	Anomaly = ANOMALY_BEHAVIOR.instantiate()
	GlitchHappenChance = 0.1