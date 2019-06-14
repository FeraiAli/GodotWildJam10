extends CanvasLayer

func _process(delta):
	$Health/Label.text = "Health" + str(GameManager.GetPlayer().Health) + "/" + str(GameManager.GetPlayer().MaxHealth)
	$Stamina/Label.text = "Stamina " + str(GameManager.GetPlayer().Stamina as int) + "/" + str(GameManager.GetPlayer().MaxStamina as int)
