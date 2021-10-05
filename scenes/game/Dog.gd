extends Node2D

const IS_DOG = true

const FORCE_MULT = 100000
const MAX_FORCE = 1000

var velocity = Vector2()

var rot_vel = 0.0

var point = false

func _ready():
	spin()
	$Shake.play("shake")
	$Wag.play("wag")

func spin():
	rot_vel += (randf() * 2 - 1) * 0.1

func set_point(t):
	if t and not point:
		$particles.play("part")
		set_emote(0)
		point = true
	elif not t and point:
		$particles.play_backwards("part")
		$Wag.playback_speed = 1.0
		set_emote(2)
		point = false

func set_emote(e):
	$Vis/Head/Head.visible = false
	$Vis/Head/Happy.visible = false
	$Vis/Head/Sad.visible = false
	if e == 0:
		$Wag.playback_speed = 2.0
		$Vis/Head/Happy.visible = true
	elif e == 1:
		$Wag.playback_speed = 0.2
		$Vis/Head/Sad.visible = true
	else:
		$Wag.playback_speed = 1.0
		$Vis/Head/Head.visible = true

func push_from(from, force):
	var angle = get_angle_to(from) + PI
	var distance = clamp(position.distance_to(from), -450, 450)
	return push(angle, (1 / distance) * force)

func push(angle, force):
	var ret = Vector2(cos(angle), sin(angle)) * clamp(force * FORCE_MULT, -MAX_FORCE, MAX_FORCE)
	velocity += ret
	return ret

func _physics_process(delta):
	var dist = position.distance_to(Global.CENTER)
	velocity /= 1.1
	position += velocity * delta
	position = lerp(position, Global.CENTER, clamp(delta * (dist / 450) * 3, 0, 1))
	
	rot_vel /= 1.03
	$Vis.rotation += rot_vel
	
	var ifpoint = 0.0
	if point:
		ifpoint = 1.0
	$Shake.playback_speed = rot_vel * 40 + (abs(velocity.x) + abs(velocity.y)) * 0.005 + 0.5 + ifpoint
