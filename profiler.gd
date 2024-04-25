extends Node

@export var time_per_mesh:float = 15
@export var runs:int = 8
@export var start_time:float = 10


@export var meshes:Array[Mesh]
@export var amounts:Array[int]

@onready var multi_mesh:MultiMeshInstance2D = %MultiMeshInstance2D

@onready var file:FileAccess

var frames_elapsed:int
var time_elapsed:float

var data:Array[TestData]

class TestData:

	var run_id:int
	var grass_amount:int
	var vertex_count:int
	var avarage_frame_time:float

func _ready():
	perform_tests()

func _process(delta):
	time_elapsed += delta
	frames_elapsed += 1

func perform_tests():
	await get_tree().create_timer(start_time).timeout
	file = FileAccess.open("res://resoults.csv", FileAccess.WRITE)
	
	for i in runs:
		for mesh in meshes:
			for amount in amounts:
				
				multi_mesh.multimesh.mesh = mesh
				multi_mesh.multimesh.instance_count = amount
				multi_mesh.populate_random()
				
				
				reset_profiler()
				await get_tree().create_timer(time_per_mesh).timeout
				
				var test_data := TestData.new()
				test_data.run_id = i+1 
				test_data.grass_amount = amount
				test_data.vertex_count = int(
					mesh.resource_path 
					.trim_prefix("res://grass_meshes/grass_blade_") 
					.trim_suffix(".obj")
				)
				test_data.avarage_frame_time = 1000 * time_elapsed / frames_elapsed
				data.append(test_data)
	
	await get_tree().create_timer(end_time).timeout
	save_resoults()
	get_tree().quit()

func reset_profiler():
	time_elapsed = 0
	frames_elapsed = 0


func save_resoults():
	var last_run_id:int = 0
	var last_vertex_count:int = 3
	var line := PackedStringArray()

	
	for d in data:
		if last_vertex_count != d.vertex_count:
			line = PackedStringArray([str(last_vertex_count)]) + line
			last_vertex_count = d.vertex_count
			file.store_csv_line(line)
			line.clear()
		
		if last_run_id != d.run_id:
			last_vertex_count = 3
			last_run_id = d.run_id
			
			file.store_string("\n")
			
			var headline := PackedStringArray()
			headline.append(str(d.run_id))
			for a in amounts:
				headline.append(str(a))
			file.store_csv_line(headline)
		
		line.append(str(d.avarage_frame_time))
	
	file.store_csv_line(PackedStringArray([str(last_vertex_count)]) + line)

