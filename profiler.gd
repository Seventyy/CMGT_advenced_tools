extends Node

@export var time_per_mesh:float = 45
@export var runs:int = 20
@export var start_time:float = 600
@export var end_time:float = 10

@export var meshes:Array[Mesh]

@onready var multi_mesh:MultiMeshInstance2D = %MultiMeshInstance2D

@onready var file:FileAccess

var frames_elapsed:int
var time_elapsed:float

func _ready():
	perform_tests()

func _process(delta):
	time_elapsed += delta
	frames_elapsed += 1

func perform_tests():
	await get_tree().create_timer(start_time).timeout
	file = FileAccess.open("res://resoults.txt", FileAccess.WRITE)
	
	for i in runs:
		file.store_string("Test #" + str(i + 1) + "\n")
		
		for mesh in meshes:
			multi_mesh.multimesh.mesh = mesh
			
			start_profiler()
			await get_tree().create_timer(time_per_mesh).timeout
			end_profiler(mesh)
			
		file.store_string("\n")
		
	await get_tree().create_timer(end_time).timeout
	get_tree().quit()

func start_profiler():
	time_elapsed = 0
	frames_elapsed = 0

func end_profiler(mesh:Mesh):
	file.store_string(
		mesh.resource_path
		 .trim_prefix("res://grass_meshes/grass_blade_")
		 .trim_suffix(".obj") + "\t" + 
		str(frames_elapsed).pad_zeros(6) + "\t" +
		str(time_elapsed).pad_zeros(2).pad_decimals(15) + "\n" 
		#str(1000 * time_elapsed / frames_elapsed) + "\n"
	)
	





