extends CanvasLayer

var Points = 0
var GlitchedTiles = 0
var GlitchedObjects = 0
var TotalObjects = 0
var RepairUsedTimes = 0
var TimeSinceStart = 0

func _ready():
	GameManager.connect("OnRepeairBegin", Callable(self, "OnRepairUsed"))
	GameManager.connect("OnObjectFixed", Callable(self, "OnPointGained"))
	GameManager.connect("ObjectIsGlitching", Callable(self, "OnObjectGlitched"))
	
func _process(delta):
	TimeSinceStart += delta
	$Control/HBoxContainer/SurvivalTime.text = "SURVIVAL TIME: " + str(round(TimeSinceStart)) + " seconds"
	$Control/Panel/HBoxContainer/Repair.value = get_parent().RepairTimerCounter
	if get_parent().get_node("Ghost").dash_enabled:
		$Control/Panel/HBoxContainer/Dash.value = get_parent().DashTimerCounter

func OnRepairUsed():
	RepairUsedTimes += 1
	
func OnPointGained(pos, point):
	GlitchedObjects = max(0, GlitchedObjects - 1)
	Points += point
	$Control/HBoxContainer/Points.text = "POINTS: " + str(Points)
	
	$Control/HBoxContainer/WorldGlitchPercentage.text = "WORLD GLITCH " + GetGlitchPercent() + "%"
	
func OnObjectGlitched():
	GlitchedObjects += 1
	$Control/HBoxContainer/WorldGlitchPercentage.text = "WORLD GLITCH " + GetGlitchPercent() + "%"

func OnTileGlitched():
	GlitchedTiles += 1
	$Control/HBoxContainer/WorldGlitchPercentage.text = "WORLD GLITCH " + GetGlitchPercent() + "%"
	
func GetGlitchPercent():
	var objects = remap(GlitchedObjects, 0, TotalObjects, 0, 25)
	var result = min(100, objects + GlitchedTiles) as int
	if result == 100:
		var score = max(0, Points - (RepairUsedTimes * 25))
		score += round(TimeSinceStart * 10)
		$Control/GameMenu/VBox/HighScore/Label.text = "TOTAL SCORE: " + str(score)
		$Control/GameMenu.show()
		$Control/GameMenu/VBox/HighScore.show()
		$Control/HBoxContainer/MoreOptions.disabled = true
		GameManager.OnGameOver(score)
		
	return str(result)

func OnMoreOptionsPressed():
	if $Control/GameMenu.is_visible_in_tree():
		$Control/GameMenu.hide()
		get_tree().paused = false
	else:
		$Control/GameMenu.show()
		get_tree().paused = true

func OnRestartPressed():
	GameManager.RestartTheGame()
	TimeSinceStart = 0
	Points = 0
	GlitchedTiles = 0
	GlitchedObjects = 0
	RepairUsedTimes = 0
	$Control/GameMenu.hide()
	
	$Control/HBoxContainer/Points.text = "POINTS: " + str(Points)
	$Control/HBoxContainer/WorldGlitchPercentage.text = "WORLD GLITCH " + GetGlitchPercent() + "%"

func OnBackToMenuPressed():
	get_tree().quit()