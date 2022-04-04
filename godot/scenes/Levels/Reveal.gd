extends Node2D

func dead():
	$Label.start()
	$AnimationPlayer.play("End")
	Game.ending = true
