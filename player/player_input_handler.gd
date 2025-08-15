extends Node
class_name PlayerInputHandler

@export var board_control: BoardControl
@export var board_view: BoardView

func _ready() -> void:
	board_view.on_move_request.connect(_on_board_view_request)
	
func _on_board_view_request(piece: ChessPiece, board_pos: Vector2i) -> void:
	board_control.untrusted_request_play(board_control.get_current_player_control(), piece, board_pos)

func screen_pos_to_board_pos(screen_pos: Vector2) -> Vector2i:
	var local_screen_pos := screen_pos - board_view.position
	var board_pos := Vector2i((local_screen_pos / Vector2(board_view.piece_size)).floor())
	return board_pos


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index != 1:
			return
		var board_pos := screen_pos_to_board_pos(event.position)
		board_view.select_on_world(board_pos, board_control.playing_player)
