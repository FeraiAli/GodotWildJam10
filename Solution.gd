extends Area2D

export(String, "Rabbit", "Flower", "Water") var Solution = "Rabbit"

func _ready():
	add_to_group(Solution)
	
	$ColorRect/Label.text = "FIX = " + Solution
	ToNormal()
	
func OnSomeoneEnteredArea(body):
	if body.is_in_group("Player"):
		GameManager.GetPlayer().Solution = Solution
		queue_free()

func ToNormal():
	$CollisionShape2D.disabled = true
	hide()
	
func ToAnomaly():
	$CollisionShape2D.disabled = false
	show()