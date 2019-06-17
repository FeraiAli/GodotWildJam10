extends Node2D

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")

var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	randomize()
	$Anim.playback_speed = randf() * 2 + 0.5
	$Anim.play("IDLE")
	$TimeBeforeGlitch.wait_time = 1 #randi() % 120 + 20
	$TimeBeforeGlitch.connect("timeout", self, "ChangeToGlitch")
	$TimeBeforeGlitch.start()
	
func _process(delta):
	pass
	
func ChangeToNormal():
	remove_child(Anomaly)
	$Anim.play("IDLE")

func ChangeToGlitch():
	if false == GameManager.HasSolution("Flower"):
		add_child(Anomaly)