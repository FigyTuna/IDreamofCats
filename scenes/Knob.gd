extends Control

var value = 0.0
var inst = null
var param = null

#signal value_updated(value)

func init_knob(i, p, v, t):
	inst = i
	param = p
	value = v
	$VBoxContainer/ProgressBar.value = value * 100
	$VBoxContainer/Label.text = t

func update_value(v):
	value = v
	$VBoxContainer/ProgressBar.value = value * 100
	if inst:
		inst.set_param(value, param)
	#emit_signal("value_updated", value)
