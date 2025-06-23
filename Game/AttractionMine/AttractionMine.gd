extends Node2D

@export var attraction_radius: float = 200.0
@export var attraction_force: float = 500.0
@export var duration: float = 5.0

var active: bool = false
var timer: float = 0.0
var affected_rabbits: Array[Node] = []

signal mine_expired

func _ready() -> void:
	set_process(false)

func activate() -> void:
	active = true
	timer = 0.0
	set_process(true)
	
	# Visual feedback
	$AnimationPlayer.play("activate")
	
	# Find all glitched rabbits in range
	find_glitched_rabbits_in_range()

func _process(delta: float) -> void:
	if not active:
		return
		
	timer += delta
	
	# Attract glitched rabbits
	attract_rabbits(delta)
	
	# Refresh rabbit list periodically
	if int(timer * 10) % 10 == 0:  # Every 0.1 seconds
		find_glitched_rabbits_in_range()
	
	# Check if duration expired
	if timer >= duration:
		deactivate()

func find_glitched_rabbits_in_range() -> void:
	affected_rabbits.clear()
	var rabbits = get_tree().get_nodes_in_group("Rabbit")
	
	for rabbit in rabbits:
		if not is_instance_valid(rabbit):
			continue
			
		var distance = global_position.distance_to(rabbit.global_position)
		if distance <= attraction_radius:
			# Check if rabbit is glitched using IsNormalBehavior property
			if not rabbit.IsNormalBehavior:
				affected_rabbits.append(rabbit)

func attract_rabbits(delta: float) -> void:
	for rabbit in affected_rabbits:
		if not is_instance_valid(rabbit):
			continue
			
		var direction = (global_position - rabbit.global_position).normalized()
		var distance = global_position.distance_to(rabbit.global_position)
		
		# Apply attraction force (stronger when closer)
		var force_multiplier = 1.0 - (distance / attraction_radius)
		var attraction = direction * attraction_force * force_multiplier * delta
		
		# Apply to rabbit's anomaly behavior
		var anomaly = rabbit.get_node_or_null("Anomaly")
		if anomaly and anomaly.has_method("apply_attraction"):
			anomaly.apply_attraction(attraction)

func deactivate() -> void:
	active = false
	set_process(false)

	for rabbit in affected_rabbits:
		if is_instance_valid(rabbit):
			rabbit.ChangeToNormal()
			scatter_rabbit(rabbit)
	
	# Visual feedback
	$AnimationPlayer.play("deactivate")
	
	# Clear affected rabbits
	affected_rabbits.clear()
	
	# Emit signal and remove
	emit_signal("mine_expired")
	queue_free()

func _draw() -> void:
	if active:
		# Draw attraction radius (debug)
		var color = Color(1, 0, 0, 0.2)
		draw_circle(Vector2.ZERO, attraction_radius, color) 

func scatter_rabbit(rabbit: Node) -> void:
	pass
	# Calculate direction away from mine center
	# var direction_from_mine = (rabbit.global_position - global_position).normalized()
	
	# # Add random angle variation (±45 degrees) for more spread
	# var random_angle = randf_range(-PI/4, PI/4)
	# var scattered_direction = direction_from_mine.rotated(random_angle)
	
	# # If rabbit is too close to center, use completely random direction
	# if rabbit.global_position.distance_to(global_position) < 10:
	# 	var random_angle_full = randf() * 2 * PI
	# 	scattered_direction = Vector2(cos(random_angle_full), sin(random_angle_full))
	
	# var scatter_force = 200.0  # Much stronger scatter force
	
	# Apply scatter force to rabbit's normal behavior
	# var normal = rabbit.get_node_or_null("Normal")
	# if normal:
	# 	var pos = normal.get_parent().position + scattered_direction * scatter_force

	# 	var tween = create_tween()
	# 	tween.set_ease(Tween.EASE_OUT)
	# 	tween.set_trans(Tween.TRANS_QUART)
	# 	tween.tween_property(normal.get_parent(), "position", pos, 0.5)
	# 	tween.tween_callback(normal.set_process.bind(true))
