extends StaticBody2D

func dead():
	$Sprite.texture = load("res://assets/gate_open.png")
	$CollisionShape2D.set_deferred("disabled",true)


