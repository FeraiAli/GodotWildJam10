extends Node

var SafePoint = Vector2()
var SafeDistance = 200
var JumpDistance = 100

var JumpTime = 0.5
var JumpTimeCounter = 0.0

var TargetPoint = Vector2()

func _ready():
	randomize()
	$JumpDelay.wait_time = (randf() * 3) + 2
	set_process(false)

func _process(delta):
	JumpTimeCounter = min(JumpTimeCounter + delta, JumpTime)
	
	var time = range_lerp(JumpTimeCounter, 0.0, JumpTime, 0.0, 1.0)
	var nextPosition = get_parent().position.linear_interpolate(TargetPoint, time)
	var velocity = nextPosition - get_parent().position
	get_parent().move_and_slide(velocity)
	
	if time == 1.0: 
		set_process(false)
		#TODO(feri) - IDLE
	
func OnTreeEntered():
	SafePoint = get_parent().position
	TargetPoint = get_parent().position
	
	#TODO(feri) - IDLE
	StartJump()

func StartJump():
	var direction = Vector2()
	
	if TargetPoint.distance_to(SafePoint) > SafeDistance:
		direction = SafePoint - TargetPoint
	else:
		var degree = randi() % 360
		var radian = deg2rad(degree)
		direction = Vector2(cos(radian), sin(radian))
	
	TargetPoint += direction.normalized() * JumpDistance
	
	JumpTimeCounter = 0.0
	$JumpDelay.start()
	
	set_process(true)
	#TODO(feri) - JUMP
	