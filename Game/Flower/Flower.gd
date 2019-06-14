extends Node2D

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")

var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	GameManager.connect("ToNormal", self, "ConvertToNormal")
	GameManager.connect("ToAnomaly", self, "ConvertToAnomaly")
	pass # Replace with function body
	
func ConvertToNormal():
	remove_child(Anomaly)
	#TODO(feri) - Play Idle
	
func ConvertToAnomaly():
	#TODO(feri) - Stop Idle
	add_child(Anomaly)
