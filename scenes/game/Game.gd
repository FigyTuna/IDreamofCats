extends Node2D

const BGS = [
	preload("res://images/backgrounds/bg0.png"),
	preload("res://images/backgrounds/bg1.png"),
	preload("res://images/backgrounds/bg2.png"),
	preload("res://images/backgrounds/bg3.png"),
	preload("res://images/backgrounds/bg4.png"),
	preload("res://images/backgrounds/bg5.png")
]

const PS = [
	preload("res://palettes/p0.tres"),
	preload("res://palettes/p1.tres"),
	preload("res://palettes/p2.tres"),
	preload("res://palettes/p3.tres"),
	preload("res://palettes/p4.tres"),
	preload("res://palettes/p5.tres"),
	preload("res://palettes/p6.tres"),
	preload("res://palettes/p7.tres")
]

const MAP = {
	"main": {
		"music": "pre_main",
		"spawn_rate": 1,
		"max_spawned": 3,
		"shader": [
			0.075, 10.0, 2.0, 0.1, 0.1, 1.0, Vector2(0.0, 0.0), 0.08, true, 0.01, 7,
			0.075, 5.0, 2.0, 0.5, 1.0, 1.0, Vector2(-0.2, 0.0), 0.1, true, 0.03, 7,
			Color(0.431373, 0.407843, 0.407843), 0, 3
		],
		"cats": [
			{"preset": "bone", "dest": "point", "chance": 2},
			{"preset": "hydrant", "dest": "point", "chance": 1},
			{"preset": "food", "dest": "point", "chance": 2},
			{"preset": "water", "dest": "point", "chance": 2},
			{"preset": "paw", "dest": "one", "chance": 3, "req": 2},
			{"preset": "pawspots", "dest": "two", "chance": 1, "req": 2},
			{"preset": "paworange", "dest": "three", "chance": 3, "req": 2},
			{"preset": "pawgrey", "dest": "four", "chance": 1, "req": 2},
		]
	},
	"one": {
		"music": "one",
		"spawn_rate": 2,
		"max_spawned": 7,
		"shader": [
			0.075, 5.0, 2.0, 1.0, 1.0, 1.0, Vector2(0.2, 0.0), 0.2, true, 0.05, 7,
			0.02, 80.0, 10.0, 1.0, 2.0, 0.5, Vector2(1.0, -4.0), 0.3, true, 0.02, 6,
			Color(0.372549, 0.611765, 0.498039), 1, 4
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 8},
			{"preset": "paworange", "dest": "three", "chance": 1},
			{"preset": "pawgrey", "dest": "four", "chance": 1},
			{"preset": "flower", "dest": "point", "chance": 2},
			{"preset": "food", "dest": "point", "chance": 2},
			{"preset": "water", "dest": "point", "chance": 2},
			{"preset": "sock", "dest": "point", "chance": 2},
			{"preset": "bone", "dest": "point", "chance": 2},
			{"preset": "rope", "dest": "B", "chance": 1, "req": 1},
			{"preset": "zzz", "dest": "M", "chance": 2, "req": 3}
		]
	},
	"two": {
		"music": "two",
		"spawn_rate": 2,
		"max_spawned": 7,
		"shader": [
			0.4, 20.0, 2.0, 0.1, 0.1, 1.0, Vector2(0.0, 1.0), 0.2, true, 0.2, 4,
			0.1, 5.0, 2.0, 0.1, 5.0, 10.0, Vector2(-0.3, 0.0), 0.1, true, 0.05, 3,
			Color(0.003922, 0.286275, 0.286275), 3, 1
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 8},
			{"preset": "paworange", "dest": "three", "chance": 2},
			{"preset": "pawgrey", "dest": "four", "chance": 2},
			{"preset": "food", "dest": "point", "chance": 4},
			{"preset": "water", "dest": "point", "chance": 4},
			{"preset": "boot", "dest": "point", "chance": 4},
			{"preset": "collar", "dest": "unpoint", "chance": 4},
			{"preset": "syringe", "dest": "A", "chance": 1, "req": 3}
		]
	},
	"three": {
		"music": "three",
		"spawn_rate": 2,
		"max_spawned": 7,
		"shader": [
			0.4, 20.0, 2.0, 0.2, 1.0, 1.1, Vector2(1.0, 0.0), 0.06, true, 0.2, 6,
			0.1, 5.0, 2.0, 0.5, 1.0, 2.0, Vector2(-0.2, 1.0), 0.06, true, 0.05, 6,
			Color(0.105882, 0.003922, 0.392157), 4, 3
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 8},
			{"preset": "paw", "dest": "one", "chance": 1},
			{"preset": "pawspots", "dest": "two", "chance": 1},
			{"preset": "collar", "dest": "unpoint", "chance": 2},
			{"preset": "food", "dest": "point", "chance": 2},
			{"preset": "steak", "dest": "point", "chance": 2},
			{"preset": "tennis", "dest": "point", "chance": 2},
			{"preset": "sock", "dest": "point", "chance": 2},
			{"preset": "syringe", "dest": "A", "chance": 0, "req": 3},
			{"preset": "rope", "dest": "B", "chance": 3, "req": 1}
		]
	},
	"four": {
		"music": "four",
		"spawn_rate": 2,
		"max_spawned": 7,
		"shader": [
			0.075, 10.0, 2.0, 0.2, 1.0, 1.0, Vector2(0.0, 0.0), 0.08, true, 0.25, 1,
			0.075, 5.0, 2.0, 0.5, 0.0, 0.0, Vector2(-0.2, 0.4), 0.03, true, 0.1, 3,
			Color(0.254902, 0.133333, 0.133333), 1, 5
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 8},
			{"preset": "paw", "dest": "one", "chance": 1},
			{"preset": "pawspots", "dest": "two", "chance": 1},
			{"preset": "ham", "dest": "point", "chance": 2},
			{"preset": "steak", "dest": "point", "chance": 2},
			{"preset": "water", "dest": "point", "chance": 2},
			{"preset": "zzz", "dest": "M", "chance": 2, "req": 2}
		]
	},
	"B": {
		"music": "B1",
		"spawn_rate": 7,
		"max_spawned": 6,
		"shader": [
			0.2, 10.0, 2.0, 2.0, 0.3, 0.35, Vector2(0.0, 0.0), 0.08, true, 0.25, 6,
			0.075, 5.0, 2.0, 0.5, 1.0, 0.1, Vector2(-1.0, 0.4), 0.3, true, 0.1, 4,
			Color(0.294118, 0.780392, 0.345098), 4, 1
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 5},
			{"preset": "paworange", "dest": "three", "chance": 1},
			{"preset": "paw", "dest": "one", "chance": 1},
			{"preset": "rope", "dest": "point", "chance": 1},
			{"preset": "bone", "dest": "point", "chance": 1},
			{"preset": "flower", "dest": "point", "chance": 3},
			{"preset": "tennis", "dest": "point", "chance": 1},
			{"preset": "sock", "dest": "point", "chance": 1},
			{"preset": "collar", "dest": "unpoint", "chance": 2},
			{"preset": "cat1", "dest": "end", "ending": 0, "music": "B3", "chance": 1, "req": 2}
		]
	},
	"A": {
		"music": "A1",
		"spawn_rate": 6,
		"max_spawned": 7,
		"shader": [
			0.075, 10.0, 2.0, 0.0, 0.0, 0.0, Vector2(0.0, 0.0), 0.08, true, 0.2, 0,
			0.0, 10.0, 2.0, 0.2, 10.0, 2.0, Vector2(0.0, 0.0), 0.08, true, 0.1, 1,
			Color(0.623529, 0.482353, 0.623529), 0, 3
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 3},
			{"preset": "paworange", "dest": "three", "chance": 1},
			{"preset": "pawspots", "dest": "two", "chance": 1},
			{"preset": "food", "dest": "point", "chance": 4},
			{"preset": "water", "dest": "point", "chance": 4},
			{"preset": "syringe", "dest": "unpoint", "chance": 12},
			{"preset": "furball", "dest": "AA", "chance": 2, "req": 2}
		]
	},
	"AA": {
		"music": "A3",
		"spawn_rate": 15,
		"max_spawned": 18,
		"shader": [
			0.1, 50.0, 2.0, 0.0, 0.0, 0.0, Vector2(-1.0, -1.0), 0.08, true, 0.2, 4,
			0.075, 10.0, 2.0, 0.2, 10.0, 2.0, Vector2(0.0, 0.0), 0.08, true, 0.1, 1,
			Color(0.623529, 0.482353, 0.623529), 0, 3
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 5},
			{"preset": "syringe", "dest": "unpoint", "chance": 8},
			{"preset": "collar", "dest": "unpoint", "chance": 6},
			{"preset": "sock", "dest": "point", "chance": 5},
			{"preset": "tennis", "dest": "point", "chance": 4},
			{"preset": "food", "dest": "point", "chance": 1},
			{"preset": "water", "dest": "point", "chance": 1},
			{"preset": "furball", "dest": "point", "chance": 1},
			{"preset": "cat2", "dest": "end", "ending": 1, "music": "A5", "chance": 1, "req": 5}
		]
	},
	"M": {
		"music": "My1",
		"spawn_rate": 3,
		"max_spawned": 6,
		"shader": [
			0.1, 0.1, 2.0, 0.0, 0.0, 0.0, Vector2(0.0, 0.0), 0.08, true, 0.1, 2,
			0.5, 1.0, 1.0, 1.0, 3.3, 0.2, Vector2(1.0, 3.0), 0.05, true, 0.3, 3,
			Color(0.1, 0.0, 0.1), 2, 5
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 2},
			{"preset": "paw", "dest": "one", "chance": 1},
			{"preset": "pawgrey", "dest": "four", "chance": 1},
			{"preset": "steak", "dest": "point", "chance": 4},
			{"preset": "boot", "dest": "point", "chance": 2},
			{"preset": "bone", "dest": "point", "chance": 2},
			{"preset": "zzz", "dest": "MM", "chance": 2, "req": 2},
		]
	},
	"MM": {
		"music": "My2",
		"spawn_rate": 2,
		"max_spawned": 6,
		"shader": [
			0.1, 0.1, 2.0, 0.0, 0.0, 0.0, Vector2(0.0, 0.0), 0.08, true, 0.2, 2,
			1.0, 0.5, 1.0, 0.8, 1.5, 1.0, Vector2(1.0, -1.0), 0.05, true, 0.3, 3,
			Color(0.1, 0.0, 0.1), 5, 2
		],
		"cats": [
			{"preset": "bat", "dest": "void", "chance": 0, "req": 4},
			{"preset": "ham", "dest": "point", "chance": 2},
			{"preset": "zzz", "dest": "point", "chance": 3},
			{"preset": "sock", "dest": "point", "chance": 1},
			{"preset": "bone", "dest": "point", "chance": 1},
			{"preset": "cat3", "dest": "end", "ending": 2, "music": "My3", "chance": 1, "req": 2}
		]
	},
	"void": {
		"music": "pre_buzz",
		"spawn_rate": 5,
		"max_spawned": 7,
		"shader": [
			1.5, 10.0, 10.0, 0.3, 0.3, 0.3, Vector2(1.0, 0.0), 1.0, true, 0.6, 1,
			0.075, 20.0, 2.0, 1.0, 1.0, 3.0, Vector2(0.0, 0.0), 0.08, true, 0.2, 5,
			Color(0.1, 0.0, 0.1), 4, 0
		],
		"cats": [
			{"preset": "hydrant", "dest": "final", "chance": 1, "req": 1},
			{"preset": "moon", "dest": "point", "chance": 1},
			{"preset": "cat4", "dest": "end", "ending": 3, "music": "buzz_end", "chance": 1},
			{"preset": "bat", "dest": "unpoint", "chance": 5},
			{"preset": "collar", "dest": "unpoint", "chance": 3},
			{"preset": "door", "dest": "unpoint", "chance": 1}
		]
	},
	"final": {
		"music": "pre_final",
		"spawn_rate": 2,
		"max_spawned": 7,
		"shader": [
			0.075, 10.0, 2.0, 0.0, 0.0, 0.0, Vector2(0.0, 0.0), 0.08, true, 0.25, 4,
			1.0, 10.0, 2.0, 1.0, 1.0, 1.0, Vector2(0.0, 0.0), 0.12, true, 0.1, 4,
			Color(0.572549, 0.984314, 0.964706), 4, 3
		],
		"cats": [
			{"preset": "bone", "dest": "point", "chance": 1},
			{"preset": "ham", "dest": "point", "chance": 1},
			{"preset": "steak", "dest": "point", "chance": 1},
			{"preset": "hydrant", "dest": "finalfinal", "chance": 0, "req": 5}
		]
	},
	"finalfinal": {
		"music": "final2",
		"spawn_rate": 10,
		"max_spawned": 30,
		"shader": [
			0.075, 10.0, 2.0, 3.0, 0.3, 0.3, Vector2(0.0, 0.0), 0.08, true, 0.1, 4,
			0.2, 10.0, 2.0, 0.0, 0.0, 0.0, Vector2(-1.0, -1.0), 0.1, true, 0.1, 6,
			Color(0.572549, 0.984314, 0.964706), 4, 3
		],
		"cats": [
			{"preset": "bone", "dest": "point", "chance": 2},
			{"preset": "food", "dest": "point", "chance": 2},
			{"preset": "water", "dest": "point", "chance": 2},
			{"preset": "hydrant", "dest": "point", "chance": 2},
			{"preset": "ham", "dest": "point", "chance": 2},
			{"preset": "steak", "dest": "point", "chance": 2},
			{"preset": "tennis", "dest": "point", "chance": 2},
			{"preset": "boot", "dest": "point", "chance": 2},
			{"preset": "sock", "dest": "point", "chance": 2},
			{"preset": "rope", "dest": "point", "chance": 2},
			{"preset": "zzz", "dest": "point", "chance": 2},
			{"preset": "cat5", "dest": "end", "ending": 4, "music": "final1", "chance": 0, "req": 10}
		]
	}
}

