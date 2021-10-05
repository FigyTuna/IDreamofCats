extends Control

var current_inst = 0

var beat_pos = 0.0

var bpm = 120
var num_beats = 8

var queue_record = false
var beat_no = 0

var node_ks = []

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	$Synths/FMASynth.register_with_view($InstView)
	$Synths/FMASynth.set_bus("Env1", 1)
	$Synths/FMASynth2.set_bus("Env2", 2)
	$Synths/FMASynth3.set_bus("Env3", 3)
	$Synths/FMASynth4.set_bus("Env4", 4)
	$Synths/FMASynth5.set_bus("Env5", 5)
	
	var read = File.new()
	if read.file_exists("user://music.json"):
		read.open("user://music.json", File.READ)
		var d = parse_json(read.get_as_text())
		Global.presets = d["presets"]
		var s_tracks = d["tracks"]
		Global.tracks = s_tracks.duplicate(true)
		for k in s_tracks.keys():
			var d_notes = []
			for n in s_tracks[k]["notes"]:
				d_notes.append($Recorder.note_from_dict(n))
			Global.tracks[k]["notes"] = d_notes
		for k in d["nodes"].keys():
			$NodesList.text += k + "\n"
		for k in d["tracks"].keys():
			$TracksList.text += k + "\n"
		Global.nodes = d["nodes"]
		$InstView._update_preset_options()
		_update_node_names()
		read.close()

func _process(delta):
	beat_pos += delta * (bpm / 60)
	if beat_pos >= 0.1:
		$ColorRect.color = Color.black
	if beat_pos >= 1.0:
		if $Recorder.recording:
			beat_no += 1
			if beat_no >= num_beats:
				$Label3.text = "Done"
				var notes = $Recorder.finish_recording()
				Global.tracks[$TrackName.text] = {
					"preset": $InstView.get_preset_name(),
					"notes": notes,
					"beats": num_beats
				}
				#$GraphPlayer.play(notes)
		if queue_record and not $GraphPlayer.playing:
			queue_record = false
			beat_no = 0
			$Label3.text = "Recording"
			$Recorder.start_recording()
		beat_pos = 0.0
		$ColorRect.color = Color.red

func _get_inst(id):
	return $Synths.get_child(id)

func _get_inst_count():
	return $Synths.get_child_count()

func _unhandled_input_(event):
	if (event is InputEventMIDI) and event.message < 200:
		print_event(event)

func print_event(event):
	print("===============================")
	print("channel:           " + str(event.channel))
	print("controller_number: " + str(event.controller_number))
	print("controller_value:  " + str(event.controller_value))
	print("instrument:        " + str(event.instrument))
	print("message:           " + str(event.message))
	print("pitch:             " + str(event.pitch))
	print("pressure:          " + str(event.pressure))
	print("velocity:          " + str(event.velocity))

func _unhandled_input(event):
	if (event is InputEventMIDI):
		match event.message:
			MIDI_MESSAGE_NOTE_ON:
				if event.channel == 8:
					match event.pitch:
						32:
							current_inst += 1
							if current_inst >= _get_inst_count():
								current_inst = _get_inst_count() - 1
							$Label2.text = str(current_inst)
							_get_inst(current_inst).register_with_view($InstView)
						33:
							if $TrackName.text == "":
								$Label3.text = "NO NAME"
							else:
								$Label3.text = "Queued"
								queue_record = true
						34:
							pass
						35:
							pass
						36:
							current_inst -= 1
							if current_inst < 0:
								current_inst = 0
							$Label2.text = str(current_inst)
							_get_inst(current_inst).register_with_view($InstView)
						37:
							pass
						38:
							pass
						39:
							pass
						_:
							$InstView.select_knob_bank((event.pitch - 12) % 8)
				else:
					if $Recorder.recording:
						$Recorder.record_midi(event)
					_get_inst(current_inst).note_on(event.pitch, event.velocity / 127.0)
			MIDI_MESSAGE_NOTE_OFF:
				if event.channel != 8:
					if $Recorder.recording:
						$Recorder.record_midi(event)
					_get_inst(current_inst).note_off(event.pitch)
			MIDI_MESSAGE_CONTROL_CHANGE:
				if $Recorder.recording:
					var b = $InstView.current_bank
					var temp = event.duplicate()
					temp.controller_number += 4 * b
					$Recorder.record_midi(temp)
				$InstView.update_value(event.controller_number - 48, event.controller_value / 127.0)

func _on_GraphPlayer_display_time(t):
	$Label.text = t

func _on_GraphPlayer_note_off(channel, pitch):
	_get_inst(channel).note_off(pitch)

func _on_GraphPlayer_note_on(channel, pitch, velocity):
	_get_inst(channel).note_on(pitch, velocity / 127.0)

func _on_GraphPlayer_cc(channel, controller, value):
	_get_inst(channel).register_with_view($InstView)
	$InstView.select_knob_bank((controller - 48) / 4)
	$InstView.update_value(controller % 4, value / 127.0)
	_get_inst(current_inst).register_with_view($InstView)

func _on_NumBeats_value_changed(value):
	num_beats = value

func _on_BPM_value_changed(value):
	bpm = value

func _on_WriteAll_pressed():
	var save = File.new()
	save.open("user://music.json", File.WRITE)
	var s_tracks = Global.tracks.duplicate(true)
	for k in Global.tracks.keys():
		var s_notes = []
		for n in Global.tracks[k]["notes"]:
			s_notes.append(n.to_dict())
		s_tracks[k]["notes"] = s_notes
	var data = {
		"presets": Global.presets,
		"tracks": s_tracks,
		"nodes": Global.nodes
	}
	save.store_line(to_json(data))
	save.close()

func _on_SaveNode_pressed():
	Global.nodes[$NodeName.text] = {
		"tracks": $Tracks.text.split("\n", false),
		"bpm": $NodeBPM.value,
		"defaults": $Defaults.text.split("\n", false),
		"alts": $Alts.text.split("\n", false)
	}
	print(Global.nodes)
	_update_node_names()

func _on_LoadNode_pressed():
	var n = Global.nodes[$NodeName.text]
	$Tracks.text = ""
	for t in n["tracks"]:
		$Tracks.text += t + "\n"
	$Defaults.text = ""
	for t in n["defaults"]:
		$Defaults.text += t + "\n"
	$Alts.text = ""
	for t in n["alts"]:
		$Alts.text += t + "\n"
	$NodeBPM.value = n["bpm"]

func _update_node_names():
	$Play.clear()
	node_ks = Global.nodes.keys()
	for k in node_ks:
		$Play.add_item(k)

func _on_Play_item_selected(index):
	$GraphPlayer.goto(node_ks[index])

func _on_Stop_pressed():
	$GraphPlayer.stop()
	for s in $Synths.get_children():
		s.reinit()

func _on_GraphPlayer_change_preset(presets):
	for i in range(len(presets)):
		_get_inst(i).register_with_view($InstView)
		$InstView.select_preset(presets[i])
	_get_inst(current_inst).register_with_view($InstView)

func _on_GraphPlayer_start_node(b):
	bpm = b
	$BPM.value = bpm
	beat_pos = 0.0
	if queue_record:
		queue_record = false
		beat_no = 0
		$Label3.text = "Recording"
		$Recorder.start_recording()
