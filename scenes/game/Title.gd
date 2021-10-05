extends Node2D

var showing = true

func _ready():
	var read = File.new()
	if read.file_exists("user://save.json"):
		read.open("user://save.json", File.READ)
		var d = parse_json(read.get_as_text())
		read.close()
		Global.endings = d["endings"]
		update_endings()

func update_endings():
	var count = 0
	for i in range(5):
		if Global.endings[i]:
			get_node("TitleStuff/Ending" + str(i + 1)).visible = true
			count += 1
	$TitleStuff/one.visible = false
	$TitleStuff/two.visible = false
	$TitleStuff/three.visible = false
	$TitleStuff/four.visible = false
	$TitleStuff/all.visible = false
	if count == 1:
		$TitleStuff/one.visible = true
	elif count == 2:
		$TitleStuff/two.visible = true
	elif count == 3:
		$TitleStuff/three.visible = true
	elif count == 4:
		$TitleStuff/four.visible = true
	elif count == 5:
		$TitleStuff/all.visible = true
	if count > 0:
		$Button.visible = true

func set_show(t):
	if showing and not t:
		showing = false
		$AnimationPlayer.play_backwards("show")
	elif not showing and t:
		showing = true
		$AnimationPlayer.play("show")

func _on_Button_pressed():
	Global.endings = [false,false,false,false,false]
	Global.save()
	$Button.visible = false
	$TitleStuff/Ending1.visible = false
	$TitleStuff/Ending2.visible = false
	$TitleStuff/Ending3.visible = false
	$TitleStuff/Ending4.visible = false
	$TitleStuff/Ending5.visible = false
	$TitleStuff/one.visible = false
	$TitleStuff/two.visible = false
	$TitleStuff/three.visible = false
	$TitleStuff/four.visible = false
	$TitleStuff/all.visible = false
