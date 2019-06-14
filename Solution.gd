extends Area2D

export(String, "Rabbit", "Flower", "Water") var Solution = "Rabbit"

var test_follow_mouse = false

func _process(delta):
	if get_global_mouse_position().distance_to(position) < 100:
		test_follow_mouse = true
		
	if false == test_follow_mouse:
		return
		
	position = get_global_mouse_position()
	
func OnSomeoneEnteredArea(area):
	if area.is_in_group("Player"):
		#TODO(feri) - follow the player
		pass