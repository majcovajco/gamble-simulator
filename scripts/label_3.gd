extends TextureRect

var symbol = ""
var tween = null

func stop_animation():
	if tween:
		tween.kill()
	scale = Vector2(1,1)
