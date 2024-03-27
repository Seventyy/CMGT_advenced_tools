@tool
extends MultiMeshInstance2D

@export var populate_random_:bool:
	set(val):
		populate_random()

@export var box_size:int = 100 

func populate_random() -> void:
	var positions:Array[Vector2]
	for i in range(multimesh.instance_count):
		var transform2D = Transform2D()
		transform2D = transform2D.translated(Vector2(
			randf_range(-box_size/2,box_size/2),
			(float(i)/multimesh.instance_count-.5) * box_size
		))
		
		positions.append(transform2D.origin)
		multimesh.set_instance_transform_2d(i, transform2D)
	#material.set("shader_parameter/instances_positions", positions);
