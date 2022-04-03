extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rail_node_prefab = preload("res://RailNode.tscn")
onready var rail_prefab = preload("res://Rail.tscn")
var nodes = []
var grid = {}
var grid_size = 15
var cell_size = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for index in grid_size:
		create_node_at(index, 0)
	for index in grid_size:
		create_node_at(grid_size, index)
	for index in grid_size:
		create_node_at(grid_size - index, grid_size)
	for index in grid_size:
		create_node_at(0, grid_size - index)
		
	for index in nodes.size():
		var current = nodes[index]
		var next = nodes[(index + 1) % nodes.size()];
		chain_node(current, next)

#	var random_node = nodes[randi() % nodes.size()]
#	var direction = get_random_direction_for_position(random_node.grid_position)
#	step_in_direction(random_node.grid_position, direction, grid_size)
	
	for branch in 40:
		var random_node = nodes[randi() % nodes.size()]
		var current_step = random_node.grid_position
		var prev_step = random_node.prev[0].grid_position
		for i in 100:
			var step = random_inner_step(current_step, prev_step)
			if step.result:
				break
			else:
				prev_step = current_step
				current_step = step.current
	
	for node in nodes:
		for next_node in node.next:
			var gap_length = (next_node.transform.origin - node.transform.origin).length()
			print(str(gap_length))
			var rail_instance = rail_prefab.instance() as Spatial
			node.add_child(rail_instance)
			rail_instance.scale.z = gap_length/2
			rail_instance.look_at(next_node.transform.origin, Vector3.UP)

func to_tile_index(x, y):
	return y * grid_size + x
	
func position_to_tile_index(position):
	return to_tile_index(position.x, position.y)
	
func from_tile_index(index):
	return {x = index % grid_size, y = index / grid_size}

func is_in(position):
	return position.x >= 0 && position.y >= 0 && position.x < grid_size && position.y < grid_size

func create_node_at(x, y):
		var node = rail_node_prefab.instance()
		var decal =  - grid_size * cell_size / 2
		add_child(node)
		nodes.append(node)
		node.transform.origin = Vector3(x * cell_size + decal + (y % 2 * cell_size), 0, y * cell_size + decal)
		grid[to_tile_index(x, y)] = node
		node.grid_position = {x = x, y = y}
		return node

func get_random_direction():
	var decal = randi() % 4
	if decal == 0:
		decal = {x = 1, y = 0}
	elif decal == 1:
		decal = {x = 0, y = 1}
	elif decal == 2:
		decal = {x = -1, y = 0}
	elif decal == 3:
		decal = {x = 0, y = -1}
	return decal

func get_random_direction_for_position(position):
	var direction
	for i in 10:
		direction = get_random_direction()
		var next_position = {x = position.x + direction.x, y = position.y + direction.y}
		if !is_in(next_position):
			continue
			
		var direction_index = position_to_tile_index(next_position)
		if !grid.has(direction_index):
			return direction
	return direction

func random_inner_step(position, prev):
	var current_node = grid[position_to_tile_index(position)]
	var next_position
	var decal = get_random_direction()
	next_position = {x = position.x + decal.x, y = position.y + decal.y}
	while !is_in(next_position) || (next_position.x == prev.x && next_position.y == prev.y):
		decal = get_random_direction()
		next_position = {x = position.x + decal.x, y = position.y + decal.y}

	var next_index = position_to_tile_index(next_position)
	if grid.has(next_index):
		chain_node(current_node, grid[next_index])
		chain_node(grid[next_index], current_node)
		return {result = true}
	else:
		var next_node = create_node_at(next_position.x, next_position.y)
		chain_node(current_node, next_node)
		return {result = false, current = next_position}

func step_in_direction(position, direction, nb_step):
	var current_node = grid[position_to_tile_index(position)]
	var next_position = {x = position.x + direction.x, y = position.y + direction.y}
	var next_index = position_to_tile_index(next_position)
	for st in nb_step:
		if grid.has(next_index):
			chain_node(current_node, grid[next_index])
			chain_node(grid[next_index], current_node)
			return {result = true}
		else:
			var next_node = create_node_at(next_position.x, next_position.y)
			chain_node(current_node, next_node)
			next_position = {x = next_position.x + direction.x, y = next_position.y + direction.y}
			current_node = next_node
			
	return {result = false, current = current_node.grid_position}
	
	
func chain_node(prev_node, next_node):
	prev_node.next.append(next_node)
	next_node.prev.append(prev_node)
	
	
func generate_railmesh(segment, next_segment):
	var gap = (segment.transform.origin - next_segment.transform.origin)
	var railmesh_count = gap.length() / railmesh_length
	var direction = gap.normalized()
	for i in railmesh_count:
		var railmesh_instance = railmesh_prefab.instance() as Spatial
		var nextpos = segment.transform.origin as Vector3
#		railmesh_instance.global_rotate(Vector3.UP, segment.transform.origin.angle_to(next_segment.transform.origin))
		railmesh_instance.look_at(railmesh_instance.transform.origin + direction, Vector3.UP)
		railmesh_instance.transform.origin += direction * i * railmesh_length
		next_segment.add_child(railmesh_instance)

