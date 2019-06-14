extends Area2D

export(String, "Health", "Stamina") var Bonus = "Stamina"

func _ready():
	$ColorRect/Label.text = "PowerUp \n" + Bonus
	
func OnSomethingEntered(body):
	if not body.is_in_group("Player"):
		return
		
	GameManager.GetPlayer().AddBonus(Bonus)
	queue_free()