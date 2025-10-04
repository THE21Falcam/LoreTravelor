extends Node2D

@export var Tile:TileMapLayer
@onready var EnemySprite = $Enemy
@export var Marker:CharacterBody2D
@export var Line:Line2D
#var tomove:bool = false
var zoom = Vector2(3,3)
@onready var Camera = $Marker/Camera2D
var Previous_Tile:Vector2i
var tile_size = 16
var animation_speed = 20
var moving = false
var viewpath = []
var path = []
var dir:Vector2
var count = 0
@onready var HUD = $CanvasLayer/HUD
var target_body:CharacterBody2D = null
var astar_grid:AStarGrid2D
var toMove = false
var canAttack = false

func _ready():
	Camera.zoom = zoom
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Tile.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x+region_position.x,
				y+region_position.y
			)
			var tile_data = Tile.get_cell_tile_data(tile_position)
			if tile_data == null or not tile_data.get_custom_data("CanWalk"):
				astar_grid.set_point_solid(tile_position)

func _process(_delta):
	
	#Mouse Interaction
	#$Sprite2D.position = (Vector2(Tile.local_to_map(get_global_mouse_position())) * Vector2(16,16)) + Vector2(8,8) 
	
	
	if moving:
		return

	if Marker.GetPlayer != null :
		$CanvasLayer/HUD.DisplayHP.text = "HP " + str(Marker.GetPlayer.MaxHP)
		$CanvasLayer/HUD.DisplaySP.text = "SP " + str(Marker.GetPlayer.MaxSP)
		$CanvasLayer/HUD.SoldierData.visible = true
		if Input.is_action_pressed("SelPlay") and !Marker.IsPlayerSelected:
			Line.visible = true
			Marker.IsPlayerSelected = true
			Marker.CanMove = false
			Marker.GetPlayer.BattleUI.visible = true
			Marker.GetPlayer.ButtonMove.grab_focus()
			Camera.position = Marker.GetPlayer.position + Vector2(-25,0)
			Camera.zoom = zoom + Vector2.ONE
		if Marker.GetPlayer.ButtonMove.button_pressed:
			toMove = true
			Marker.CanMove = true
			Camera.position = $Marker.position
			Camera.zoom = zoom
			Marker.GetPlayer.BattleUI.visible = false
		if Marker.GetPlayer.ButtonAttack.button_pressed :
			canAttack = true
			Marker.CanMove = true
			Camera.position = Vector2(0,0)
			Camera.zoom = zoom
			Marker.GetPlayer.BattleUI.visible = false
			Line.visible = false
			#and Marker.GetPlayer.position != Marker.position
			pass
		if Input.is_action_pressed("Back"):
			Line.visible = false
			Marker.IsPlayerSelected = false
			Marker.CanMove = true
			Marker.GetPlayer.BattleUI.visible = false
			Marker.GetPlayer = null
			Camera.position = Vector2(0,0)
			Camera.zoom = zoom
	else:
		$CanvasLayer/HUD.SoldierData.visible = false

	if Marker.GetPlayer != null and Marker.IsPlayerSelected:
		viewpath = astar_grid.get_point_path(
			Tile.local_to_map(Marker.GetPlayer.position),
			Tile.local_to_map(Marker.position)
		)
		Line.points = viewpath

		if Input.is_action_pressed("SelPlay") and  Marker.GetPlayer.position != Marker.position and Marker.GetEnemy == null and toMove:
			path = astar_grid.get_id_path(
				Tile.local_to_map(Marker.GetPlayer.position),
				Tile.local_to_map(Marker.position)
			)
			move()
	if Marker.GetEnemy != null and Marker.IsPlayerSelected:
		if Input.is_action_pressed("SelPlay") and Marker.GetEnemy.position == Marker.position and canAttack:
			Marker.GetEnemy.MaxHP -= 2
			Marker.IsPlayerSelected = false
			Marker.GetPlayer = null
			Marker.GetEnemy = null
			canAttack = false
	
func move():
	Line.visible = false
	Marker.GetPlayer.BattleUI.visible = false
	Marker.CanMove = false
	if !path.is_empty():
		for i in path.size():
			Marker.GetPlayer.position = Tile.map_to_local(path[0])
			var HeadTween = get_tree().create_tween()
			HeadTween.tween_property(Marker.GetPlayer, "position", Marker.GetPlayer.position + dir*tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
			moving = true
			await HeadTween.finished
			moving = false
			path.pop_front()

		Marker.IsPlayerSelected = false
		Marker.CanMove = true
		Marker.GetPlayer = null
		toMove = false
