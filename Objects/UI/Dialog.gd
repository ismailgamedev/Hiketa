extends Control

var birinci = 0
var ikinci = 0
var ucuncu = 0
var ikinciok = false

onready var name_text = get_node("Diyalog Panel/NameCont/nameText")
onready var Text = get_node("Diyalog Panel/TextCont/Text")
onready var dialog_panel = get_node("Diyalog Panel")

func _ready():
	name_text.modulate = Color.darkorange
	if get_tree().get_current_scene().get_name() == "Level1":
		dialog_panel.visible = true
	elif get_tree().get_current_scene().get_name() == "Level2":
		dialog_panel.visible = false
	elif get_tree().get_current_scene().get_name() == "Level4":
		dialog_panel.visible = true
		Text.text = "At ile devam edemem."
		name_text.text = "Hektor"

	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if get_tree().get_current_scene().get_name() == "Level1":
			birinci += 1
			if birinci == 1:
				Text.text = "Ailemin canini aldi bende onun \n canini alicam"
			elif birinci == 2:
				dialog_panel.visible = false
	if event is InputEventMouseButton and event.is_pressed():
		if get_tree().get_current_scene().get_name() == "Level2":
			if ikinciok == true:
				ikinci += 1
	
	if event is InputEventMouseButton and event.is_pressed():	
		if get_tree().get_current_scene().get_name() == "Level4":	
			ucuncu += 1
			if ucuncu == 1:
				dialog_panel.visible = false

func _process(delta):
		if ikinci >= 1:
			dialog_panel.visible = true
			Text.text = "Atla devam etmeliyim"	
		if ikinci >= 2:
			dialog_panel.visible = false

func _on_HourseArea_area_entered(area):
	ikinci += 1
	ikinciok = true
