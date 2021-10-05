extends Node

class OutputNote:
	var on : bool
	var pitch : int
	var velocity : int
	var isCC : bool
	var channel : int
	var time : float
	
	func to_string():
		var s = "Pitch: " + str(pitch)
		s += ", Velocity: " + str(velocity)
		s += ", On: " + str(on)
		s += ", time: " + str(time)
		s += "\n"
		return s

var current_node = null
var playing = false
var time = 0.0
var num_beats = 0
var notes = []
var bpm = 120
var path = []

signal display_time(t)
signal cc(channel, controller, value)
signal note_on(channel, pitch, velocity)
signal note_off(channel, pitch)
signal change_preset(presets)
signal start_node(bpm)

func goto(target):
	if playing:
		path = find_shortest_path(current_node, target)
		if path == null:
			path = []
			play(target)
	else:
		play(target)

func play(target):
	stop()
	playing = true
	current_node = target
	var node = Global.nodes[target]
	var tracks = []
	num_beats = -1
	var normal_notes = []
	var presets = []
	var channel = 0
	for tn in node.tracks:
		var t = Global.tracks[tn]
		tracks.append(t)
		if t.beats > num_beats:
			num_beats = t.beats
		var notes_with_ch = t.notes.duplicate()
		for i in range(len(notes_with_ch)):
			notes_with_ch[i]["channel"] = channel
		normal_notes += t.notes.duplicate()
		presets.append(t.preset)
		channel += 1
	emit_signal("change_preset", presets)
	bpm = node.bpm
	notes = convert_to_output(normal_notes, num_beats)
	time = 0.0
	emit_signal("start_node", bpm)

func stop():
	for n in notes:
		if not n.on:
			#print("Off " + str(n.pitch))
			emit_signal("note_off", n.channel, n.pitch)
	notes = []
	playing = false

func _process(delta):
	if playing:
		time += delta * (bpm / 60.0)
		emit_signal("display_time", str(stepify(time, 0.01)))
	while playing and len(notes) > 0 and time >= notes[0].time:
		var n = notes.pop_front()
		if n.isCC:
			emit_signal("cc", n.channel, n.pitch, n.velocity)
		elif n.on:
			#print("On " + str(n.pitch))
			emit_signal("note_on", n.channel, n.pitch, n.velocity)
		else:
			#print("Off " + str(n.pitch))
			emit_signal("note_off", n.channel, n.pitch)
	if playing and time >= num_beats:
		if len(path) > 0:
			var next = path.pop_front()
			play(next)
		else:
			play(Global.nodes[current_node]["defaults"][0])

func convert_to_output(ns, nb):
	var out_notes = []
	var last_t = 0.0
	var last_cc = 0.0
	for n in ns:
		if n.isCC:
			if n.get_start() > last_cc:
				var n_cc = OutputNote.new()
				n_cc.isCC = true
				n_cc.on = false
				n_cc.pitch = n.pitch
				n_cc.velocity = n.velocity
				n_cc.channel = n.channel
				n_cc.time = n.get_start() * nb
				out_notes.append(n_cc)
				last_cc = n.get_start()
		else:
			var n_on = OutputNote.new()
			var n_off = OutputNote.new()
			n_on.on = true
			n_off.on = false
			n_on.pitch = n.pitch
			n_off.pitch = n.pitch
			n_on.velocity = n.velocity
			n_on.channel = n.channel
			n_off.channel = n.channel
			n_on.time = n.get_start() * nb
			n_off.time = (n.get_start() + n.get_duration()) * nb
			out_notes.append(n_on)
			out_notes.append(n_off)
	out_notes.sort_custom(self, "_sort_notes")
	return out_notes

func find_shortest_path(block, target):
	var paths = {block: []}
	var current = [block]
	var next = []
	while not paths.has(target):
		if len(current) <= 0:
			print("Error: No path from " + block + " to " + target + " exists.")
			return null
		for n in current:
			var b = Global.nodes[n]
			#print(b)
			#print(b["defaults"])
			for p in (b["defaults"] + b["alts"]):
				var newp = paths[n].duplicate()
				newp.append(p)
				if paths.has(p):
					var oldp = paths[p]
					# Assume |newp| < |oldp| not possible
					if len(newp) == len(oldp):
						paths[p] = newp
				else:
					paths[p] = newp
					next.append(p)
		current = next
		next = []
	#print(paths)
	return paths[target]

static func _sort_notes(a, b):
	if a.time == b.time:
		return b.on
	return a.time < b.time
