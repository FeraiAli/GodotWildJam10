extends Node

var current_shake_priority = 0

func _ready():
	GameManager.connect("ScreenShake", self, "requestCameraShake")

func move_camera(vector):
	get_parent().get_node("Player").get_node("Camera2D").offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))

func _on_Tween_tween_completed(object, key):
	current_shake_priority = 0
	
func requestCameraShake(shake_length, shake_power, shake_priority):
	$Tween.interpolate_method(self, "move_camera", Vector2(shake_power, shake_power), Vector2(0, 0), shake_length, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	$Tween.start()