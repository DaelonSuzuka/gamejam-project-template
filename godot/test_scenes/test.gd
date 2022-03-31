extends Node

var preScript = preload("res://addons/softnoise.gd")
var softnoise

func _ready():
	#Random
	softnoise = preScript.SoftNoise.new()
	#Passing a seed
	softnoise = preScript.SoftNoise.new(1729)

	softnoise.simple_noise1d(2)
	softnoise.simple_noise2d(2, 3)

	softnoise.value_noise2d(2, 3)
	softnoise.perlin_noise2d(2, 3)

	softnoise.openSimplex2D(2, 3)
	softnoise.openSimplex3D(2, 3, 1)
	softnoise.openSimplex4D(2, 3, 1, .5)

#	softnoise.
