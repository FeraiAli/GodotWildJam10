extends Node2D

export(int) var Damage = 10

#export(int) var AttackCulminationFrame = 0
export(int) var MaxDistanceFromHome = 500

export(int) var SightRange = 300
export(int) var AttackRadius = 20

export(int) var Speed = 170
export(float) var AttackSpeed = 1.0

var AttackCounter = 0.0
var Target = null

func _ready():
	randomize()

func _process(delta):
	AttackCounter += delta
	
	if IsInAttackRange():
		if CanAttack():
			Attack()
		else:
			Wait()
	else:
		MoveTowardTarget(delta)

func IsInAttackRange():
	return get_parent().position.distance_to(GetTargetPosition()) <= AttackRadius
	
func CanAttack():
	return AttackCounter >= AttackSpeed
	
func Attack():
	AttackCounter = 0.0
	GameManager.emit_signal("RequestGlitchingTile")

func Wait():
	pass

func MoveTowardTarget(delta):
	var direction = GetTargetPosition() - get_parent().position

	var velocity = (direction.normalized() * Speed)
	get_parent().move_and_slide(velocity)

func GetTargetPosition():
	return Target.position
	
func OnTreeEntered():
	get_parent().get_node("Anim").play("JUMP_GLITCH")
	get_parent().get_node("Anim").playback_speed = 3
	get_parent().get_node("Anim").playback_speed = randf() * 2 + 1
	Target = GameManager.GetPlayer()
