extends Node2D

# ******************************************************************************

onready var target_group = [
	$TypingTarget,
	$TypingTarget2,
	$TypingTarget3,
]

func _ready():
	for t in target_group:
		t.connect('matched', self, 'matched', [t])


func enable():
	for t in target_group:
		t.active = true

func matched(target):
	target_group.erase(target)
	if !target_group:
		$TypingTarget4.active = true
