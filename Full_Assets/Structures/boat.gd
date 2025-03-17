extends VehicleBody3D
class_name Boat

var seats = []
var driver 

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_seats()

func _physics_process(delta):
	if driver:
		steering = lerp(steering, Input.get_axis("player_right", "player_left") * 0.4, 5*delta)
		engine_force = Input.get_axis("player_back", "player_forward") * 100 

func populate_seats():
	for child in get_children():
		if child is Marker3D:
			seats.append(child)

func can_i_sit():
	for seat in seats:
		if seat.get_children().size() == 0:
			return true
	return false

func request_seat(passenger):
	if can_i_sit():
		place_in_seat(passenger)

func place_in_seat(passenger):
	for seat in seats:
		if seat.get_children().size() == 0:
			seat(passenger, seat)
			passenger.transition_as_passenger(true, self)
			passenger.global_position = seat.global_position

func seat(passenger, seat):
	passenger.reparent(seat)

func set_driver(d):
	driver = d
