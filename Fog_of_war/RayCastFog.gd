extends MeshInstance3D
class_name vision_calculator

#this class generates a procedural mesh around and in front of the player
#this mesh is then viewed by a SubViewport which can only see this mesh to generate a mask texture every frame
#this mask is then passed to a canvas item shader on a colroRect node covering the screen, that darkens the screen with exception to the masked area
#the mesh's collision data can also be used to determine if a enemy should be visible or not



@export var vision_radius : float = 10.0
@export var vision_fov : int = 90
@export var number_of_rays : int = 180

@export var vertical_offset := 0.0  # Just above ground to prevent Z-fighting
@export var look_direction := 0.0

func _process(delta: float) -> void:
	create_vision_mesh()

func create_vision_mesh():
	mesh = null
	var space_rid = get_world_3d().direct_space_state
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var vertex_array : Array[Vector3] = []
	var origin = global_position
	
	vertex_array.append(Vector3(0, 0, 0))
	
	for i in range(number_of_rays):
		var step = i / float(number_of_rays - 1)
		var angle = deg_to_rad(global_rotation.y - vision_fov/2 + step * vision_fov + 90 - look_direction)
		var direction = Vector3(cos(angle), 0, sin(angle)).normalized()
		
		var ray_origin = origin
		var ray_target = ray_origin + direction * vision_radius
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 1)
		var result = space_rid.intersect_ray(query)
		
		var hit_pos : Vector3
		if result:
			hit_pos = result.position
		else:
			hit_pos = ray_target
		vertex_array.append(Vector3(hit_pos.x, origin.y, hit_pos.z) - origin)
	
	st.add_triangle_fan(vertex_array)
	var vis_mesh = st.commit()
	mesh = vis_mesh
