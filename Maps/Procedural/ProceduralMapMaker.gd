extends Node2D

const TILE_SIZE = 32
const WIDTH = (OS.window_size.x * 2) / TILE_SIZE
const HEIGHT = (OS.window_size.y * 2) / TILE_SIZE

var SimplexNoise = OpenSimplexNoise.new()

func _ready():
	randomize()
	SimplexNoise.seed = randi()
	SimplexNoise.octaves = 4
	SimplexNoise.period = 15
	SimplexNoise.lacunarity = 1.5
	SimplexNoise.persistence = 0.75
	GenerateWorld()

func _input(event):
	if event.is_action_pressed("ui_select"):
		SimplexNoise.seed = randi()
		GenerateWorld()
	elif event.is_action_pressed("ui_accept"):
		print("Saving Procedural Map Begin.")
		var packedScene = PackedScene.new()
		packedScene.pack($TileMap)
		ResourceSaver.save("res://Maps/Procedural/ProceduralMap.tscn", packedScene)
		print("Successfully Saved Procedural Map.")
	
func GenerateWorld():
	print("Generating Random Map Begin.")
	for x in WIDTH:
		for y in HEIGHT:
			var noiseSample = SimplexNoise.get_noise_2d(float(x), float(y))
			var tileID = GetTileByNoise(noiseSample)
			$TileMap.set_cell(x, y, tileID)
	$TileMap.update_bitmask_region()
	print("Random Map Successfully Generated.")
			
func GetTileByNoise(sample):
	if sample < -0.1:
		return 1
	else:
		return 0
		
