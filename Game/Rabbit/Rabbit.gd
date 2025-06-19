extends "res://Game/BehaviorChanger.gd"

const NORMAL_BEHAVIOR = preload("res://Game/Rabbit/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Rabbit/Anomaly.tscn")

func Init():
	GlitchIncreaseFactor = 0.0
	Normal = NORMAL_BEHAVIOR.instantiate()
	Anomaly = ANOMALY_BEHAVIOR.instantiate()