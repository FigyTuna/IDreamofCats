extends Control

var channel

var current_bank = 0

var preset = ""
var preset_keys = []

onready var presetSelect = $PanelContainer/HBoxContainer/VBoxContainer/OptionButton
onready var presetNamer = $PanelContainer/HBoxContainer/VBoxContainer/LineEdit

func _get_knob(id):
	var section = floor(id / 4)
	var knob = id % 4
	return get_node("PanelContainer/HBoxContainer/GridContainer/Panel" + str(section) + "/GridContainer/Knob" + str(knob))

func register_param(inst, knob_id, label, param, value):
	var knob = _get_knob(knob_id)
	knob.init_knob(inst, param, value, label)
	#knob.set_label(label)
	#knob.update_value(value)
	#knob.connect("value_updated", inst, "set_param", [param])

func update_value(knob, value):
	_get_knob(current_bank * 4 + knob).update_value(value)

func select_knob_bank(bank_id):
	current_bank = bank_id

func _update_preset_options(sel = null):
	presetSelect.clear()
	preset_keys = Global.presets.keys()
	for k in preset_keys:
		presetSelect.add_item(k)
	if sel:
		presetSelect.select(preset_keys.find(sel))

func _on_SaveButton_pressed():
	var params = []
	for i in range(4 * 8):
		params.append(_get_knob(i).value)
		print(str(i) + " " + str(_get_knob(i).value))
	var s = presetNamer.text
	Global.presets[s] = params
	preset = s
	_update_preset_options(preset)

func select_preset(p):
	preset = p
	$PanelContainer/HBoxContainer/VBoxContainer/LineEdit.text = preset
	for i in range(4 * 8):
		#print(str(i) + " " + str(Global.presets[preset][i]))
		_get_knob(i).update_value(Global.presets[preset][i])

func _on_OptionButton_item_selected(index):
	preset = preset_keys[index]
	select_preset(preset)

func _on_DeleteButton_pressed():
	Global.presets.erase(preset)
	_update_preset_options()
	$PanelContainer/HBoxContainer/VBoxContainer/LineEdit.text = ""

func get_preset_name():
	return $PanelContainer/HBoxContainer/VBoxContainer/OptionButton.text
