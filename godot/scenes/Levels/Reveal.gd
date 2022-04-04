extends Node2D

func dead():
	$Label.dead()
	$AnimationPlayer.play("End")
