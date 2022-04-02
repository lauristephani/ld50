extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1.0
var current_node
var rails
var numberOfCheckPoints

# Called when the node enters the scene tree for the first time.
func _ready():
	rails = get_node("/root/TrainGame/Network")
	numberOfCheckPoints = rails.get_child_count()
	current_node = rails.get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var position = global_transform.origin
	var currentDestination = current_node
	var destination_position = currentDestination.transform.origin
	var gap = (destination_position - position)
	var direction = gap.normalized()
	var distance = gap.length()
	var travel_distance = speed * delta
	look_at(destination_position, Vector3.UP)
	
	if distance > travel_distance:
		transform.origin = transform.origin + (direction * travel_distance)
	else:
		current_node = current_node.next[0]
