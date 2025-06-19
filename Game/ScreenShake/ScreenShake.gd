extends Node

var current_shake_priority: int = 0

func _ready():
	GameManager.connect("ScreenShake", Callable(self, "requestCameraShake"))

func move_camera(vector: Vector2) -> void:
	get_parent().get_node("Player").get_node("Camera2D").offset = Vector2(randf_range(-vector.x, vector.x), randf_range(-vector.y, vector.y))

func requestCameraShake(shake_length: float, shake_power: float, shake_priority: int) -> void:
	if shake_priority < current_shake_priority:
		return
		
	current_shake_priority = shake_priority
	var tween = create_tween()
	tween.tween_method(move_camera, Vector2(shake_power, shake_power), Vector2.ZERO, shake_length).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_shake_completed)

func _on_shake_completed() -> void:
	current_shake_priority = 0