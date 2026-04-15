extends CanvasModulate

func _process(_delta):
	# Example: grayscale modulation driven by the slider
	var v = Global.color_value
	color = Color(v, v, v)
