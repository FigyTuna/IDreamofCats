extends Node

const TONE_NAMES = [
	["C", "C"],
	["C#", "Db"],
	["D", "D"],
	["D#", "Eb"],
	["E", "E"],
	["F", "F"],
	["F#", "Gb"],
	["G", "G"],
	["G#", "Ab"],
	["A", "A"],
	["A#", "Bb"],
	["B", "B"]
]
enum NamesDisplay {SHARPS, FLATS}

class InputNote:
	var event : InputEventMIDI
	var t : float

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
	var channel : int # used in GraphPlayer as a temp value
	
	func to_dict():
		return {
			"start": start,
			"duration": duration,
			"pitch": pitch,
			"velocity": velocity,
			"isCC": isCC
		}
	
	func get_start():
		return start
	
	func get_duration():
		return duration
	
#	func get_start():
#		if quant > 0:
#			return floor(start) + stepify(start - floor(start), 1.0 / quant)
#		else:
#			return start
#
#	func get_duration():
#		if quant > 0:
#			return floor(duration) + stepify(duration - floor(duration), 1.0 / quant)
#		else:
#			return start
	
	func to_string():
		var s = "Note: " + TONE_NAMES[pitch % 12][0]
		s += ", Velocity: " + str(velocity)
		s += ", Start: " + str(start)
		s += ", (Start): " + str(get_start())
		s += ", Duration: " + str(duration)
		s += ", (Duration): " + str(get_duration())
		s += "\n"
		return s

class CC:
	var time
	var control
	var val

var record_t = 0.0
var record_events
var recording = false

func start_recording(start = 0.0):
	record_t = start
	record_events = []
	recording = true

func _physics_process(delta):
	if recording:
		record_t += delta

func record_midi(event : InputEventMIDI):
	if recording:
		var ni = InputNote.new()
		ni.event = event
		ni.t = record_t
		record_events.append(ni)

func _find_note_with_pitch(pitch, half_notes):
	for n in half_notes:
		if n.pitch == pitch:
			return n
	return null

func finish_recording():
	recording = false
	var half_notes = []
	var notes = []
	for ni in record_events:
		match ni.event.message:
			MIDI_MESSAGE_NOTE_ON:
				if not _find_note_with_pitch(ni.event.pitch, half_notes):
					var n = Note.new()
					n.start = ni.t / record_t
					n.pitch = ni.event.pitch
					n.velocity = ni.event.velocity
					half_notes.append(n)
			MIDI_MESSAGE_NOTE_OFF:
				var n = _find_note_with_pitch(ni.event.pitch, half_notes)
				if n:
					half_notes.erase(n)
					n.duration = (ni.t / record_t) - n.start
					notes.append(n)
			MIDI_MESSAGE_CONTROL_CHANGE:
				var n = Note.new()
				n.isCC = true
				n.start = ni.t / record_t
				n.pitch = ni.event.controller_number
				n.velocity = ni.event.controller_value
				notes.append(n)
	for hn in half_notes:
		hn.duration = 1.0 - hn.start
		notes.append(hn)
	return notes
