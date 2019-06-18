extends Node2D

var Normal = null
var Anomaly = null
	
var GlitchDuration = 5.0
var NormalDuration = 5.0
var GlitchHappenChance = 0.1

var BehaviorChangerTimer = 0.0

var IsNormalBehavior = true
var SightRange = 500

func Init():
	pass
	
func _ready():
	Init()
	randomize()
	ChangeToNormal()

func _process(delta):
	BehaviorChangerTimer += delta
	
	if IsNormalBehavior:
		$Debug.text = str(round(NormalDuration - BehaviorChangerTimer)) + "sec"
		if BehaviorChangerTimer > NormalDuration:
			BehaviorChangerTimer -= NormalDuration
			if GameManager.GetPlayer().position.distance_to(position) < SightRange:
				var shouldGlitch = randf() < GlitchHappenChance
				if shouldGlitch:
					ChangeToGlitch()
	else:
		$Debug.text = str(round(GlitchDuration - BehaviorChangerTimer)) + "sec"
		if BehaviorChangerTimer > GlitchDuration:
			ChangeToNormal()
	
	$Debug.text += "\n" + "%" + str(GlitchHappenChance)
	
func ChangeToNormal():
	remove_child(Anomaly)
	add_child(Normal)
	IsNormalBehavior = true
	
func ChangeToGlitch():
	GlitchHappenChance = min(1, GlitchHappenChance + 0.1)
	if false == GameManager.HasSolution("Rabbit"):
		remove_child(Normal)
		add_child(Anomaly)
		IsNormalBehavior = false