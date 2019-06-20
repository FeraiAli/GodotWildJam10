extends AnimatedSprite

const SPEED = 200
#const DAMAGE
var TargetPos
var Target = null
var Direction

func _ready():
	GameManager.connect("GameGenerateWorld", self, "SelfDestroy")
	play("idle")

func SelfDestroy():
	set_process(false)
	queue_free()
	
func _process(delta):
	if null != Target:
		TargetPos = Target.get_node("Position2D").global_position
		
	var dist = TargetPos.distance_to(self.global_position)
	if dist < 10.0:
		if Target != null:
			GameManager.emit_signal("RequestGlitchingTile")
		queue_free()
	else:
		var velocity = SPEED * Direction.normalized()
		position += velocity * delta
		
	if get_parent().position.distance_to(position) > 800.0:
		queue_free()
	
func Init(target):
	position = get_parent().get_node("Position2D").global_position
	var weakRefTarget = weakref(target)
	Target = weakRefTarget.get_ref()
	Direction = Target.get_node("Position2D").global_position - self.global_position
	rotation = global_position.angle_to_point(Target.get_node("Position2D").global_position) + 1.6