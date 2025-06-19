extends Control

func _ready():
	GameManager.connect("OnObjectFixed", Callable(self, "OnObjectFixed"))
	GameManager.connect("GameGenerateWorld", Callable(self, "Restart"))
	
func _process(delta):
	for child in get_children():
		child.modulate.a8 -= 1
		child.position.y -= 0.5
		if child.modulate.a8 == 0:
			child.queue_free()

func OnObjectFixed(pos, points):
	var label = Label.new()
	label.modulate = Color(0, 255, 0)
	label.position = pos
	label.position.y -= 40
	label.text = "+" + str(points)
	label.set_as_top_level(true)
	add_child(label)

func Restart():
	for child in get_children():
		child.queue_free()