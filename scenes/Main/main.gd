extends Node2D

# Holds data to be distributed across various game nodes, such as score and player health

@export var score: int = 0
@export var health: int = 3

signal score_increased(current_score: int)
signal score_decreased(current_score: int)
signal health_decreased(current_health: int)
signal health_increased(current_health: int)
signal all_minigames_beaten

@export var minigame_scenes: Array[PackedScene]
@onready var minigame_holder: Node2D = $Minigame
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel

var minigame: Minigame
var all_minigames: Array[Minigame]

func _ready() -> void:
	update_score_label()
	update_health_label()

	for item in minigame_scenes:
		all_minigames.append(item.instantiate())
	spawn_minigame()

# Spawna um minigame
func spawn_minigame() -> void:
	if not all_minigames: 
		all_minigames_beaten.emit()
		print("SPAWNAR BOSS MAP")
		# spawn boss map
	else: 
		minigame = all_minigames.pick_random()
		minigame_holder.add_child(minigame)

		minigame.minigame_success.connect(_on_minigame_success)
		minigame.minigame_fail.connect(_on_minigame_fail)

# Remove um minigame
func despawn_minigame() -> void:
	for item in minigame_holder.get_children():
		item.queue_free()
	#minigame_holder.queue_free()
	remove_minigame_from_array(minigame)
	spawn_minigame()

# Remove o minigame do array de minigames
func remove_minigame_from_array(minigame_: Minigame) -> void:
	all_minigames.erase(minigame_)

# Atualiza o mostrador do placar
func update_score_label() -> void:
	score_label.text = "Score: %s" % str(score)

# Atualiza o mostrador da vida do jogador
func update_health_label() -> void:
	health_label.text = "Health: %s" % str(health)

# Evento executado quando o jogador vence o minigame
func _on_minigame_success() -> void:
	score += 1
	score_increased.emit(score)
	update_score_label()
	despawn_minigame()
	# Rotinas entre 2 minigames (animações, diálogos, cutscenes, etc)

# Evento executado quando o jogador perde o minigame
func _on_minigame_fail() -> void:
	score -= 1
	health -= 1

	update_score_label()
	update_health_label()
	if health <= 0: print("GAME OVER")
	score_decreased.emit(score)
	health_decreased.emit(health)
