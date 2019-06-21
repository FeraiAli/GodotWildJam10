extends KinematicBody2D

var Solution : String = ""
export(int) var Speed = 60
export(int) var MaxHealth = 100
export(int) var MaxStamina = 100

var Health = MaxHealth
var Stamina = MaxStamina

var velocity = Vector2()
var acceleration = Vector2()
var FixingArea = 100

var RepairTimerCounter = 10.0
var DashTimerCounter = 10.0

func _ready():
	if false == GameManager.Config.empty():
		Speed = GameManager.Config.PlayerSpeed
		FixingArea = GameManager.Config.FixingArea

	GameManager.connect("GameGenerateWorld", self, "Restart")
	GameManager.connect("CameraZoomIn", self, "CameraZoomIn")
	GameManager.connect("CameraZoomOut", self, "CameraZoomOut")
	$Anim.connect("animation_finished", self, "OnAnimationFinished")
	
	Restart()
	
func CameraZoomIn():
	$Camera2D.zoom.x = max(0.1, $Camera2D.zoom.x - 0.1)
	$Camera2D.zoom.y = max(0.1, $Camera2D.zoom.y - 0.1)

func CameraZoomOut():
	$Camera2D.zoom.x = min(2.0, $Camera2D.zoom.x + 0.1)
	$Camera2D.zoom.y = min(2.0, $Camera2D.zoom.y + 0.1)
		
func AddBonus(bonus):
	if bonus == "Health":
		print("HEALING")
	elif bonus == "Stamina":
		MaxStamina += 10

func _physics_process(delta):
	if $RepairCasting.is_visible_in_tree():
		$RepairCasting.value += delta
		return
		
	RepairTimerCounter += delta
	DashTimerCounter += delta
	
	if Input.is_action_pressed("ui_right"):
		acceleration.x += Speed
	elif Input.is_action_pressed("ui_left"):
		acceleration.x -= Speed
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= Speed
	elif Input.is_action_pressed("ui_down"):
		acceleration.y += Speed
	
	if Input.is_action_pressed("player_repair") and RepairTimerCounter > 0.0:
		RepairTimerCounter = 0.0
		GameManager.emit_signal("OnRepeairBegin")
		$Anim.play("REPAIRING")
		$RepairCasting.value = 0.0
		$RepairCasting.show()
		return
	
	if Input.is_action_pressed("player_dash") and DashTimerCounter > 2.0:
		DashTimerCounter = 0.0
		$Anim.play("DASH")
		velocity += (velocity.normalized() * 1000)
		$Ghost.Dash(0.2)
		GameManager.emit_signal("ScreenShake", 0.5, 3, 100)
		
	if acceleration == Vector2():
		$Anim.play("IDLE")
	else:
		$Anim.play("RUN")
	
	velocity += acceleration
	$Body.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
	velocity *= 0.8
	
	acceleration = Vector2()

func OnAnimFinished(animName):
	if animName == "DASH":
		$Anim.play("IDLE")
	elif animName == "REPAIRING":
		$RepairCasting.hide()
		velocity = Vector2()
		$Anim.play("IDLE")
		
		for r in get_tree().get_nodes_in_group("Rabbit"):
			if r.global_position.distance_to($Position2D.global_position) < FixingArea:
				r.ChangeToNormal()
				
		for r in get_tree().get_nodes_in_group("Flower"):
			if r.global_position.distance_to($Position2D.global_position) < FixingArea:
				r.ChangeToNormal()
				
		for r in get_tree().get_nodes_in_group("GlitchTile"):
			if r.global_position.distance_to($Position2D.global_position) < FixingArea:
				var point = 150
				if false == GameManager.Config.empty():
					point *= GameManager.Config.PointMultiplier
				GameManager.emit_signal("OnObjectFixed", r.global_position, point)
				r.queue_free()

func Restart():
	RepairTimerCounter = 10.0
	DashTimerCounter = 10.0
	$Anim.play("IDLE")
	$RepairCasting.hide()