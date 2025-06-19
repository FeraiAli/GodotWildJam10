extends Node2D

@export var BeesCount: int = 22
@export var RabbitsCount: int = 33
@export var FlowerCount: int = 80

const BEE = preload("res://Game/Bees/Bee.tscn")
const RABBIT = preload("res://Game/Rabbit/Rabbit.tscn")
const FLOWER = preload("res://Game/Flower/Flower.tscn")
const SOLUTION = preload("res://Game/Solutions/Solution.tscn")
const GLITCHED_TILE = preload("res://Game/GlitchedTile/GlitchedTile.tscn")

func _ready():
	if false == GameManager.Config.is_empty():
		BeesCount = GameManager.Config.BeesCount
		RabbitsCount = GameManager.Config.RabbitsCount
		FlowerCount = GameManager.Config.FlowerCount
	
	$Player.get_node("PlayerUI").TotalObjects = RabbitsCount + FlowerCount
	GameManager.connect("RequestGlitchingTile", Callable(self, "GlitchTile"))
	GameManager.connect("GameGenerateWorld", Callable(self, "Restart"))
	randomize()
	
	CreateObject(RABBIT, $Scene, RabbitsCount)
	CreateObject(FLOWER, $Scene, FlowerCount)
	CreateObject(BEE, $FlyingObjects, BeesCount)
	$TheHouse.position = Vector2(30, 35)
	$Player.position = Vector2(50, 150)

func Restart():
	$TheHouse.position = Vector2(30, 35)
	$Player.position = Vector2(50, 150)
	for child in $GlitchTiles.get_children():
		child.queue_free()
	
	for child in $Scene.get_children():
		if child == $Scene/Player:
			continue
		$Scene.remove_child(child)
		child.position = GetRandomPosition()
		$Scene.add_child(child)

func GetRandomPosition():
	var x = ((randi() % (int($MapMaker.GetTileMapSize().x) - 100))) + 160
	var y = ((randi() % (int($MapMaker.GetTileMapSize().y) - 100))) + 160
	return Vector2(x, y)
	
func CreateObject(objectCreator, scene, count):
	for i in range(0, count):
		var obj = objectCreator.instantiate()
		obj.position = GetRandomPosition()
		scene.add_child(obj)
		
func GlitchTile():
	var tile = GLITCHED_TILE.instantiate()
	tile.position = GetRandomPosition()
	$GlitchTiles.add_child(tile)
	$Player.get_node("PlayerUI").OnTileGlitched()
	
