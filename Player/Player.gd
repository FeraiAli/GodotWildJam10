extends CharacterBody2D

var Solution: String = ""
@export var Speed: int = 60
@export var MaxHealth: int = 100
@export var MaxStamina: int = 100

var Health: int = MaxHealth
var Stamina: int = MaxStamina
var can_dash: bool = true
var mine_unlocked: bool = true

@export var mine_enabled: bool = false:
	set(value):
		mine_enabled = value
		var mine = get_node("PlayerUI/Control/Panel/HBoxContainer/Mine")
		if value:
			mine.value = MineTimerCounter
		else:
			mine.value = mine.min_value
	get:
		return mine_enabled

var acceleration: Vector2 = Vector2()
var FixingArea: int = 100

var RepairTimerCounter: float = 10.0
var DashTimerCounter: float = 10.0
var MineTimerCounter: float = 35.0

const AttractionMineScene = preload("res://Game/AttractionMine/AttractionMine.tscn")
var current_mine: Node = null
var mine_cooldown_time: float = 30.0
var mine_duration: float = 5.0

func _ready() -> void:
	if false == GameManager.Config.is_empty():
		Speed = GameManager.Config.PlayerSpeed
		FixingArea = GameManager.Config.FixingArea

	GameManager.connect("GameGenerateWorld", Callable(self, "Restart"))
	GameManager.connect("CameraZoomIn", Callable(self, "CameraZoomIn"))
	GameManager.connect("CameraZoomOut", Callable(self, "CameraZoomOut"))
	#$Anim.animation_finished.connect(OnAnimFinished)
	
	mine_enabled = true
	Restart()

func _draw() -> void:
	var color = Color(0.68, 1, 0.18, 0.1)
	draw_circle($Marker2D.position, FixingArea, color)
	
func CameraZoomIn() -> void:
	$Camera2D.zoom.x = max(0.1, $Camera2D.zoom.x - 0.1)
	$Camera2D.zoom.y = max(0.1, $Camera2D.zoom.y - 0.1)

func CameraZoomOut() -> void:
	$Camera2D.zoom.x = min(2.0, $Camera2D.zoom.x + 0.1)
	$Camera2D.zoom.y = min(2.0, $Camera2D.zoom.y + 0.1)
		
func AddBonus(bonus: String) -> void:
	if bonus == "Health":
		print("HEALING")
	elif bonus == "Stamina":
		MaxStamina += 10

func _physics_process(delta: float) -> void:
	if $RepairCasting.is_visible_in_tree():
		$RepairCasting.value += delta
		return
		
	RepairTimerCounter += delta
	DashTimerCounter += delta
	MineTimerCounter += delta
	
	if Input.is_action_pressed("ui_right"):
		acceleration.x += Speed
	elif Input.is_action_pressed("ui_left"):
		acceleration.x -= Speed
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= Speed
	elif Input.is_action_pressed("ui_down"):
		acceleration.y += Speed
	
	if Input.is_action_pressed("player_repair") and RepairTimerCounter > 1.0:
		RepairTimerCounter = 0.0
		GameManager.emit_signal("OnRepeairBegin")
		$Anim.play("REPAIRING")
		$RepairCasting.value = 0.0
		$RepairCasting.show()
		return
	
	if can_dash and Input.is_action_pressed("player_dash") and DashTimerCounter > 1.3:
		DashTimerCounter = 0.0
		$Anim.play("DASH")
		velocity += (velocity.normalized() * 1000)
		$Ghost.Dash(0.2)
		GameManager.emit_signal("ScreenShake", 0.5, 3, 100)
		
	if Input.is_action_pressed("player_mine") and can_place_mine():
		place_attraction_mine()
		MineTimerCounter = 0.0
	
	if acceleration == Vector2():
		$Anim.play("IDLE")
	else:
		$Anim.play("RUN")
	
	velocity += acceleration
	$Body.flip_h = velocity.x < 0
	set_velocity(velocity)
	move_and_slide()
	velocity *= 0.8
	
	acceleration = Vector2()

func OnAnimFinished(animName: String) -> void:
	if animName == "DASH":
		$Anim.play("IDLE")
	elif animName == "REPAIRING":
		$RepairCasting.hide()
		velocity = Vector2()
		$Anim.play("IDLE")
		
		for r in get_tree().get_nodes_in_group("Rabbit"):
			if r.global_position.distance_to($Marker2D.global_position) < FixingArea:
				r.ChangeToNormal()
				
		for r in get_tree().get_nodes_in_group("Flower"):
			if r.global_position.distance_to($Marker2D.global_position) < FixingArea:
				r.ChangeToNormal()
				
		for r in get_tree().get_nodes_in_group("GlitchTile"):
			if r.global_position.distance_to($Marker2D.global_position) < FixingArea:
				var point = 150
				if false == GameManager.Config.is_empty():
					point *= GameManager.Config.PointMultiplier
				GameManager.emit_signal("OnObjectFixed", r.global_position, point)
				r.queue_free()

func can_place_mine() -> bool:
	return mine_unlocked and MineTimerCounter >= (mine_duration + mine_cooldown_time) and current_mine == null

func place_attraction_mine() -> void:
	var mine = AttractionMineScene.instantiate()
	mine.global_position = global_position
	get_parent().add_child(mine)
	mine.activate()
	
	current_mine = mine
	
	mine.connect("mine_expired", Callable(self, "on_mine_expired"))
	
	GameManager.emit_signal("ScreenShake", 0.3, 2, 50)

func on_mine_expired() -> void:
	current_mine = null
	MineTimerCounter = mine_duration

func enable_mine() -> void:
	mine_unlocked = true
	mine_enabled = true
	print("Mine ability unlocked!")

func Restart() -> void:
	RepairTimerCounter = 10.0
	DashTimerCounter = 10.0
	MineTimerCounter = 35.0
	current_mine = null
	mine_unlocked = false
	mine_enabled = false
	$Anim.play("IDLE")
	$RepairCasting.hide()
