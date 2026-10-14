class_name GenericValueAnimator extends Object
var val_start
var val_end
var scale = 1.0

func interpolate(val: float):
	val = min(1.0, val)
	return pow(val, -3.6*val+1.5)
var function = interpolate

func getVal(v: float):
	var t = interpolate(v*scale)
	t = bezier_interpolate(0, 0.0, 3.0, 1.0, v * scale)
	return val_start + (val_end - val_start) * t
