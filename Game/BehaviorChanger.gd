extends Node2D

var Normal = null
var Anomaly = null
	
var NormalDuration = 10.0
var GlitchHappenChance = 0.0

var BehaviorChangerTimer = 0.0

var IsNormalBehavior = true

func Init():
	pass
	
func _ready():
	GameManager.connect("GameGenerateWorld", self, "Restart")
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
		GlitchHappenChance = min(1, GlitchHappenChance + 0.1)
		if randf() < GlitchHappenChance:
			ChangeToGlitch()
	
func ChangeToNormal():
	if false == IsNormalBehavior:
		GameManager.emit_signal("OnObjectFixed", 5)
		Restart()
	
func ChangeToGlitch():
	GameManager.emit_signal("ObjectIsGlitching")
	remove_child(Normal)
	add_child(Anomaly)
	IsNormalBehavior = false