var Cat = preload("res://scenes/game/Cat.tscn")

const MOUSE_FORCE = 1

var first = true
var firstp = true

var spawn_rate = 1.0
var max_spawned = 0
var cats = []
var spawn_t = 0.0

var click_t = 10.0

var title_t = 1.5

var sfx_list = []
var sfx_t = 0.0
var sfx_on = null

var transitioning = false
var transition_t = 0.0
var old_bg = null
var new_bg = null

var bg_pos = Vector2(0,0)

var velocity = Vector2()

func note_from_dict(d):
	var n = Note.new()
	n.start = d["start"]
	n.duration = d["duration"]
	n.pitch = d["pitch"]
	n.velocity = d["velocity"]
	n.isCC = d["isCC"]
	return n

class Note:
	var start : float
	var duration : float = 0
	var pitch : int
	var velocity : int
	var isCC : bool = false
	var channel : int
	
	func get_start():
		return start
	
	func get_duration():
		return duration

func _ready():
	randomize()
	$Synths/FMASynth.set_bus("Env1", 1)
	$Synths/FMASynth2.set_bus("Env2", 2)
	$Synths/FMASynth3.set_bus("Env3", 3)
	$Synths/FMASynth4.set_bus("Env4", 4)
	$Synths/FMASynth5.set_bus("Env5", 5)
	$Synths/FMASynth5.register_with_view($InstView)
	
	Global.dog = $Dog
	
	var read = File.new()
	if read.file_exists("res://music.json"):
		read.open("res://music.json", File.READ)
		var d = parse_json(read.get_as_text())
		Global.presets = d["presets"]
		var s_tracks = d["tracks"]
		Global.tracks = s_tracks.duplicate(true)
		for k in s_tracks.keys():
			var d_notes = []
			for n in s_tracks[k]["notes"]:
				d_notes.append(note_from_dict(n))
			Global.tracks[k]["notes"] = d_notes
		Global.nodes = d["nodes"]
		read.close()
	
	$InstView.select_preset("bell_sfx")
	
	transition("main")

