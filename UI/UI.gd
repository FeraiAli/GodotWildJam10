extends CanvasLayer

var Points = 0
var GlitchedTiles = 0
var GlitchedObjects = 0
var TotalObjects = 0
var RepairUsedTimes = 0
var TimeSinceStart = OS.get_ticks_msec()

func _ready():
	GameManager.connect("OnRepeairBegin", self, "OnRepairUsed")
	GameManager.connect("OnObjectFixed", self, "OnPointGained")
	GameManager.connect("ObjectIsGlitching", self, "OnObjectGlitched")
	
func _process(delta):
	$Control/HBoxContainer/SurvivalTime.text = "SURVIVAL TIME: " + str(PassedTime()) + " seconds"
	$Control/Panel/HBoxContainer/Repair.value = get_parent().RepairTimerCounter
	$Control/Panel/HBoxContainer/Dash.value = get_parent().DashTimerCounter

func OnRepairUsed():
	RepairUsedTimes += 1
	
func OnPointGained(point):
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

func PassedTime():
	return round((OS.get_ticks_msec() - TimeSinceStart) / 1000)
	
func GetGlitchPercent():
	var objects = range_lerp(GlitchedObjects, 0, TotalObjects, 0, 50)
	var result = min(100, objects + GlitchedTiles) as int
	if result == 100:
		var score = max(0, Points - (RepairUsedTimes * 2))
		score += PassedTime()
		$Control/GameMenu/VBox/HighScore/Label.text = "TOTAL SCORE: " + str(score)
		$Control/GameMenu.show()
		$Control/GameMenu/VBox/HighScore.show()
		$Control/HBoxContainer/MoreOptions.disabled = true
		GameManager.OnGameOver()
		
	return str(result)

func OnMoreOptionsPressed():
	if $Control/GameMenu.is_visible_in_tree():
		$Control/GameMenu.hide()
	else:
		$Control/GameMenu.show()

func OnRestartPressed():
	GameManager.RestartTheGame()
	TimeSinceStart = OS.get_ticks_msec()
	Points = 0
	GlitchedTiles = 0
	GlitchedObjects = 0
	RepairUsedTimes = 0
	$Control/GameMenu.hide()
	
	$Control/HBoxContainer/Points.text = "POINTS: " + str(Points)
	$Control/HBoxContainer/WorldGlitchPercentage.text = "WORLD GLITCH " + GetGlitchPercent() + "%"

func OnBackToMenuPressed():
	print("BACK TO MAIN MENU")
	pass # Replace with function body.
