extends RichTextLabel


var error_mode = false


func _on_Timer_timeout():
	if self.error_mode:
		self.text = ""
