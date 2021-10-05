extends Node

enum {
	FMA_VOL,
	FMA_VIBRATO,
	FMA_PARTIALS,
	FMA_PARTIALS_WOBBLE,
	FMA_BASE_WAVE_TYPE,
	FMA_PARTIALS_WAVE_TYPE,
	FMA_FM_RATIO,
	FMA_FM_AMP,
	FMA_GLIDE,
	FMA_ATTACK,
	FMA_DECAY,
	FMA_SUSTAIN,
	
	FMA_FILTER_CUTOFF,
	FMA_FILTER_RES,
	FMA_FILTER_ENV,
	
	FMA_DIST_MODE,
	FMA_DIST_PRE,
	FMA_DIST_DRIVE,
	FMA_DIST_POST,
	
	FMA_CHORUS_RATE
	FMA_CHORUS_DRYWET,
	
	FMA_PHASER_RATE,
	FMA_PHASER_DEPTH,
	
	FMA_DELAY_MS,
	FMA_DELAY_DRY,
	FMA_DELAY_FEEDBACK,
	FMA_DELAY_ACTIVE,
	
	FMA_REVERB_AMOUNT,
	FMA_REVERB_DAMPING,
	FMA_REVERB_SPREAD,
	FMA_REVERB_DRYWET
}

enum {
	EFFECT_FILTER,
	EFFECT_DIST,
	EFFECT_CHORUS,
	EFFECT_PHASER,
	EFFECT_DELAY,
	EFFECT_REVERB
}

var inst : FMASynthStream
var params = []
var bus_num

var filter_cutoff = 0
var env_filter_amt = 0

#var lfos

func _ready():
	inst = FMASynthStream.new()
	$AudioStreamPlayer.stream = inst
	$AudioStreamPlayer.play()
	params.resize(FMA_REVERB_DRYWET + 1) # Update this!
	for i in range(len(params)):
		params[i] = 0.0

func reinit():
	$AudioStreamPlayer.stop()
	print("reinit")
	inst = FMASynthStream.new()
	$AudioStreamPlayer.stream = inst
	$AudioStreamPlayer.play()
	for i in range(len(params)):
		set_param(params[i], i)

func _process(_delta):
	var a = inst.get_env()
	AudioServer.get_bus_effect(bus_num, EFFECT_FILTER).cutoff_hz = filter_cutoff + (a * env_filter_amt)

func set_bus(bus_string, bus_number):
	$AudioStreamPlayer.bus = bus_string
	bus_num = bus_number

func note_on(note, velocity):
	inst.note_on(note, velocity)

func note_off(note):
	inst.note_off(note)

func set_param(value, param):
	params[param] = value
	match param:
		FMA_FILTER_CUTOFF:
			AudioServer.set_bus_effect_enabled(bus_num, 0, value > 0)
			filter_cutoff = value * value * 6000
		FMA_FILTER_RES:
			AudioServer.get_bus_effect(bus_num, EFFECT_FILTER).resonance = value
		FMA_FILTER_ENV:
			env_filter_amt = value * value * 20000
		
		FMA_DIST_MODE:
			AudioServer.set_bus_effect_enabled(bus_num, 1, value > 0)
			AudioServer.get_bus_effect(bus_num, EFFECT_DIST).mode = floor(value * 3.9 + 1)
		FMA_DIST_PRE:
			AudioServer.get_bus_effect(bus_num, EFFECT_DIST).pre_gain = value * value * 30
		FMA_DIST_DRIVE:
			AudioServer.get_bus_effect(bus_num, EFFECT_DIST).drive = value
		FMA_DIST_POST:
			AudioServer.get_bus_effect(bus_num, EFFECT_DIST).post_gain = value * value * 60 - 50
			
		FMA_CHORUS_RATE:
			AudioServer.get_bus_effect(bus_num, EFFECT_CHORUS)["voice/1/rate_hz"] = value * value * 2.0
			AudioServer.get_bus_effect(bus_num, EFFECT_CHORUS)["voice/2/rate_hz"] = value * value * 3.0
		FMA_CHORUS_DRYWET:
			AudioServer.set_bus_effect_enabled(bus_num, 2, value > 0)
			AudioServer.get_bus_effect(bus_num, EFFECT_CHORUS).wet = value
			AudioServer.get_bus_effect(bus_num, EFFECT_CHORUS).dry = 1 - value
		
		FMA_PHASER_RATE:
			AudioServer.get_bus_effect(bus_num, EFFECT_PHASER).rate_hz = value * value * 2.0
		FMA_PHASER_DEPTH:
			AudioServer.set_bus_effect_enabled(bus_num, 3, value > 0)
			AudioServer.get_bus_effect(bus_num, EFFECT_PHASER).depth = value * 4.0
		
		FMA_DELAY_MS:
			AudioServer.get_bus_effect(bus_num, EFFECT_DELAY)["tap1/delay_ms"] = value * value * 800
			AudioServer.get_bus_effect(bus_num, EFFECT_DELAY)["tap2/delay_ms"] = value * value * 1200
		FMA_DELAY_DRY:
			AudioServer.get_bus_effect(bus_num, EFFECT_DELAY).dry = 1 - value
		FMA_DELAY_FEEDBACK:
			AudioServer.get_bus_effect(bus_num, EFFECT_DELAY)["feedback/active"] = value > 0
			AudioServer.get_bus_effect(bus_num, EFFECT_DELAY)["feedback/delay_ms"] = (1 - value * value) * 500
		FMA_DELAY_ACTIVE:
			AudioServer.set_bus_effect_enabled(bus_num, 4, value > 0)
		
		FMA_REVERB_AMOUNT:
			AudioServer.get_bus_effect(bus_num, EFFECT_REVERB).room_size = floor(value)
		FMA_REVERB_DAMPING:
			AudioServer.get_bus_effect(bus_num, EFFECT_REVERB).damping = value
		FMA_REVERB_SPREAD:
			AudioServer.get_bus_effect(bus_num, EFFECT_REVERB).spread = value
		FMA_REVERB_DRYWET:
			AudioServer.set_bus_effect_enabled(bus_num, 5, value > 0)
			AudioServer.get_bus_effect(bus_num, EFFECT_REVERB).wet = value
			AudioServer.get_bus_effect(bus_num, EFFECT_REVERB).dry = 1 - value
		
		FMA_BASE_WAVE_TYPE:
			inst.set_param(FMA_BASE_WAVE_TYPE, floor(value * 4.9))
		FMA_PARTIALS_WAVE_TYPE:
			inst.set_param(FMA_PARTIALS_WAVE_TYPE, floor(value * 4.9))
		
		_:
			inst.set_param(param, value)

