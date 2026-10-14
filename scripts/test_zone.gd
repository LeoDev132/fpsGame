extends Node

var min_v = 0.0
var max_v = 0.0
var v = 0.0
var pre = 0.0
var post = 0.0

func updateValues():
	min_v = bezier_interpolate(0, pre, post, 1.0, 0.0)
	max_v = bezier_interpolate(0, pre, post, 1.0, 0.0)
	var p = PackedVector2Array()

	for i in range(100):
		var c = bezier_interpolate(0, pre, post, 1.0, i/100.0)
		min_v = min(min_v, c)
		max_v = max(max_v, c)
		p.append(Vector2(i, -10.0 * bezier_interpolate(0, pre, post, 1.0, i / 100.0)))
	$post/Line2D.points = p
	$Label.text = str(bezier_interpolate(0, pre, post, 1.0, v / 100.0))
	$Label2.text = str(min_v)
	$Label3.text = str(max_v)
	
func _on_val_value_changed(value: float) -> void:
	v = value
	updateValues()
	pass # Replace with function body.


func _on_pre_value_changed(value: float) -> void:
	pre = value
	updateValues()
	pass # Replace with function body.


func _on_post_value_changed(value: float) -> void:
	post = value
	updateValues()
	pass # Replace with function body.
