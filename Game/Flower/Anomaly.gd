extends Node2D

@export var AttackRange: int = 200
@export var Damage: int = 10
@export var AttackSpeed: float = 3.0
const PROJECTILE = preload("res://Game/Flower/FlowerProjectile.tscn")

var Target = null

var AttackCounter = 0.0

func _physics_process(delta):
	if $ProgressToGlitch.is_visible_in_tree():
		$ProgressToGlitch.value += delta
		return

func _process(delta):
	AttackCounter += delta
	
	if IsInAttackRange():
		if CanAttack():
			Attack()

func IsInAttackRange():
	return get_parent().position.distance_to(Target.position) <= AttackRange

func Attack():
	AttackCounter = 0.0
	var projectile = PROJECTILE.instantiate()
	projectile.set_as_top_level(true)
	get_parent().add_child(projectile)
	projectile.Init(Target)

func CanAttack():
	return AttackCounter >= AttackSpeed

func OnTreeEntered():
	Target = GameManager.GetPlayer()
	$ProgressToGlitch.show()
	set_process(false)

func OnTimeBeforeGlitch():
	get_parent().get_node("Anim").play("GLITCH")
	$ProgressToGlitch.hide()
	$ProgressToGlitch.value = 0.0
	set_process(true)
