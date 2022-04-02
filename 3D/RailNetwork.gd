extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rail_node_prefab = preload("res://RailNode.tscn")
onready var rail_prefab = preload("res://Rail.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var number_of_nodes = 5
	var nodes = []
	for i in number_of_nodes:
		var node = rail_node_prefab.instance()
		add_child(node)
		var angle = (i as float) / (number_of_nodes as float) * 6.28318
		node.transform.origin = Vector3(sin(angle) * 20, 0, cos(angle) * 20)
		nodes.append(node)
		if i > 0:
			nodes[i].next.append(nodes[i - 1])
	nodes[0].next.append(nodes[number_of_nodes - 1])

	var rail_points = get_children()
	var rail_count = rail_points.size()
	for i in rail_count:
		var rail = rail_points[i]
		var next_rail = rail_points[(i+1)%rail_count]
		var gap_length = (rail.transform.origin - next_rail.transform.origin).length()
		print(str(gap_length))
		var rail_instance = rail_prefab.instance() as Spatial
		rail.add_child(rail_instance)
		rail_instance.scale.z = gap_length/2
		rail.look_at(next_rail.transform.origin, Vector3.UP)


#######
#
#var flagPrev = Vector2() # Give here a good starting value.
#var flag = flagPacked.instance()
#
#var newPos = Vector2(flagPrev.x + rand(5, 9), rand(30, 50)) # This here sets pos based on the previous X value.

##########################

#flag.set_pos(newPos)
#flagPrev = newPos #Update the previous in each flag spawn.
#
#get_tree().get_root().add_child(flag)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