func _get_inst(id):
	return $Synths.get_child(id)

func _on_GraphPlayer_note_off(channel, pitch):
	_get_inst(channel).note_off(pitch)

func _on_GraphPlayer_note_on(channel, pitch, velocity):
	_get_inst(channel).note_on(pitch, velocity / 127.0)

func _on_GraphPlayer_cc(channel, controller, value):
	_get_inst(channel).register_with_view($InstView)
	$InstView.select_knob_bank((controller - 48) / 4)
	$InstView.update_value(controller % 4, value / 127.0)

func _on_GraphPlayer_change_preset(presets):
	for i in range(len(presets)):
		_get_inst(i).register_with_view($InstView)
		$InstView.select_preset(presets[i])

func play_sfx(id):
	if id == 0:
		sfx_list += [91, 95, 98, 102]
	elif id == 1:
		sfx_list += [79, 82, 86]
	else:
		sfx_list += [102, 103, 105, 107]
	sfx_list.shuffle()
	sfx_t = 0.0
	sfx_on = null

func transition(target):
	for c in $Cats.get_children():
		c.despawn()
	spawn_rate = MAP[target].spawn_rate
	max_spawned = MAP[target].max_spawned
	cats = MAP[target].cats
	$GraphPlayer.goto(MAP[target].music)
	transitioning = true
	transition_t = 0.0
	if new_bg:
		old_bg = new_bg
	else:
		old_bg = MAP[target].shader
	new_bg = MAP[target].shader

