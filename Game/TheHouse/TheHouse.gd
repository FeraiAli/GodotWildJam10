extends Node2D

func OnSomeoneEnteredArea(area):
	if area.is_in_group("Player"):
		GameManager.TrySolution(area.Solution)