extends Node

signal OnFinished()

var dashTick: float = 0.0
var dashTotalTime: float = 0.0
var dashTimer: float = 0.0

@export var dash_enabled: bool = false:
	set(value):
		dash_enabled = value
		var dash = get_parent().get_node("PlayerUI/Control/Panel/HBoxContainer/Dash")
		dash.value = dash.max_value if value else dash.min_value
	get:
		return dash_enabled

const dashCooldown: float = 1.0
var dashCooldownTimer: float = dashCooldown

var finished: bool = false

func _ready() -> void:
	dash_enabled = false
	set_process(false)

func Dash(dashTime: float) -> bool:
	var result = Start()
	dashTotalTime = dashTime
	return result
	
func Start() -> bool:
	if dashCooldownTimer < dashCooldown:
		return false
		
	dashTimer = 0.0
	dashTick = 0.0
	dashTotalTime = 0.0
	dashCooldownTimer = 0.0
	finished = false
	set_process(true)
	return true
	
func _process(delta: float) -> void:
	dashCooldownTimer += delta
	
	if dashCooldownTimer == dashCooldown:
		set_process(false)
		
	if finished:
		return
		
	if dashTotalTime > 0.0 and dashTimer >= dashTotalTime:
		finished = true
		emit_signal("OnFinished")
		return
		
	dashTick += delta
	
	dashTimer = min(dashTimer + delta, dashTotalTime)
	print(dashTimer)
	
	if dashTick > 0.05:
		dashTick -= 0.05
			
		var sprite = Sprite2D.new()
		sprite.texture = $Sprite2D.texture
		sprite.flip_h = get_parent().get_node("Body").flip_h
		sprite.position = get_parent().get_node("Marker2D").global_position
		sprite.set_as_top_level(true)
		add_child(sprite)
		
		var tweenTime = 0.5
		if dashTotalTime > 0.0:
			tweenTime = remap(dashTimer, 0.0, dashTotalTime, 1.2, 0.1)
		
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), tweenTime).from(Color(1, 1, 1, 1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.finished.connect(func(): OnTweenCompleted(sprite))
	
func Stop() -> void:
	emit_signal("OnFinished")
	set_process(false)

func OnTweenCompleted(sprite: Sprite2D) -> void:
	sprite.queue_free()
