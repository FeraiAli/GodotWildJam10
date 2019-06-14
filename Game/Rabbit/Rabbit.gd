extends KinematicBody2D

const NORMAL_BEHAVIOR = preload("res://Game/Rabbit/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Rabbit/Anomaly.tscn")

var Normal = NORMAL_BEHAVIOR.instance()
var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	GameManager.connect("ToNormal", self, "ConvertToNormal")
	GameManager.connect("ToAnomaly", self, "ConvertToAnomaly")
	add_child(Normal)

func _process(delta):
	pass
	#print(position)
	
func ConvertToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	
func ConvertToAnomaly():
	remove_child(Normal)
	add_child(Anomaly)