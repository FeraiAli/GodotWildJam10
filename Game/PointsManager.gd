extends Node2D

func _ready():
	GameManager.connect("OnObjectFixed", self, "OnObjectFixed")
	
func OnObjectFixed(points):
	var label = Label.new()
