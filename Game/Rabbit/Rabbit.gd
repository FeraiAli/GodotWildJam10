extends KinematicBody2D

const NORMAL_BEHAVIOR = preload("res://Game/Rabbit/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Rabbit/Anomaly.tscn")

var Normal = NORMAL_BEHAVIOR.instance()
var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	add_child(Normal)

func _process(delta):
	pass
	#print(position)
	
func ToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	
func ToAnomaly():
	remove_child(Normal)
	add_child(Anomaly)