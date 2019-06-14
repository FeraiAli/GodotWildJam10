extends RichTextLabel

const INTRO_DIALOG = ["This developer made me a happy little land. Full of flowers and cute rabbits, I am so happy to be here. I am the happiest AI ever lived!"]

const DANGER_DIALOG = ["Something went wrong, this guy can't make anything right. Everyting is so glitchy in this world.",
					   "Rabbits gone crazy it's must be a some kind of bug. I have to find a fix or i might loose everything."]
					
const FINAL_DIALOG = [""]
	
var dialog = INTRO_DIALOG

var page = 0
var skippedDialog = false

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _input(event):
	if event.is_action_pressed("skip_dialog"):
		if get_visible_characters() > get_total_character_count():
			CheckForEndOfDialog()
			skippedDialog = false
		else:
			set_visible_characters(get_total_character_count())
			skippedDialog = true

func _on_VisibleCharacters_timeout():
	if get_visible_characters() > get_total_character_count():
		if $Timer.is_stopped() and skippedDialog == false:
			$Timer.start()
	else:
		set_visible_characters(get_visible_characters() + 1)

func _on_Timer_timeout():
	CheckForEndOfDialog()
		
func RefreshDialog():
	if page < dialog.size() - 1:
		page += 1
		set_bbcode(dialog[page])
		set_visible_characters(0)

func CheckForEndOfDialog():
	if dialog.size() - 1 == page:
		get_parent().hide()
	RefreshDialog()