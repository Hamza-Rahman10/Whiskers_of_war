extends CanvasLayer
#file used to display HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PawPrintLabel.text = str(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
