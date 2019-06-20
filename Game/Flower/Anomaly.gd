extends Node2D

export(int) var AttackRange = 200
export(int) var Damage = 10
export(float) var AttackSpeed = 2.0

const PROJECTILE = preload("res://Game/Flower/FlowerProjectile.tscn")

var Target = null

var AttackCounter = 0.0

func _process(delta):
	AttackCounter += delta
	
	if IsInAttackRange():
		if CanAttack():
			Attack()


func IsInAttackRange():
	return get_parent().position.distance_to(Target.position) <= AttackRange

func Attack():
	AttackCounter = 0.0
	var projectile = PROJECTILE.instance()
	projectile.set_as_toplevel(true)
	get_parent().add_child(projectile)
	projectile.Init(Target)

func CanAttack():
	return AttackCounter >= AttackSpeed

func OnTreeEntered():
	get_parent().get_node("Anim").play("GLITCH")
	Target = GameManager.GetPlayer()
