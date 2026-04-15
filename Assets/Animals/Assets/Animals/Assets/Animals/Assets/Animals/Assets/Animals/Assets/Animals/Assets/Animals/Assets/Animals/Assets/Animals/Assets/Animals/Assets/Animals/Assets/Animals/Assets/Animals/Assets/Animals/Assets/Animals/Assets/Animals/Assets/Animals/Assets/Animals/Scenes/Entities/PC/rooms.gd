extends Node2D

var current_room: String = ""

# Map room names to the wall layers they should hide
var room_walls: Dictionary = {}

const VERY_BACK = -7
const WALL_BEHIND = -4
const PLAYER_Z = 0
const WALL_FRONT = 2
const VERY_FRONT = 4

@onready var outer = $"../Walls/outer_walls"
@onready var ext = $"../Walls/ship_ext"
@onready var b_door = $"../Walls/b_door"
@onready var a_door = $"../Walls/a_door"
@onready var k_door = $"../Walls/k_door"
@onready var o_door = $"../Walls/o_door"
@onready var o_b_wall = $"../Walls/inner_walls/o_b_wall"
@onready var b_c_wall = $"../Walls/inner_walls/b_c_wall"
@onready var p_o_wall = $"../Walls/inner_walls/p_o_wall"
@onready var a_k_wall = $"../Walls/inner_walls/a_k_wall"
@onready var p_a_wall = $"../Walls/inner_walls/p_a_wall"
@onready var k_c_wall = $"../Walls/inner_walls/k_c_wall"

@onready var bed = $"../Decor/bed"
@onready var boiler = $"../Decor/boiler"
@onready var desk = $"../Decor/desk"
@onready var desk2 = $"../Decor/desk2"
@onready var couch = $"../Decor/couch"
@onready var couch3 = $"../Decor/couch3"
@onready var kitchen = $"../Decor/kitchen"

@onready var tanks = $"../Animals/tanks"
@onready var glass = $"../Animals/glass"

func _ready() -> void:
	room_walls = {
		"Room_bedroom": {
			"hide": [b_door],
			"z_index": [
				[outer, VERY_BACK],
				[o_b_wall, WALL_FRONT],
				[b_c_wall, WALL_BEHIND],
				[bed, PLAYER_Z - 1],
				[desk, WALL_FRONT],
				[o_door, VERY_FRONT],
				[couch, PLAYER_Z + 1],
				[kitchen, 7]
				]
			},
		"Room_office": {
			"hide":[o_door],
			"z_index": [
				[outer, VERY_BACK],
				[o_b_wall, PLAYER_Z -2],
				[p_o_wall, PLAYER_Z + 2],
				[desk, PLAYER_Z - 1],
				[desk2, PLAYER_Z - 1],
				[boiler, PLAYER_Z + 3]
			]
			},
		"Room_kitchen": {
			"hide":[k_door],
			"z_index": [
				[a_k_wall, WALL_FRONT], 
				[k_c_wall, WALL_BEHIND],
				[kitchen, PLAYER_Z - 1],
				[tanks,WALL_FRONT+2],
				[glass,WALL_FRONT+3]]
			},
		"Room_animals": {
			"hide":[a_door],
			"z_index": [
				[a_k_wall, WALL_BEHIND], 
				[p_a_wall, WALL_FRONT],
				[tanks,WALL_BEHIND+2],
				[glass,WALL_BEHIND+3]
				] 
			},
		"Room_boiler": {
			"z_index": [
				[p_a_wall, WALL_BEHIND], 
				[p_o_wall, WALL_BEHIND-1],
				[boiler, WALL_BEHIND]
				] 
			},
		"Room_control": {
			"z_index": [
				[b_c_wall, 1],
				[bed, 2], 
				[b_door, 3], 
				[k_c_wall, 1],
				[k_door,3],
				[couch, 4],
				[couch3, PLAYER_Z + 1],
				]
			},
		"Room_hall": {
			"z_index": [
				[outer, VERY_BACK],
				[ext, 20],
				[o_b_wall, PLAYER_Z - 3],
				[b_c_wall, PLAYER_Z - 3],
				[p_o_wall, WALL_FRONT],
				[p_a_wall, WALL_FRONT],
				[a_k_wall, WALL_FRONT],
				[k_c_wall, WALL_BEHIND],

				[desk, PLAYER_Z - 2],
				[desk2, PLAYER_Z - 2],
				[bed, PLAYER_Z - 2],
				[boiler, WALL_FRONT + 2],
				[couch, PLAYER_Z - 1],
				[couch3, PLAYER_Z + 1],
				[kitchen, 7],
				
				[tanks,WALL_FRONT+2],
				[glass,WALL_FRONT+3],

				[o_door, PLAYER_Z - 1],
				[b_door, PLAYER_Z - 1],
				[a_door, VERY_FRONT],
				[k_door, VERY_FRONT]
				]
			},
	}

	for room in get_children():
		if room is Area2D:
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited.bind(room.name))

func _on_room_entered(body: Node, room_name: String) -> void:
	if body.name == "Player_Character":
		current_room = room_name
		#print("Player entered: ", current_room) # Track current room
		
		var data = room_walls.get(room_name, {})
		for wall in data.get("hide", []):
			wall.visible = false
		for pair in data.get("z_index", []):
			pair[0].z_index = pair[1]

func _on_room_exited(body: Node, room_name: String) -> void:
	if body.name == "Player_Character":
		current_room = "Room_hall"
		#print("Player left: ", room_name) # Track when room left
		
		var data = room_walls.get(room_name, {})
		for wall in data.get("hide", []):
			wall.visible = true
		'''for pair in data.get("z_index", []):
			pair[0].z_index = PLAYER_Z'''
