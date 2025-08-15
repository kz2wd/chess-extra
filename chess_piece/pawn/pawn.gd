extends ChessPiece
class_name ChessPawn


func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.PAWN)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves: Dictionary[Vector2i, int] = {}

	var starting_line: int = 6 if player_color == Globals.PlayerColor.WHITE else 1
	var forward: int = -1 if player_color == Globals.PlayerColor.WHITE else 1

	# Forward one step
	var pos = board_position + Vector2i(0, forward)
	if board.is_position_valid(pos, player_color) and board.is_empty(pos):
		moves[pos] = 0

		# Forward two steps from starting position
		if board_position.y == starting_line:
			var pos2 = board_position + Vector2i(0, 2 * forward)
			if board.is_position_in_board(pos2) and board.is_empty(pos2):
				moves[pos2] = 0

	# Diagonal captures
	for dx in [-1, 1]:
		pos = board_position + Vector2i(dx, forward)
		if board.is_position_in_board(pos) and board.contains_enemy(pos, player_color):
			moves[pos] = 0

	return moves
