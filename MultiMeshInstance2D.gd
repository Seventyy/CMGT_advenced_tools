@tool
extends MultiMeshInstance2D

@export var populate_random_:bool:
	set(val):
		populate_random()

@export var box_size:int = 400 
@export var seed:int

var rng:RandomNumberGenerator

var init_state:int

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	init_state = rng.state

func populate_random() -> void:
	rng.state = init_state
	for i in multimesh.instance_count:
		var transform2D = Transform2D()
		transform2D = transform2D.translated(Vector2(
			rng.randf_range(-box_size/2,box_size/2),
			(float(i)/multimesh.instance_count-.5) * box_size
		))
		multimesh.set_instance_transform_2d(i, transform2D)
