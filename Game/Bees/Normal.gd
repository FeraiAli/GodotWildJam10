extends Node

var Speed = 100
var Acceleration = Vector2()
var Velocity = Vector2()

var findTarget = false
var flowerTargets = []
var indexTarget = 0
var waitTimeCounter = 0

func _ready():
	randomize()
	flowerTargets = get_tree().get_nodes_in_group("Flower")
	flowerTargets.shuffle()
	
func _process(delta):
	var TargetFlowerPosition = flowerTargets[indexTarget].get_node("Marker2D").global_position
	
	if get_parent().position.distance_to(TargetFlowerPosition) < 5:
		if flowerTargets[indexTarget].IsNormalBehavior == false:
			indexTarget = (indexTarget + 1) % (flowerTargets.size())
			get_parent().ChangeToGlitch()
			return
			
		Velocity = Vector2()
		waitTimeCounter += delta
		if waitTimeCounter > 3.5:
			indexTarget = (indexTarget + 1) % (flowerTargets.size())
			waitTimeCounter = 0.0
	else:
		get_parent().MoveToward(TargetFlowerPosition, Speed)


func OnTreeEntered():
	get_parent().get_node("Anim").play("IDLE_NORMAL")
