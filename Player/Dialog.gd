extends RichTextLabel

var dialog = ["This developer made me a happy little land bla bla.",
	"I see so many glitches , cant this guy make anything right.",
	"I need to do something or else I will be killed!"]
var page = 0

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)


func _input(event):
	if event.is_action_pressed("skip_dialog"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
		else:
			set_visible_characters(get_total_character_count())

func _on_VisibleCharacters_timeout():
	if get_visible_characters() > get_total_character_count():
		if $Timer.is_stopped():
			$Timer.start()
	else:
		set_visible_characters(get_visible_characters() + 1)
	
func _on_Timer_timeout():
	if page < dialog.size() - 1:
		page += 1
		set_bbcode(dialog[page])
		set_visible_characters(0)
