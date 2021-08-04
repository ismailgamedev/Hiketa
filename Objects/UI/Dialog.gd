extends Control

var birinci = 0
var ikinci = 0

onready var name_text = get_node("Diyalog Panel/NameCont/nameText")
onready var Text = get_node("Diyalog Panel/TextCont/Text")
onready var dialog_panel = get_node("Diyalog Panel")

func _ready():
	name_text.modulate = Color.darkorange
	if get_tree().get_current_scene().get_name() == "Level1":
		dialog_panel.visible = true
	elif get_tree().get_current_scene().get_name() == "Level2":
		dialog_panel.visible = false

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_tree().get_current_scene().get_name() == "Level1":
			birinci += 1

	if get_tree().get_current_scene().get_name() == "Level1":	
		if birinci == 1:
			Text.text = "Ailemin canini aldi bende onun \n canini alicam"
		elif birinci == 2:
			dialog_panel.visible = false
		

func _process(delta):
		if ikinci >= 1:
			dialog_panel.visible = true
			Text.text = "Atla devam etmeliyim"	


func _on_HourseArea_area_entered(area):
	ikinci += 1
