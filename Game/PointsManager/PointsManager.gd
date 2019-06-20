extends Control

func _ready():
	GameManager.connect("OnObjectFixed", self, "OnObjectFixed")
	GameManager.connect("GameGenerateWorld", self, "Restart")
	
func _process(delta):
	for child in get_children():
		child.modulate.a8 -= 1
		child.rect_position.y -= 0.5
		if child.modulate.a8 == 0:
			child.queue_free()

func OnObjectFixed(pos, points):
	var label = Label.new()
	label.modulate = Color(0, 255, 0)
	label.rect_position = pos
	label.rect_position.y -= 40
	label.text = "+" + str(points)
	label.set_as_toplevel(true)
	add_child(label)

func Restart():
	for child in get_children():
		child.queue_free()