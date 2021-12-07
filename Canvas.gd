extends Node2D


var offset: Vector2 = Vector2(200,200)
var positions = []
var current_position: Vector2 = Vector2(0,0)
var angle: float = 0
var trace: bool = true
const SCALE: float = 5.0
signal emit_position


func execute(instructions: Array):
	var index: int = 0
	while index < instructions.size():
		match instructions[index]:
			"AV":
				index += 1
				var n: int = instructions[index]
				var new_vec = Vector2(n, 0).rotated(self.angle)
				if self.trace:
					self.positions.push_back(self.current_position)
				self.current_position += new_vec
				if self.trace:
					self.positions.push_back(self.current_position)
			"RE":
				index += 1
				var n: int = instructions[index]
				var new_vec = Vector2(-n, 0).rotated(self.angle)
				if self.trace:
					self.positions.push_back(self.current_position)
				self.current_position += new_vec
				if self.trace:
					self.positions.push_back(self.current_position)
			"TD":
				index += 1
				var rotation: int = instructions[index]
				self.angle -= float(rotation) * 2 * PI / 360.0
			"TG":
				index += 1
				var rotation: int = instructions[index]
				self.angle += float(rotation) * 2 * PI / 360.0
			"BC":
				self.trace = true
			"LC":
				self.trace = false
			"ORIGINE":
				self.current_position = Vector2(0,0)
			"POS":
				self.emit_signal("emit_position", self.current_position)
			"REPETE":
				index += 1
				var iterations: int = instructions[index]
				index += 1
				var instructions_loop: Array = instructions[index]
				for _i in range(0, iterations):
					self.execute(instructions_loop)
		index += 1

func _draw():
	# axis
	self.draw_line(
		Vector2(-50,0) * SCALE + self.offset,
		Vector2(50,0) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	self.draw_line(
		Vector2(50,0) * SCALE + self.offset,
		Vector2(47,-2) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	self.draw_line(
		Vector2(50,0) * SCALE + self.offset,
		Vector2(47,2) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	self.draw_line(
		Vector2(0,-50) * SCALE + self.offset,
		Vector2(0,50) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	self.draw_line(
		Vector2(0,-50) * SCALE + self.offset,
		Vector2(2,-47) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	self.draw_line(
		Vector2(0,-50) * SCALE + self.offset,
		Vector2(-2,-47) * SCALE + self.offset,
		Color.darkgray, 2.0
	)
	for x in [-40,-30,-20,-10,10,20,30,40]:
		self.draw_line(
			Vector2(x,0) * SCALE + self.offset,
			Vector2(x,2) * SCALE + self.offset,
			Color.darkgray, 2.0
		)
		self.draw_line(
			Vector2(0,x) * SCALE + self.offset,
			Vector2(-2,x) * SCALE + self.offset,
			Color.darkgray, 2.0
		)
	# turtle
	var index = 0
	print(self.positions)
	while index + 1 < self.positions.size():
		self.draw_line(
			self.positions[index] * SCALE + self.offset,
			self.positions[index+1] * SCALE + self.offset,
			Color.black, 5.0
		)
		index += 2
