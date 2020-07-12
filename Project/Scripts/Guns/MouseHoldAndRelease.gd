extends Node2D

signal hold_started()
signal shot_input(input_value)

export(float) var cooldown = 0.2
var _current_cooldown = 0.0

export(float) var max_hold_time = 0.8
export(float) var min_hold_time = 0.3
var _current_hold_time = 0.0

export(float) var forgiveness = 0.15

var _percent_held = 0
var _holding = false


func _process(delta):
	_current_cooldown -= delta
	if Input.is_action_just_pressed("shoot"):
		if not _current_cooldown <= 0:
			return
		_holding = true
		_current_hold_time = 0.0
		_percent_held = 0.0
		emit_signal("hold_started")
	if Input.is_action_pressed("shoot") and _holding:
			_current_hold_time += delta
			_percent_held = (_current_hold_time - min_hold_time) / (max_hold_time - min_hold_time)
			_percent_held = min(_percent_held + forgiveness, 1.0)
	
	if Input.is_action_just_released("shoot") and _holding:
			_percent_held = (_current_hold_time - min_hold_time) / (max_hold_time - min_hold_time)
			_percent_held = min(_percent_held + forgiveness, 1.0)
			_current_cooldown = cooldown
			_current_hold_time = 0.0
			_holding = false
			emit_signal("shot_input", _percent_held)

func get_percent_held():
	return _percent_held

func equip():
	_current_cooldown = cooldown
	_holding = false
	set_process(true)

func unequip():
	_current_hold_time = 0.0
	_holding = false
	set_process(false)
