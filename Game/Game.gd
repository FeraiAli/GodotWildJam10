extends Node2D

export(int) var RabbitsCount = 40
export(int) var FlowerCount = 120

const RABBIT = preload("res://Game/Rabbit/Rabbit.tscn")
const FLOWER = preload("res://Game/Flower/Flower.tscn")
const SOLUTION = preload("res://Game/Solutions/Solution.tscn")

var _TilSize
func _ready():
	GameManager.connect("GameGenerateWorld", self, "RepositionObjects")
	randomize()
	_TilSize = GetTileMapSize()
	CreateObject(RABBIT, RabbitsCount)
	CreateObject(FLOWER, FlowerCount)
	CreateSolution("Rabbit")
	CreateSolution("Flower")

func RepositionObjects():
	for child in $Scene.get_children():
		if child == $Scene/Player:
			continue
		$Scene.remove_child(child)
		child.position = GetRandomPosition()
		$Scene.add_child(child)

func GetRandomPosition():
	var x = ((randi() % (int(_TilSize.size.x) - 150))) + 150
	var y = ((randi() % (int(_TilSize.size.y) - 150))) + 150
	return Vector2(x, y)

func CreateSolution(solutionName):
	var s = SOLUTION.instance()
	s.Solution = solutionName
	s.position = GetRandomPosition()
	$Scene.add_child(s)
	
func CreateObject(objectCreator, count):
	for i in range(0, count):
		var obj = objectCreator.instance()
		obj.position = GetRandomPosition()
		$Scene.add_child(obj)
		
func GetTileMapSize():
	var tileMap = $ProceduralMapMaker/TileMap
	var cell_bounds = tileMap.get_used_rect()
	var cell_to_pixel = Transform2D(Vector2(tileMap.cell_size.x * tileMap.scale.x, 0), 
	Vector2(0, tileMap.cell_size.y * tileMap.scale.y), Vector2())
	return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)