func register_with_view(view):
	view.register_param(self, 0, "Volume", FMA_VOL, params[FMA_VOL])
	view.register_param(self, 1, "Vibrato", FMA_VIBRATO, params[FMA_VIBRATO])
	view.register_param(self, 2, "Base Wave", FMA_BASE_WAVE_TYPE, params[FMA_BASE_WAVE_TYPE])
	view.register_param(self, 3, "Part Wave", FMA_PARTIALS_WAVE_TYPE, params[FMA_PARTIALS_WAVE_TYPE])
	
	view.register_param(self, 4, "Partials", FMA_PARTIALS, params[FMA_PARTIALS])
	view.register_param(self, 5, "Wobble", FMA_PARTIALS_WOBBLE, params[FMA_PARTIALS_WOBBLE])
	view.register_param(self, 6, "Mod Ratio", FMA_FM_RATIO, params[FMA_FM_RATIO])
	view.register_param(self, 7, "Mod Amp", FMA_FM_AMP, params[FMA_FM_AMP])
	
	view.register_param(self, 8, "Glide", FMA_GLIDE, params[FMA_GLIDE])
	view.register_param(self, 9, "Attack", FMA_ATTACK, params[FMA_ATTACK])
	view.register_param(self, 10, "Decay", FMA_DECAY, params[FMA_DECAY])
	view.register_param(self, 11, "Sustain", FMA_SUSTAIN, params[FMA_SUSTAIN])
	
	view.register_param(self, 12, "Filter", FMA_FILTER_CUTOFF, params[FMA_FILTER_CUTOFF])
	view.register_param(self, 13, "Res", FMA_FILTER_RES, params[FMA_FILTER_RES])
	view.register_param(self, 14, "Filter Env", FMA_FILTER_ENV, params[FMA_FILTER_ENV])
	
	view.register_param(self, 16, "Dist Mode", FMA_DIST_MODE, params[FMA_DIST_MODE])
	view.register_param(self, 17, "Pre Gain", FMA_DIST_PRE, params[FMA_DIST_PRE])
	view.register_param(self, 18, "Drive", FMA_DIST_DRIVE, params[FMA_DIST_DRIVE])
	view.register_param(self, 19, "Post Gain", FMA_DIST_POST, params[FMA_DIST_POST])
	
	view.register_param(self, 20, "C Rate", FMA_CHORUS_RATE, params[FMA_CHORUS_RATE])
	view.register_param(self, 21, "P Rate", FMA_PHASER_RATE, params[FMA_PHASER_RATE])
	view.register_param(self, 22, "C Dry/Wet", FMA_CHORUS_DRYWET, params[FMA_CHORUS_DRYWET])
	view.register_param(self, 23, "P Depth", FMA_PHASER_DEPTH, params[FMA_PHASER_DEPTH])
	
	view.register_param(self, 24, "Delay ms", FMA_DELAY_MS, params[FMA_DELAY_MS])
	view.register_param(self, 25, "1 - Dry", FMA_DELAY_DRY, params[FMA_DELAY_DRY])
	view.register_param(self, 26, "Feedback", FMA_DELAY_FEEDBACK, params[FMA_DELAY_FEEDBACK])
	view.register_param(self, 27, "Active", FMA_DELAY_ACTIVE, params[FMA_DELAY_ACTIVE])
	
	view.register_param(self, 28, "Reverb", FMA_REVERB_AMOUNT, params[FMA_REVERB_AMOUNT])
	view.register_param(self, 29, "Damping", FMA_REVERB_DAMPING, params[FMA_REVERB_DAMPING])
	view.register_param(self, 30, "Spread", FMA_REVERB_SPREAD, params[FMA_REVERB_SPREAD])
	view.register_param(self, 31, "Dry/Wet", FMA_REVERB_DRYWET, params[FMA_REVERB_DRYWET])
