extends Node2D

const TILE_SIZE = 32
var WIDTH: int
var HEIGHT: int

var SimplexNoise = FastNoiseLite.new()
var _TileMapSize

func _ready():
	WIDTH = int((get_window().size.x * 2) / TILE_SIZE)
	HEIGHT = int((get_window().size.y * 2) / TILE_SIZE)
	
	GameManager.connect("GameGenerateWorld", Callable(self, "GenerateWorld")) 
	randomize()
	SimplexNoise.fractal_octaves = 4
	SimplexNoise.frequency = 1.0/15.0  # Convert period to frequency
	SimplexNoise.fractal_lacunarity = 1.5
	SimplexNoise.fractal_gain = 0.75  # persistence is now called fractal_gain
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
			tileMap.set_cell(Vector2i(x, y), tileID, Vector2i(0, 0))
			
			noiseSample = SimplexNoise.get_noise_2d(float(x * 2), float(y * 2))
			if ShouldPlaceTree(noiseSample):
				var treeChange = randf()
				
				var treeId = 0
				if treeChange > 0.5: treeId = 1
				elif treeChange > 0.75: treeId = 2
				forestMap.set_cell(Vector2i(x, y), treeId, Vector2i(0, 0))
				
	for x in range(0, 5):
		for y in range(0, 5):
			forestMap.set_cell(Vector2i(x, y), -1, Vector2i(0, 0))
			tileMap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	
	# Update the tilemap's bitmasks
	tileMap.notify_runtime_tile_data_update()
	forestMap.notify_runtime_tile_data_update()
	
	var cell_bounds = tileMap.get_used_rect()
	var cell_to_pixel = Transform2D(Vector2(tileMap.tile_set.tile_size.x * tileMap.scale.x, 0), 
	Vector2(0, tileMap.tile_set.tile_size.y * tileMap.scale.y), Vector2())
	
	# Convert Vector2i to Vector2 for transform calculation
	var bounds_pos = Vector2(cell_bounds.position.x, cell_bounds.position.y)
	var bounds_size = Vector2(cell_bounds.size.x, cell_bounds.size.y)
	var rect2 = Rect2(cell_to_pixel * bounds_pos, cell_to_pixel * bounds_size)
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
