extends Node2D

func OnArea2DEntered(area):
	if not area.is_in_group("Solution"):
		return
	
	GameManager.TrySolution(area.Solution)
	area.queue_free()