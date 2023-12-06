extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_LEFT):
		position.x -= 5
	if Input.is_key_pressed(KEY_RIGHT):
		position.x += 5
	if Input.is_key_pressed(KEY_UP):
		position.y -= 5
	if Input.is_key_pressed(KEY_DOWN):
		position.y += 5
