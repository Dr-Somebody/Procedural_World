extends Camera2D

var target_zoom: float = 1.0
const min_zoom: float = 0.3
const max_zoom: float = 2.0
const zoom_increment: float = 0.1
const zoom_rate: float = 8

func _physics_process(delta):
	zoom = lerp(zoom, target_zoom * Vector2.ONE, zoom_rate * delta)
	set_physics_process(not is_equal_approx(zoom.x, target_zoom))

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / zoom
			
	if event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
				
func zoom_in() -> void:
	target_zoom = max(target_zoom - zoom_increment, min_zoom)
	set_physics_process(true)
	
func zoom_out() -> void:
	target_zoom = min(target_zoom + zoom_increment, max_zoom)
	set_physics_process(true)
