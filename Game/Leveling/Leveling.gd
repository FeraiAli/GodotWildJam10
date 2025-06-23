extends Node2D

var level: int = 1
var POINTS_TO_NEXT_LEVEL: int = 1000
var pointsToNextLevel: int = 1000

func _ready() -> void:
	GameManager.connect("OnObjectFixed", Callable(self, "OnPointGained"))

func OnPointGained(_pos, point):
	pointsToNextLevel -= point

	if pointsToNextLevel <= 0:
		level += 1
		get_parent().get_node("PlayerUI/Control/HBoxContainer/Level").text = "LEVEL: " + str(level)
		pointsToNextLevel += POINTS_TO_NEXT_LEVEL
		POINTS_TO_NEXT_LEVEL *= 2
		PlayLevelUpEffect()

		if level == 2:
			get_parent().get_node("Ghost").dash_enabled = true

		if level == 3:
			var player = get_parent()
			if player.has_method("enable_mine"):
				player.enable_mine()
			print("Leveling - mine unlocked at level 5")

func PlayLevelUpEffect() -> void:
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.modulate.a = 0.8
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.4)
