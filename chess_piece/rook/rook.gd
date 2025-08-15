extends ChessPiece
class_name ChessRook

func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.ROOK)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	var directions = [
		Vector2i(1, 0),   # Right
		Vector2i(-1, 0),  # Left
		Vector2i(0, 1),   # Down
		Vector2i(0, -1)   # Up
	]

	for dir in directions:
		var pos = board_position + dir
		while board.is_position_in_board(pos) and board.is_empty(pos):
			moves[pos] = 0
			pos += dir
		# If the first non-empty square is enemy, add it
		if board.is_position_in_board(pos) and board.contains_enemy(pos, player_color):
			moves[pos] = 0

	return moves
