extends Node2D

func OnSomeoneEnteredArea(area):
	if area.is_in_group("Player"):
		if area.Solution.is_empty():
			return
		GameManager.TrySolution(area.Solution)
		area.Solution = ""