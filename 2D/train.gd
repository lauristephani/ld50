extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1.0
var currentPoint = 0
var rails
var numberOfCheckPoints

# Called when the node enters the scene tree for the first time.
func _ready():
	rails = get_node("/root/TrainGame/Rails")
	numberOfCheckPoints = rails.get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print("position" + str(position))
	var currentDestination = rails.get_child(currentPoint)
	var delta = (currentDestination.position - position)
	var direction = delta.normalized()
	var distance = delta.length()
	var angle = position.angle_to_point(currentDestination.position)
	rotation = angle
	if distance > speed:
		position = position + direction * speed
	else:
		currentPoint = (currentPoint + 1) % numberOfCheckPoints
