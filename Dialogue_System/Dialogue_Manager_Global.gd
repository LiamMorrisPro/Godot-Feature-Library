extends Node

var json_file_path = "res://Dialogue_System/Dialogue_Data.json"

signal start_Dialogue()
signal end_Dialogue()
signal next_dialogue()
signal give_choice()

var dialogueData = {}

var currentText : String
var currentChoices : Array[String] = ["", "", "", ""]

var currentlyInDialogue : bool = false
var canStartDialogue : bool = true
var canContinue : bool = false
var inChoice : bool = false



func _ready() -> void:
	dialogueData = load_json_file(json_file_path)

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
			var dataFile = FileAccess.open(filePath, FileAccess.READ)
			var parsedResult = JSON.parse_string(dataFile.get_as_text())
			
			if parsedResult is Dictionary:
				return parsedResult
			else:
				print("error reading file")
	else:
		print("dialogue file not found")


var textKey = 0		#text key will cycle the dialogue boxes
var dia_Key = ""	#dia_key will make sure we read from the correct dictionary

func DialogueStart(dialogueKey : String):
	
	if currentlyInDialogue == true || canStartDialogue == false:
		return

	currentlyInDialogue = true
	canStartDialogue = false
	dia_Key = dialogueKey
	
	#set current text
	currentText = dialogueData[dialogueKey]["text" + str(textKey)]
	textKey += 1
	#check if there is other text or choices
	if dialogueData[dialogueKey].has("text" + str(textKey)):
		canContinue = true

	elif dialogueData[dia_Key].has("choice"):
		inChoice = true
		for x in range(0,3):
			if dialogueData[dia_Key]["choice"].has(str(x)):
				currentChoices.set(x, dialogueData[dia_Key]["choice"][str(x)].get("choice_text"))
		
		give_choice.emit()
	else:
		canContinue = false
	
	print("Debugging so hard right now")
	#display
	start_Dialogue.emit()


func DialogueNext():
	#set current text
	currentText = dialogueData[dia_Key]["text" + str(textKey)]
	textKey += 1
	
	#check if there is other text or choices
	if dialogueData[dia_Key].has("text" + str(textKey)):
		canContinue = true
		
	elif dialogueData[dia_Key].has("choice"):
		inChoice = true
		for x in range(0,3):
			if dialogueData[dia_Key]["choice"].has(str(x)):
				currentChoices.set(x, dialogueData[dia_Key]["choice"][str(x)].get("choice_text"))
		
		give_choice.emit()
	else:
		canContinue = false
	
	next_dialogue.emit()


func DialogueChoice(index : int):
	#if the choice leads to a branch in the dialogue tree swap the dia_key and reset the textKey
	if dialogueData.has(dialogueData[dia_Key]["choice"][str(index)].get("output")):
		dia_Key = dialogueData[dia_Key]["choice"][str(index)].get("output")
		textKey = 0
		inChoice = false
		DialogueNext()
	#if the choice doesn't lead to a branch, print the output directly and mark the end of the dialogue
	else:
		currentText = dialogueData[dia_Key]["choice"][str(index)].get("output")
		next_dialogue.emit()
		inChoice = false
		canContinue = false





func DialogueEnd():
	end_Dialogue.emit()
	currentlyInDialogue = false
	textKey = 0
	dia_Key = ""
	get_tree().create_timer(1).timeout.connect(func(): canStartDialogue = true)
	

func _unhandled_input(event: InputEvent) -> void:
	if currentlyInDialogue:
		if Input.is_action_just_pressed("interact") and canContinue and !inChoice:
			DialogueNext()
		elif Input.is_action_just_pressed("interact") and !canContinue and !inChoice:
			DialogueEnd()
