extends Area3D

const ROT_SPEED = 2 #number of ged pawprint rotates every fame
@export var hud : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))
	
	#if has_overlapping_bodies():
		#queue_free()

#if player gets all kittens player returns to level one
func _on_body_entered(body: Node3D) -> void:
	Global.pawprint += 1
	hud.get_node("PawPrintLabel").text = str(Global.pawprint)
	if Global.pawprint >= Global.NUM_PAWPRINTS_TO_WIN:
		get_tree().change_scene_to_file("res://level_1.tscn")
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	$AnimationPlayer.play("bounce")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
