extends Node2D

func dead():
	$AnimationPlayer.play("End")
	Game.ending = true
	yield(get_tree().create_timer(7), "timeout")
	$Label.start()
