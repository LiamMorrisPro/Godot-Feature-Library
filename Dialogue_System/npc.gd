extends CharacterBody3D
class_name NPC

#Dialogue key should always be a triple digit number followed by the character name
#ex. 001_Liam
@export var DialogueKey : String

func interact():
	if DialogueKey != null and DialogueKey != "":
		DialogueManagerGlobal.DialogueStart(DialogueKey)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interact()
