extends Node
class_name PlayerControl

@export var board_control: BoardControl
@export var board_model: BoardModel
@export var player_color: Globals.PlayerColor

@rpc("authority", "call_local", "reliable", 0)
func update_player_state(start_board_pos: Vector2i, end_board_pos: Vector2i) -> void:
	# server already has true state
	if multiplayer.is_server():
		return
	print("Updating peer local state")
	if start_board_pos not in board_model.pieces:
		print("ERROR: authority sent invalid move")
		return 
	var local_piece = board_model.pieces[start_board_pos]
	board_control.force_move_piece(end_board_pos, local_piece)
	
