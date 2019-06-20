extends "res://Game/BehaviorChanger.gd"

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")
const NORMAL_BEHAVIOR = preload("res://Game/Flower/Normal.tscn")

func Init():
	$Anim.playback_speed = randf() * 2 + 0.5
	Normal = NORMAL_BEHAVIOR.instance()
	Anomaly = ANOMALY_BEHAVIOR.instance()
	GlitchHappenChance = 0.1