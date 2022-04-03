extends Area

var grid_position = {}
var next = []
var prev = []
var next_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_event(camera, event, click_position, click_normal, shape_idx):
	var number_of_next = next.size()
	if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
		next_index = (next_index + 1) % number_of_next
		print("next index " + str(next_index))

func get_next_node():
	if next.size() == 0:
		return self
	return next[next_index]
