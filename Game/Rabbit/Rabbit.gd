extends KinematicBody2D

const NORMAL_BEHAVIOR = preload("res://Game/Rabbit/Normal.tscn")
const ANOMALY_BEHAVIOR = preload("res://Game/Rabbit/Anomaly.tscn")

var Normal = NORMAL_BEHAVIOR.instance()
var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	randomize()
	$TimeBeforeGlitch.wait_time = 1 #randi() % 120 + 20
	$TimeBeforeGlitch.connect("timeout", self, "ChangeToGlitch")
	$TimeBeforeGlitch.start()
	
	add_child(Normal)

func ChangeToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	
func ChangeToGlitch():
	if false == GameManager.HasSolution("Rabbit"):
		remove_child(Normal)
		add_child(Anomaly)