extends AnimatedSprite2D

const SPEED = 100
#const DAMAGE
var TargetPos
var Target = null
var Direction
var isDisappearing = false

func _ready():
	GameManager.connect("GameGenerateWorld", Callable(self, "SelfDestroy"))
	play("default")

func SelfDestroy():
	set_process(false)
	queue_free()
	
func _process(delta):
	if null != Target:
		TargetPos = Target.get_node("Marker2D").global_position
		
	var dist = TargetPos.distance_to(self.global_position)
	if dist < 10.0:
		if Target != null:
			GameManager.emit_signal("RequestGlitchingTile")
		queue_free()
	else:
		var velocity = SPEED * Direction.normalized()
		position += velocity * delta
		
	if get_parent().position.distance_to(position) > 300.0 and not isDisappearing:
		_startDisappearingAnimation()
	
func Init(target):
	position = get_parent().get_node("Marker2D").global_position
	var weakRefTarget = weakref(target)
	Target = weakRefTarget.get_ref()
	Direction = Target.get_node("Marker2D").global_position - self.global_position
	rotation = global_position.angle_to_point(Target.get_node("Marker2D").global_position) + 1.6

func _startDisappearingAnimation():
	isDisappearing = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.5)

	tween.tween_callback(Callable(self, "queue_free"))
