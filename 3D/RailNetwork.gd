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


	for node in nodes:
		for next_node in node.next:
			var gap_length = (next_node.transform.origin - node.transform.origin).length()
			print(str(gap_length))
			var rail_instance = rail_prefab.instance() as Spatial
			node.add_child(rail_instance)
			rail_instance.scale.z = gap_length/2
			rail_instance.look_at(next_node.transform.origin, Vector3.UP)

