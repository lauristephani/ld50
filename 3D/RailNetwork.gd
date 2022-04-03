extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var nodemesh_prefab = preload("res://RailNode.tscn")
onready var railmesh_prefab = preload("res://Rail.tscn")

export var number_of_nodes = 5
export var railmesh_length = 0.50

# Called when the node enters the scene tree for the first time.
func _ready():
	var nodes = []
	for i in number_of_nodes:
		var node = nodemesh_prefab.instance()
		add_child(node)
		var angle = (i as float) / (number_of_nodes as float) * 6.28318
		node.transform.origin = Vector3(sin(angle) * 20, 0, cos(angle) * 20)
		nodes.append(node)
		if i > 0:
			nodes[i].next.append(nodes[i - 1])
	nodes[0].next.append(nodes[number_of_nodes - 1])

	var rail_points = get_children()
	var segment_count = rail_points.size()
	for i in segment_count:
		var segment = rail_points[i]
		var next_segment = rail_points[(i+1)%segment_count]
		generate_railmesh(segment, next_segment)

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

func generate_nodemesh(segment, next_segment):
	pass
