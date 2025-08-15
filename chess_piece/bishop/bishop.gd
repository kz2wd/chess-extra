extends ChessPiece
class_name ChessBishop


func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.BISHOP)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	var directions = [
		Vector2i(1, 1),    # Down-right
		Vector2i(-1, 1),   # Down-left
		Vector2i(1, -1),   # Up-right
		Vector2i(-1, -1)   # Up-left
	]

	for dir in directions:
		var pos = board_position + dir
		while board.is_position_in_board(pos) and board.is_empty(pos):
			moves[pos] = 0
			pos += dir
		if board.is_position_in_board(pos) and board.contains_enemy(pos, player_color):
			moves[pos] = 0

	return moves
