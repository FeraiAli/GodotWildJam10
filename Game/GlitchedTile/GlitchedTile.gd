extends Area2D

var PlayerIsInside = false
func _process(delta):
	if PlayerIsInside:
		GameManager.GetPlayer().velocity *= 0.75
	
func OnSomebodyEntered(body):
	if body.is_in_group("Player"):
		PlayerIsInside = true

func OnSomebodyExit(body):
	if body.is_in_group("Player"):
		PlayerIsInside = false
