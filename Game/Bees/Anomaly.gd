extends Node2D

var Speed = 200
var AnomalyCounter = 0.0

func _process(delta):
	AnomalyCounter += delta
#	if AnomalyCounter >= 5.0:
#		get_parent().ChangeToNormal()
#		return
	
	var closest = null
	var closestDistance = 9999
	for r in get_tree().get_nodes_in_group("Rabbit"):
		if r.IsNormalBehavior:
			var d = get_parent().position.distance_to(r.position)
			if d < closestDistance:
				closestDistance = d
				closest = r
				
	if closest != null:
		if closestDistance < 10:
			closest.ChangeToGlitch()
			get_parent().ChangeToNormal()
		else:
			get_parent().MoveToward(closest.position, Speed)

func OnTreeEntered():
	get_parent().get_node("Anim").play("IDLE_GLITCH")
