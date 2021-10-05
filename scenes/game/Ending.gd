extends Node2D


func _ready():
	$AnimationPlayer.playback_speed = (randf() * 0.2) + 0.2
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(randf())
