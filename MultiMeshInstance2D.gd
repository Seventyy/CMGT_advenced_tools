@tool
extends MultiMeshInstance2D


@export var populate_random_:bool:
	set(val):
		populate_random()


func populate_random() -> void:
	for i in range(multimesh.instance_count):
		var position = Transform2D()
		position = position.translated(Vector2(randf_range(-100,100), randf_range(-100,100)))
		multimesh.set_instance_transform_2d(i, position)

