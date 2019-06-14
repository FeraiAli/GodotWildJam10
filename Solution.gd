extends Area2D

export(String, "Rabbit", "Flower", "Water") var Solution = "Rabbit"

func _ready():
	add_to_group(Solution)
	
	$ColorRect/Label.text = "FIX = " + Solution
	hide()
	
func OnSomeoneEnteredArea(body):
	if body.is_in_group("Player"):
		GameManager.GetPlayer().Solution = Solution
		queue_free()

func ToNormal():
	hide()
	
func ToAnomaly():
	print("SHOW")
	show()