extends Control

@onready var dialogue_panel: Control = $"Dialogue Box"
@onready var dialogue_text: Label = $"Dialogue Box/dialogueBackground/dialogueText"

@onready var choice_container: VBoxContainer = $"Choice Box/VBoxContainer"
@onready var choice_button_1: Button = $"Choice Box/VBoxContainer/Button"
@onready var choice_button_2: Button = $"Choice Box/VBoxContainer/Button2"
@onready var choice_button_3: Button = $"Choice Box/VBoxContainer/Button3"
@onready var choice_button_4: Button = $"Choice Box/VBoxContainer/Button4"


func _ready() -> void:
	dialogue_panel.visible = false
	DialogueManagerGlobal.connect("start_Dialogue", self.startDialogue)
	DialogueManagerGlobal.connect("next_dialogue", self.nextDialogue)
	DialogueManagerGlobal.connect("give_choice", self.choiceDialogue)
	DialogueManagerGlobal.connect("end_Dialogue", self.endDialogue)
	

func startDialogue():
	dialogue_panel.visible = true
	dialogue_text.text = DialogueManagerGlobal.currentText


func nextDialogue():
	dialogue_text.text = DialogueManagerGlobal.currentText

func choiceDialogue():
	var index = 0
	for x in DialogueManagerGlobal.currentChoices:
		
		if x != null and x != "":
			choice_container.get_child(index).text = x
			choice_container.get_child(index).visible = true
		index += 1

func endDialogue():
	dialogue_panel.visible = false
	for child in choice_container.get_children():
		child.visible = false
	pass


func _on_choice1() -> void:
	DialogueManagerGlobal.DialogueChoice(0)
	closeChoiceWindow()
func _on_choice2() -> void:
	DialogueManagerGlobal.DialogueChoice(1)
	closeChoiceWindow()
func _on_choice3() -> void:
	DialogueManagerGlobal.DialogueChoice(2)
	closeChoiceWindow()
func _on_choice4() -> void:
	DialogueManagerGlobal.DialogueChoice(3)
	closeChoiceWindow()

func closeChoiceWindow():
	for child in choice_container.get_children():
		child.visible = false
