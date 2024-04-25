extends Node

@export var time_per_mesh:float = 15
@export var runs:int = 8
@export var start_time:float = 10
@export var end_time:float = 1

@export var meshes:Array[Mesh]
@export var amounts:Array[int]

@onready var multi_mesh:MultiMeshInstance2D = %MultiMeshInstance2D

var frames_elapsed:int
var time_elapsed:float

var data:Array[TestData]

class TestData:
	var grass_amount:int
	var vertex_count:int
	var avarage_frame_time:Array[float]

func _ready():
	for mesh in meshes:
		for amount in amounts:
			var d:TestData = TestData.new()
			d.grass_amount = amount
			d.vertex_count = int(
				mesh.resource_path 
				.trim_prefix("res://grass_meshes/grass_blade_") 
				.trim_suffix(".obj")
			)
			data.append(d)
	
	perform_tests()

func _process(delta):
	time_elapsed += delta
	frames_elapsed += 1

func perform_tests():
	await get_tree().create_timer(start_time).timeout
	
	for i in runs:
		for mesh in meshes:
			for amount in amounts:
				
				multi_mesh.multimesh.mesh = mesh
				multi_mesh.multimesh.instance_count = amount
				multi_mesh.populate_random()
				
				var vertex_count:int = int(
					mesh.resource_path 
					.trim_prefix("res://grass_meshes/grass_blade_") 
					.trim_suffix(".obj")
				)
				
				reset_profiler()
				await get_tree().create_timer(time_per_mesh).timeout
				
				var test_data:TestData = data.filter(func(d:TestData): return \
					d.grass_amount == amount and \
					d.vertex_count == vertex_count
				)[0]
				test_data.grass_amount = amount
				test_data.vertex_count = vertex_count
				test_data.avarage_frame_time.append(1000 * time_elapsed / frames_elapsed)
	
	await get_tree().create_timer(end_time).timeout
	save_resoults()
	get_tree().quit()

func reset_profiler():
	time_elapsed = 0
	frames_elapsed = 0


func save_resoults():
	var file := FileAccess.open("res://resoults.csv", FileAccess.WRITE)
	
	var headline := PackedStringArray()
	headline.append(" ")
	for a in amounts:
		headline.append(str(a))
	file.store_csv_line(headline)
	
	var last_vertex_count:int = 3
	var line := PackedStringArray()
	
	for d in data:
		if last_vertex_count != d.vertex_count:
			line = PackedStringArray([str(last_vertex_count)]) + line
			last_vertex_count = d.vertex_count
			file.store_csv_line(line)
			line.clear()
		
		line.append(str(d.avarage_frame_time
			.reduce(func(accum, number): return accum + number, 0)
			/ runs
		))
	
	file.store_csv_line(PackedStringArray([str(last_vertex_count)]) + line)

