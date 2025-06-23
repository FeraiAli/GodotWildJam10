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
var attraction_force = Vector2()
var is_attracted_to_mine: bool = false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	AttackCounter += delta
	
	# Check if being attracted to mine
	is_attracted_to_mine = attraction_force.length() > 0
	
	if is_attracted_to_mine:
		# If attracted to mine, move toward mine instead of player
		MoveTowardMine(delta)
	elif IsInAttackRange():
		if CanAttack():
			AttackDelayCounter += delta
			if AttackDelayCounter >= 0.3:
				Attack()
		else:
			Wait()
	else:
		MoveTowardTarget(delta)

func IsInAttackRange() -> bool:
	if is_attracted_to_mine:
		return false  # Don't attack when attracted to mine
	return get_parent().position.distance_to(GetTargetPosition()) <= AttackRadius
	
func CanAttack() -> bool:
	return AttackCounter >= AttackSpeed
	
func Attack() -> void:
	AttackDelayCounter = 0.0
	AttackCounter = 0.0
	GameManager.emit_signal("RequestGlitchingTile")

func Wait() -> void:
	pass

func MoveTowardMine(delta: float) -> void:
	# Move directly toward mine using attraction force
	var velocity = attraction_force.normalized() * Speed * 2  # Faster when attracted
	get_parent().set_velocity(velocity)
	get_parent().move_and_slide()
	get_parent().velocity
	
	# Reset attraction force after applying
	attraction_force = Vector2()

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

func apply_attraction(force: Vector2) -> void:
	attraction_force += force
