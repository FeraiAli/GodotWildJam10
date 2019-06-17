extends AnimatedSprite

const SPEED = 250
#const DAMAGE

var Target = null
var TargetPos
var Direction

func _ready():
	play("idle")
	
func _process(delta):
	
	if null != Target:
		TargetPos = Target.global_position
		
	var dist = TargetPos.distance_to(self.global_position)
	if dist < 10.0:
		if Target != null:
			print("HIT")
#			target.Hurt(damage)
		queue_free()
	else:
		var velocity = SPEED * Direction.normalized()
		position += velocity * delta
	
func Init(target):
	position = get_parent().global_position
	var weakRefTarget = weakref(target)
	Target = weakRefTarget.get_ref()
	Direction = Target.global_position - self.global_position
	rotation = global_position.angle_to_point(Target.global_position) + 1.6
	