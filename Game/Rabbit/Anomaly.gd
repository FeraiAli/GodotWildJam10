extends Node2D

@export var Damage: int = 10

#export(int) var AttackCulminationFrame = 0
@export var MaxDistanceFromHome: int = 500

@export var SightRange: int = 300
@export var AttackRadius: int = 20

@export var Speed: int = 170
@export var AttackSpeed: float = 1.0

var AttackCounter: float = 0.0
var AttackDelayCounter: float = 0.0
var Target: Node2D = null

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	AttackCounter += delta
	
	if IsInAttackRange():
		if CanAttack():
			AttackDelayCounter += delta
			if AttackDelayCounter >= 0.3:
				Attack()
		else:
			Wait()
	else:
		MoveTowardTarget(delta)

func IsInAttackRange() -> bool:
	return get_parent().position.distance_to(GetTargetPosition()) <= AttackRadius
	
func CanAttack() -> bool:
	return AttackCounter >= AttackSpeed
	
func Attack() -> void:
	AttackDelayCounter = 0.0
	AttackCounter = 0.0
	GameManager.emit_signal("RequestGlitchingTile")

func Wait() -> void:
	pass

func MoveTowardTarget(delta: float) -> void:
	var direction = GetTargetPosition() - get_parent().position
	var velocity = direction.normalized() * Speed
	get_parent().set_velocity(velocity)
	get_parent().move_and_slide()
	get_parent().velocity

func GetTargetPosition() -> Vector2:
	return Target.position
	
func OnTreeEntered() -> void:
	get_parent().get_node("Anim").play("JUMP_GLITCH")
	get_parent().get_node("Anim").speed_scale = 3.0
	get_parent().get_node("Anim").speed_scale = randf() * 2.0 + 1.0
	Target = GameManager.GetPlayer()
