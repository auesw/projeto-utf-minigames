extends Minigame

var charge_level: float = 0.0
var min_charge_level: float = 30.0
var max_charge_level: float = 70.0
var charge_increment: float = 15.0
var decrease_rate: float = 25.0

var bar_min_value: float = 0.0
var bar_max_value: float = 100.0

@onready var timer = $Timer
@onready var timer_label = $TimerLabel
@onready var charge_label = $ChargeLabel
@onready var charge_bar = $ChargeBar
@onready var charge_bar_stylebox: StyleBoxFlat = StyleBoxFlat.new()

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 5.0
	
	charge_bar.min_value = 0.0
	charge_bar.max_value = 100.0
	charge_bar.step = 1.0
	charge_bar.rounded = true
	charge_bar.allow_greater = false
	charge_bar.allow_lesser = false
	
	charge_bar_stylebox.bg_color = Color.RED
	charge_bar.add_theme_stylebox_override("fill", charge_bar_stylebox)

	timer.start()

func _process(delta: float) -> void:
	timer_label.text = "Time left: %s" % str(snapped(timer.time_left, 0.01))
	charge_label.text = "Charge level: %s" %str(snapped(charge_level, 0.1))
	charge_bar.set_value_no_signal(charge_level)
	
	if not timer.is_stopped():
		if charge_level > 0:
			charge_level -= decrease_rate * delta
			charge_level = max(charge_level, bar_min_value) # Avoiding charge levels below 0

		if Input.is_action_just_released("action1"):
			#minigame_success.emit()
			charge_level += charge_increment
			charge_level = min(charge_level, bar_max_value) # Avoiding charge below above max level
		
		if charge_level >= min_charge_level and charge_level <= max_charge_level:
			charge_bar_stylebox.bg_color = Color.GREEN
		else: charge_bar_stylebox.bg_color = Color.RED
	
	else:
		if charge_level >= min_charge_level and charge_level <= max_charge_level:
			minigame_success.emit()
		else: minigame_fail.emit()
