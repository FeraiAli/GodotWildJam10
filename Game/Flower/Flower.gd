extends Node2D

const ANOMALY_BEHAVIOR = preload("res://Game/Flower/Anomaly.tscn")

var Anomaly = ANOMALY_BEHAVIOR.instance()

func _ready():
	randomize()
	$Anim.playback_speed = randf() * 3
	$Anim.play("IDLE")
	
func _process(delta):
	pass
	
func ToNormal():
	$ColorRect.modulate = Color(0, 255, 255)
	remove_child(Anomaly)
	#TODO(feri) - Play Idle
	
func ChangeToGlitch():
	#TODO(feri) - Stop Idle
	add_child(Anomaly)
