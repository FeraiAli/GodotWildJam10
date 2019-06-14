extends Area2D

export(String, "Rabbit", "Flower", "Water") var Solution = "Rabbit"

func OnSomeoneEnteredArea(body):
	if body.is_in_group("Player"):
		GameManager.GetPlayer().Solution = Solution
		queue_free()
