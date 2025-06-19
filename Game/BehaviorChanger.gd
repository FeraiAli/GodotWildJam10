extends Node2D

var Normal = null
var Anomaly = null
	
var NormalDuration = 10.0
var GlitchHappenChance = 0.0
var GlitchIncreaseFactor = 0.05

var BehaviorChangerTimer = 0.0

var IsNormalBehavior = true

func Init():
	pass
	
func _ready():
	if false == GameManager.Config.is_empty():
		NormalDuration = GameManager.Config.NormalDuration
		GlitchHappenChance = GameManager.Config.GlitchHappenChance
		GlitchIncreaseFactor = GameManager.Config.GlitchIncreaseFactor
		
	GameManager.connect("GameGenerateWorld", Callable(self, "Restart"))
	Init()
	randomize()
	add_child(Normal)

func Restart():
	GlitchHappenChance = 0.0
	BehaviorChangerTimer = 0.0
	remove_child(Anomaly)
	add_child(Normal)
	IsNormalBehavior = true
	
func _process(delta):
	BehaviorChangerTimer += delta
	
	if false == IsNormalBehavior:
		return
		
	if BehaviorChangerTimer > NormalDuration:
		BehaviorChangerTimer -= NormalDuration
		GlitchHappenChance = min(1, GlitchHappenChance + GlitchIncreaseFactor)
		if randf() < GlitchHappenChance:
			ChangeToGlitch()
	
func ChangeToNormal():
	if false == IsNormalBehavior:
		var point = 50
		if false == GameManager.Config.is_empty(): point *= GameManager.Config.PointMultiplier
		GameManager.emit_signal("OnObjectFixed", global_position, point)
		Restart()
	
func ChangeToGlitch():
	GameManager.emit_signal("ObjectIsGlitching")
	remove_child(Normal)
	add_child(Anomaly)
	IsNormalBehavior = false