extends Node2D

const TILE_SIZE = 32
const WIDTH = (OS.window_size.x * 2) / TILE_SIZE
const HEIGHT = (OS.window_size.y * 2) / TILE_SIZE

var SimplexNoise = OpenSimplexNoise.new()
var _TileMapSize

func _ready():
	GameManager.connect("GameGenerateWorld", self, "GenerateWorld") 
	randomize()
	SimplexNoise.octaves = 4
	SimplexNoise.period = 15
	SimplexNoise.lacunarity = 1.5
	SimplexNoise.persistence = 0.75
	GenerateWorld()

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		print("Saving Procedural Map Begin.")
#		var packedScene = PackedScene.new()
#		packedScene.pack($Forest)
#		ResourceSaver.save("res://MapGenerator/Procedural/ForestMap.tscn", packedScene)
#
#		packedScene.pack($TileMap)
#		ResourceSaver.save("res://MapGenerator/Procedural/GroundMap.tscn", packedScene)
#		print("Successfully Saved Procedural Map.")

func GenerateWorld():
	var forestMap = get_parent().get_node("ForestMap")
	var tileMap = get_parent().get_node("GroundMap")
	
	forestMap.clear()
	SimplexNoise.seed = randi()

	for x in WIDTH:
		for y in HEIGHT:
			var noiseSample = SimplexNoise.get_noise_2d(float(x), float(y))
			var tileID = GetTileByNoise(noiseSample)
			tileMap.set_cell(x, y, tileID)
			
			noiseSample = SimplexNoise.get_noise_2d(float(x * 2), float(y * 2))
			if ShouldPlaceTree(noiseSample):
				var treeChange = randf()
				
				var treeId = 0
				if treeChange > 0.5: treeId = 1
				elif treeChange > 0.75: treeId = 2
				forestMap.set_cell(x,y, treeId)
				
	for x in range(0, 5):
		for y in range(0, 5):
			forestMap.set_cell(x,y,-1)
			tileMap.set_cell(x,y,0)
	
	tileMap.update_bitmask_region()
	forestMap.update_bitmask_region()
	
	var cell_bounds = tileMap.get_used_rect()
	var cell_to_pixel = Transform2D(Vector2(tileMap.cell_size.x * tileMap.scale.x, 0), 
	Vector2(0, tileMap.cell_size.y * tileMap.scale.y), Vector2())
	var rect2 = Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size)
	_TileMapSize = Vector2(rect2.size.x, rect2.size.y)
			
func GetTileByNoise(sample):
	if sample < -0.1:
		return 1
	else:
		return 0

func ShouldPlaceTree(sample):
	return sample < -0.2

func GetTileMapSize():
	return _TileMapSize