func collect_ending(ending, music):
	$GraphPlayer.goto(music)
	for c in $Cats.get_children():
		c.despawn()
	title_t = 4.0
	$Title.set_show(true)
	Global.endings[ending] = true
	$Title.update_endings()
	Global.save()

func _input(event):
	if title_t <= 0:
		if click_t > 0.2 and event is InputEventMouseButton and event.pressed:
			click_t = 0.0
			velocity += $Dog.push_from(event.position, MOUSE_FORCE) * -0.005
			$Dog.spin()
			if $Title.showing:
				for c in $Cats.get_children():
					c.despawn(true)
				$Title.set_show(false)
				if not first:
					transition("main")
				first = false
				$Dog.set_emote(2)

func _physics_process(delta):
	click_t += delta
	if len(sfx_list) > 0 or sfx_on:
		sfx_t -= delta * 32
		if sfx_t <= 0:
			if sfx_on:
				_get_inst(4).note_off(sfx_on)
				sfx_on = null
			else:
				sfx_on = sfx_list.pop_front()
				_get_inst(4).note_on(sfx_on, 0.5)
			sfx_t = 1.0
	if title_t > 0:
		title_t -= delta
	elif not $Title.showing:
		velocity /= 1.01
		bg_pos -= velocity
		$Background/BGA.material.set_shader_param("offset", bg_pos / 600.0)
		$Background/BGB.material.set_shader_param("offset", bg_pos / 600.0)
		for c in $Cats.get_children():
			c.position += velocity
		spawn_t += delta * spawn_rate
		if spawn_t >= 1.0:
			spawn_t = randf() / 2.0
			if len(cats) > 0 and $Cats.get_child_count() < max_spawned:
				var cat = Cat.instance()
				var choices = []
				for c in cats:
					var ch = c.chance
					if c.has("req"):
						if $Dog.point or c.preset == "bat":
							ch += int((float(Global.points) / float(c.req)))
						else:
							ch = 0
					for i in range(ch):
						choices.append(c)
				choices.shuffle()
				cat.initialize(choices[0])
				cat.connect("transition", self, "transition")
				cat.connect("collect_ending", self, "collect_ending")
				cat.connect("sfx", self, "play_sfx")
				$Cats.add_child(cat)
	if transitioning:
		transition_t += delta * 0.25
		$Background/BGA.material.set_shader_param("amplitude", lerp(old_bg[0], new_bg[0], transition_t))
		$Background/BGA.material.set_shader_param("frequency", lerp(old_bg[1], new_bg[1], transition_t))
		$Background/BGA.material.set_shader_param("speed", lerp(old_bg[2], new_bg[2], transition_t))
		$Background/BGA.material.set_shader_param("amplitude_vertical", lerp(old_bg[3], new_bg[3], transition_t))
		$Background/BGA.material.set_shader_param("frequency_vertical", lerp(old_bg[4], new_bg[4], transition_t))
		$Background/BGA.material.set_shader_param("speed_vertical", lerp(old_bg[5], new_bg[5], transition_t))
		$Background/BGA.material.set_shader_param("scroll_direction", lerp(old_bg[6], new_bg[6], transition_t))
		$Background/BGA.material.set_shader_param("scrolling_speed", lerp(old_bg[7], new_bg[7], transition_t))
		
		$Background/BGB.material.set_shader_param("amplitude", lerp(old_bg[11], new_bg[11], transition_t))
		$Background/BGB.material.set_shader_param("frequency", lerp(old_bg[12], new_bg[12], transition_t))
		$Background/BGB.material.set_shader_param("speed", lerp(old_bg[13], new_bg[13], transition_t))
		$Background/BGB.material.set_shader_param("amplitude_vertical", lerp(old_bg[14], new_bg[14], transition_t))
		$Background/BGB.material.set_shader_param("frequency_vertical", lerp(old_bg[15], new_bg[15], transition_t))
		$Background/BGB.material.set_shader_param("speed_vertical", lerp(old_bg[16], new_bg[16], transition_t))
		$Background/BGB.material.set_shader_param("scroll_direction", lerp(old_bg[17], new_bg[17], transition_t))
		$Background/BGB.material.set_shader_param("scrolling_speed", lerp(old_bg[18], new_bg[18], transition_t))
		
		$Background/BGA.modulate.a = lerp(0, 1, abs(transition_t * 2 - 1))
		$Background/BGB.modulate.a = lerp(0, 1, abs(transition_t * 2 - 1))
		if firstp:
			$Background/ColorRect.color = lerp(Color(0.003922, 0.015686, 0.164706), new_bg[22], transition_t)
		else:
			$Background/ColorRect.color = lerp(old_bg[22], new_bg[22], transition_t)
		if transition_t > 0.5:
			$Background/BGA.texture = BGS[new_bg[23]]
			$Background/BGB.texture = BGS[new_bg[24]]
			$Background/BGA.material.set_shader_param("enable_palette_cycling", new_bg[8])
			$Background/BGA.material.set_shader_param("palette", PS[new_bg[10]])
			$Background/BGB.material.set_shader_param("enable_palette_cycling", new_bg[19])
			$Background/BGB.material.set_shader_param("palette", PS[new_bg[21]])
			$Background/BGA.material.set_shader_param("palette_speed", new_bg[9])
			$Background/BGB.material.set_shader_param("palette_speed", new_bg[20])
		if transition_t >= 1.0:
			firstp = false
			transitioning = false
