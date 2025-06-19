extends Area2D

@export var Solution = "Rabbit" # (String, "Rabbit", "Flower", "Water")

func _ready():
	add_to_group(Solution)
	ChangeToNormal()

func _process(delta):
	$Anim.play("ANIM")
	
func ChangeToNormal():
	pass
	
func ChangeToGlitch():
	$CollisionShape2D.disabled = false
	show()

func OnSomeoneEntered(body):
	if body.is_in_group("Player"):
		GameManager.GetPlayer().Solution = Solution
		queue_free()