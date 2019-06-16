extends Node2D

export(int) var RabbitsCount = 40
export(int) var FlowerCount = 120

const RABBIT = preload("res://Game/Rabbit/Rabbit.tscn")
const FLOWER = preload("res://Game/Flower/Flower.tscn")

func _ready():
	randomize()
	var rect = GetTileMapSize()
	CreateObject(RABBIT, RabbitsCount, rect)
	CreateObject(FLOWER, FlowerCount, rect)

func CreateObject(objectCreator, count, bounds):
	for i in range(0, count):
		var x = ((randi() % (int(bounds.size.x) - 100))) + 100
		var y = ((randi() % (int(bounds.size.y) - 100))) + 100
		var obj = objectCreator.instance()
		obj.position = Vector2(x, y)
		add_child(obj)
		
func GetTileMapSize():
    var cell_bounds = $TileMap.get_used_rect()
    var cell_to_pixel = Transform2D(Vector2($TileMap.cell_size.x * $TileMap.scale.x, 0), 
	Vector2(0, $TileMap.cell_size.y * $TileMap.scale.y), Vector2())
    return Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)