extends ChessPiece
class_name ChessPawn

func get_move_set(board: ChessBoard) -> Dictionary[Vector2i, int]:
	print("Asking move set at ", board_position)
	var moves : Dictionary[Vector2i, int] = {}
	
	var starting_line : int = 6 if player_color == Globals.PlayerColor.WHITE else 1
	var forward : int = -1 if player_color == Globals.PlayerColor.WHITE else 1
	
	if board_position.y == starting_line:
		moves[Vector2i(board_position.x, board_position.y + (2 * forward))] = 0

	var next_line = Vector2i(board_position.x, board_position.y + (1 * forward))
	moves[next_line] = 0
	next_line = Vector2i(board_position.x, board_position.y + (1 * forward * -1))
	moves[next_line] = 0
	next_line = Vector2i(board_position.x - 1, board_position.y + (1 * forward))
	moves[next_line] = 0

	next_line = Vector2i(board_position.x + 1, board_position.y + (1 * forward))
	moves[next_line] = 0
	
	for move in moves:
		if not board.is_position_valid(move, player_color):
			moves.erase(move)


	return moves
