extends CharacterBody2D


var GetPlayer = null
var GetEnemy = null
var IsPlayerSelected:bool = false
var CanMove:bool = true


var input = Vector2.ZERO
@export var ray:RayCast2D
var tile_size = 16
var animation_speed = 6
var moving = false
var inputs = {"ui_right":Vector2.RIGHT,
			"ui_up":Vector2.UP,
			"ui_left":Vector2.LEFT,
			"ui_down":Vector2.DOWN}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _process(_delta):
	if moving:
		return
	
	for dir in inputs.keys():
		var dirKey = Input.get_vector("Left_Key","Right_Key","UP_Key","Down_Key").round()
		if dirKey == inputs[dir] :
			move(dir)
	
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if  CanMove :
		if !ray.is_colliding():
			self.position += inputs[dir] * tile_size
			var BodyTween = get_tree().create_tween()
			BodyTween.tween_property(self, "position",self.position, 1.0/animation_speed)
			moving = true
			await BodyTween.finished
			moving = false
		elif ray.is_colliding() and ray.get_collider().is_in_group("Player21"):
			self.position += inputs[dir] * tile_size
			var BodyTween = get_tree().create_tween()
			BodyTween.tween_property(self, "position",self.position, 1.0/animation_speed)
			moving = true
			await BodyTween.finished
			moving = false
	
		
			


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player21") == true:
		if IsPlayerSelected and GetPlayer.position != body.position:
			GetEnemy = body
		if IsPlayerSelected == false:
			GetPlayer = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player21"):
		if IsPlayerSelected and GetPlayer.position != body.position:
			GetEnemy = null
		if IsPlayerSelected == false:
			GetPlayer = null
