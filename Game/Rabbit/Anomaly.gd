extends Node2D

export(int) var Damage = 10

#export(int) var AttackCulminationFrame = 0
export(int) var MaxDistanceFromHome = 500

export(int) var SightRange = 300
export(int) var AttackRadius = 100

export(int) var Speed = 170
export(float) var AttackSpeed = 1.0

var AttackCounter = 0.0
var Target = null

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
	#print("Attack")
	#set_process(false)
	AttackCounter = 0.0
	pass
	#play("attack")

func Wait():
	#print("Wait")
	pass
	#play("idle")

func MoveTowardTarget(delta):
	#print("Walk")
	#play("walk")
	var direction = GetTargetPosition() - get_parent().position
	#flip_h = (direction.x < 0)

	var velocity = (direction.normalized() * Speed)
	get_parent().move_and_slide(velocity)

func GetTargetPosition():
	#return get_global_mouse_position()
	return Target.position
	
func OnTreeEntered():
	#TODO(feri) - Jump
	Target = GameManager.GetPlayer()
