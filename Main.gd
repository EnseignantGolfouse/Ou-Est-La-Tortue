extends Node


func _ready():
	$Canvas.offset = $Container/Surface.rect_position + $Container/Surface.rect_size / 2

func parse(text: String):
	text = text.replace('\n', ' ')
	text = text.replace('\t', ' ')
	text = text.replace('\r', ' ')
	var input = text.split(' ', false)
	# 0: parsing instruction
	# 1: parsing number
	# 2: parsing the number of REPETE
	# 3: parsing the opening '['
	var state: int = 0
	var resultat: Array = []
	var nested: Array = []
	for x in input:
		if state == 0:
			match x:
				"]":
					state = 0
					if nested.size() == 0:
						return "Erreur : ce ']' ne ferme aucun '['"
					var intermediate = nested.pop_back()
					intermediate.push_back(resultat)
					resultat = intermediate
				"AV","RE","TD","TG":
					state = 1
					resultat.push_back(x)
				"BC","LC","ORIGINE","POS":
					resultat.push_back(x)
				"REPETE":
					state = 2
					resultat.push_back("REPETE")
				_:
					return "Erreur : instruction incorrecte '" + x + "'"
		elif state == 1 or state == 2:
			if !x.is_valid_integer():
				return "Erreur : '" + x + "' n'est pas un nombre"
			resultat.push_back(int(x))
			if state == 1:
				state = 0
			elif state == 2:
				state = 3
		elif state == 3:
			if x != "[":
				return "Erreur : on attendait un '['"
			nested.push_back(resultat)
			resultat = []
			state = 0
	if state == 1 or state == 2:
		return "Erreur : un entier est attendu"
	if state == 3:
		return "Erreur : on attendait un '['"
	if nested.size() != 0:
		return "Erreur : un block '[ ... ]' n'est pas fermé"
	return resultat

func _on_Start_pressed():
	var input = $Container/Parser/Input.text
	var parsed = self.parse(input)
	if parsed is String:
		$Container/Parser/ParserOutput.error_mode = true
		$Container/Parser/ParserOutput.clear()
		$Container/Parser/ParserOutput.push_color(Color.red)
		$Container/Parser/ParserOutput.push_bold()
		$Container/Parser/ParserOutput.add_text(parsed)
		$Container/Parser/ParserOutput.push_normal()
		$Container/Parser/ParserOutput/Timer.start()
		return
	else:
		$Canvas.execute(parsed)
		$Canvas.update()

func _on_Reset_pressed():
	$Canvas.current_position = Vector2(0, 0)
	$Canvas.positions = []
	$Canvas.update()

func _on_GotoZero_pressed():
	$Canvas.current_position = Vector2(0, 0)

func _on_Surface_resized():
	$Canvas.offset = $Container/Surface.rect_position + $Container/Surface.rect_size / 2

func _on_Canvas_emit_position(position: Vector2):
	if $Container/Parser/ParserOutput.error_mode:
		$Container/Parser/ParserOutput.error_mode = false
		$Container/Parser/ParserOutput.clear()
	var text = "la position est ("
	text += String(int(position.x))
	text += "; "
	text += String(int(position.y))
	text += ")\n"
	$Container/Parser/ParserOutput.add_text(text)
