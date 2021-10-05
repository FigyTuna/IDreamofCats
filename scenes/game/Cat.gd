extends Node2D

const IS_DOG = false

const CAT_PRESETS = {
	"cat1" : {
		"scale": 2
	},
	"cat2" : {
		"max_vel": 6,
		"min_vel": 2,
		"push_force": 3,
		"scale": 2,
		"transfer_speed": 0.8
	},
	"cat3" : {
		"transfer_speed": 0.15,
		"max_vel": 1,
		"scale": 1.5,
		"aim": 0
	},
	"cat4" : {
		"max_vel": 6,
		"min_vel": 3,
		"transfer_speed": 0.4,
		"radius": 200,
		"push_force": -5,
		"aim": 0,
		"scale": 1.5
	},
	"cat5" : {
		"transfer_speed": 0.1,
		"scale": 1.5,
		"radius": 80
	},
	"bat" : {
		"max_vel": 7,
		"min_vel": 3,
		"radius": 150,
		"transfer_speed": 0.7,
		"push_force": -5,
	},
	"bone" : {
		"transfer_speed": 0.5,
		"push_force": 1
	},
	"boot": {
		"transfer_speed": 0.8
	},
	"collar": {
		"push_force": -5,
	},
	"door": {
		"max_vel": 15,
		"min_vel": 10,
		"radius": 200,
		"transfer_speed": 0.1,
		"push_force": 20,
		"scale": 3,
		"aim": 0
	},
	"flower": {
		"push_force": -0.4
	},
	"food": {
		"push_force": 0.3
	},
	"furball": {
		"push_force": 2.7,
		"scale": 2
	},
	"ham": {
		"push_force": -0.7
	},
	"hydrant": {
		"transfer_speed": 0.7,
	},
	"moon": {
		"max_vel": 3,
		"min_vel": 1,
		"transfer_speed": 0.7,
	},
	"paw": {
		"transfer_speed": 0.7
	},
	"pawgrey": {
		"transfer_speed": 0.7
	},
	"paworange": {
		"transfer_speed": 0.7
	},
	"pawspots": {
		"transfer_speed": 0.7
	},
	"rope": {
		"push_force": 0.7,
		"transfer_speed": 0.7
	},
	"sock": {
		"push_force": 1,
	},
	"steak": {
		"push_force": -0.7
	},
	"syringe": {
		"push_force": 5000,
		"transfer_speed": 10000
	},
	"tennis": {
		"push_force": 1,
		"transfer_speed": 0.7
	},
	"water": {
		"push_force": 0.3
	},
	"zzz": {
		"push_force": -0.1,
		"transfer_speed": 0.4
	},
}

var max_vel = 5
var min_vel = 1
var aim = 0.4
var transfer_speed = 1.0
var push_force = 0.0

var velocity
var rot_vel
var dest
var ending = null
var ending_music = null

var transfer_t = 0.0
var near_dog = false

var transferred = false
var despawning = false

signal transition(target)
signal collect_ending(ending)
signal sfx(good)

func initialize(cat):
	var preset = CAT_PRESETS[cat.preset]
	dest = cat.dest
	$Vis/Sprite.texture = Global.cats[cat.preset]
	if dest == "end":
		ending = cat.ending
		ending_music = cat.music
	if preset.has("max_vel"):
		max_vel = preset.max_vel
	if preset.has("min_vel"):
		min_vel = preset.min_vel
	if preset.has("aim"):
		aim = preset.aim
	if preset.has("transfer_speed"):
		transfer_speed = preset.transfer_speed
	if preset.has("radius"):
		$Area2D/CollisionShape2D.shape.radius = preset.radius
	if preset.has("scale"):
		$Vis.scale = Vector2(preset.scale, preset.scale)
	if preset.has("push_force"):
		push_force = preset.push_force
	var angle = randf() * PI * 2
	position = Vector2(cos(angle), sin(angle)) * 1000 + Global.CENTER
	velocity = Vector2(cos(randf() * aim * 2 - aim + angle + PI), sin(randf() * aim * 2 - aim + angle + PI)) * (randf() * (max_vel - min_vel) + min_vel)
	rot_vel = (randf() * 2 - 1) * 0.05 + 0.02
	$Vis.rotation = randf() * PI * 2

func _physics_process(delta):
	position += velocity
	$Vis.rotation += rot_vel
	if not despawning:
		if position.distance_to(Global.CENTER) > 1500:
			$AnimationPlayer.play("despawn")
		if near_dog:
			transfer_t += transfer_speed * delta
		elif not transferred:
			transfer_t -= transfer_speed * delta * 2
		transfer_t = clamp(transfer_t, 0, 1)
		$Particles2D.modulate.a = transfer_t
		if near_dog and not transferred:
			Global.dog.push_from(position, delta * push_force)
		if not transferred and transfer_t >= 1.0:
			transferred = true
			if dest:
				if dest == "point":
					Global.dog.set_point(true)
					Global.points += 1
					emit_signal("sfx", 0)
				elif dest == "unpoint":
					Global.dog.set_point(false)
					Global.dog.set_emote(1)
					emit_signal("sfx", 1)
				elif dest == "end":
					Global.dog.set_point(1)
					if ending != 3:
						Global.dog.set_emote(0)
					Global.points = 0
					$AnimationPlayer.play("grow")
					emit_signal("sfx", 2)
					emit_signal("collect_ending", ending, ending_music)
				else:
					Global.dog.set_point(false)
					if dest == "void" or dest == "A":
						Global.dog.set_emote(1)
						emit_signal("sfx", 1)
					else:
						emit_signal("sfx", 2)
					Global.points = 0
					emit_signal("transition", dest)

func _on_Area2D_area_entered(area):
	var dog = area.get_parent()
	if dog.IS_DOG:
		near_dog = true

func _on_Area2D_area_exited(area):
	var dog = area.get_parent()
	if dog.IS_DOG:
		near_dog = false

func despawn(force = false):
	if not transferred or force:
		$AnimationPlayer.play("despawn")
		despawning = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
