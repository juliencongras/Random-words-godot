extends Node2D

var json_file = "res://words_dictionnary.json"
var json_as_text = FileAccess.get_file_as_string(json_file)
var json_as_dict = JSON.parse_string(json_as_text)

@onready var word_added = $"Add word/Word added"
@onready var button_message = $"Add word/Button Message"
@onready var wordlist = $Wordlist
@onready var word_option_list = $"Word interactor/Word option list"
@onready var file_dialog = $FileDialog

func _ready():
	for letter in json_as_dict.word_list:
		if json_as_dict.word_list[letter].size() == 0:
			pass
		else:
			for word in json_as_dict.word_list[letter]:
				word_option_list.add_item(word)

#add a word to the JSON list of words
func _on_add_word_button_pressed():
	#take the inputted word and put it in lowercase
	word_added.text = word_added.text.to_lower()
	for letter in json_as_dict.word_list:
		#Check to see where to put the word (which letter)
		if word_added.text[0].to_upper() == letter:
			var word_exists : bool = false
			for word in json_as_dict.word_list[letter]:
				if word == word_added.text:
					word_exists = true
					break
			if word_exists:
				button_message.text = str("Word already exists in dictionnary")
				button_message.add_theme_color_override("font_color", Color(255, 0, 0))
			else:
				json_as_dict.word_list[letter].append(word_added.text)
				var file = FileAccess.open(json_file, FileAccess.WRITE)
				file.store_string(str(json_as_dict))
				button_message.text = str("Word added to dictionnary")
				button_message.add_theme_color_override("font_color", Color(0, 255, 0))
				word_option_list.add_item(word_added.text)
				break
	word_added.clear()

func _on_random_words_pressed():
	wordlist.text = ""
	#get a random word from each letter (if it has a word)
	for letter in json_as_dict.word_list:
		if json_as_dict.word_list[letter].size() == 0:
			pass
		else:
			var random_word_from_letter : int = randi_range(0, json_as_dict.word_list[letter].size() - 1)
			wordlist.text += str(json_as_dict.word_list[letter][random_word_from_letter]) + ", "

func _on_delete_word_pressed():
	if word_option_list.get_selected_id() != -1:
		var current_word = word_option_list.get_item_text(word_option_list.get_selected_id())
		var current_letter = json_as_dict.word_list[current_word[0].to_upper()]
		button_message.text = str(current_word + " deleted from dictionary")
		button_message.add_theme_color_override("font_color", Color(255, 0, 0))
		current_letter.erase(current_word)
		word_option_list.remove_item(word_option_list.get_selected_id())

func _on_select_JSON_dictionnary_button_pressed():
	file_dialog.visible = true

func _on_file_dialog_file_selected(path):
	json_file = path
	json_as_text = FileAccess.get_file_as_string(json_file)
	json_as_dict = JSON.parse_string(json_as_text)
