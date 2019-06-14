extends Node2D

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")

var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	pass # Replace with function body
	
func ToNormal():
	$ColorRect.modulate = Color(255, 255, 255)
	remove_child(Anomaly)
	#TODO(feri) - Play Idle
	
func ToAnomaly():
	#TODO(feri) - Stop Idle
	add_child(Anomaly)
