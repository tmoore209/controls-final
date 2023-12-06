extends Node

@export
var K_p = 0.99649
@export
var K_i = 1.95986
@export
var K_d =-0.03682

var accumulated_error = 0
var previous_error = 0

func reset():
	accumulated_error = 0
	previous_error = 0

# Bit of help from https://www.arrow.com/en/research-and-events/articles/pid-controller-basics-and-tutorial-pid-implementation-in-arduino
func control(delta, error):
	var units = delta
	
	var inst_error = error
	var cumu_error = accumulated_error * delta
	var error_rate = (inst_error - previous_error) / delta

	var u = K_p*inst_error + K_i*cumu_error + K_d * error_rate
	
	accumulated_error += inst_error
	previous_error = inst_error
	
	return u * units


func _on_beam_mode_change():
	reset()
	
