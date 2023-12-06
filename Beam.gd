extends Node2D

signal mode_change(new_mode)

@onready var slider:HSlider = $"../HSlider"
@onready var valueLabel:Label = $"../VBoxContainer/ValueLabel"
@onready var goalLabel:Label = $"../VBoxContainer/GoalLabel"

@onready var kpLabel:Label = $"../VBoxContainer/kp"
@onready var kiLabel:Label = $"../VBoxContainer/ki"
@onready var kdLabel:Label = $"../VBoxContainer/kd"

const MODE_POSITION = false
const MODE_VELOCITY = true
var mode = MODE_POSITION

var measured_position:float = 0
var measured_velocity:float = 0
#var disturbance:float = 0

var desired_position = 0
var desired_velocity = 0

func update_labels():
	if mode == MODE_POSITION:
		kpLabel.text = "Kp: " + str($PositionPID.K_p)
		kiLabel.text = "Ki: " + str($PositionPID.K_i)
		kdLabel.text = "Kd: " + str($PositionPID.K_d)
		valueLabel.text = "H. Position: " + str(get_current_ball_position())
		goalLabel.text = "Goal: " + str(desired_position)
	if mode == MODE_VELOCITY:
		kpLabel.text = "Kp: " + str($VelocityPID.K_p)
		kiLabel.text = "Ki: " + str($VelocityPID.K_i)
		kdLabel.text = "Kd: " + str($VelocityPID.K_d)
		valueLabel.text = "H. Velocity: " + str(get_current_ball_velocity())
		goalLabel.text = "Goal: " + str(desired_velocity)

#func do_disturb():
#	var disturb = Input.get_axis("tilt_left", "tilt_right")
#	if disturb:
#		disturbance += disturb
#	else:
#		disturbance = 0
#
#	get_parent().get_node("Ball/RigidBody2D").apply_central_force(Vector2(disturbance,0))

func do_mode():
	if Input.is_action_just_pressed("switch_mode"):
		mode = not mode
		mode_change.emit(mode)
		if mode == MODE_POSITION:
			slider.set_value_no_signal(desired_position)
		else:
			slider.set_value_no_signal(desired_velocity)

func get_current_ball_velocity():
	return get_node("../Ball/RigidBody2D").linear_velocity.x

func get_current_ball_position():
	return get_node("../Ball/RigidBody2D").global_position.x - $CharacterBody2D.global_position.x

func sensor():
	measured_position = get_current_ball_position()
	measured_velocity = get_current_ball_velocity()

func update_goal():
	if mode == MODE_POSITION:
		desired_position = slider.value
	elif mode == MODE_VELOCITY:
		desired_velocity = slider.value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	do_disturb()
	do_mode()
	update_goal()
	update_labels()
	
	sensor()
	
	var new_degrees
	if mode == MODE_POSITION:
		new_degrees = $PositionPID.control(delta, desired_position - measured_position)
		
		
	elif mode == MODE_VELOCITY:
		new_degrees = $VelocityPID.control(delta, desired_velocity - measured_velocity)
		
		
	$CharacterBody2D.rotation_degrees = new_degrees
	
