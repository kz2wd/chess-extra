extends ChessPiece
class_name ChessKnight


func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.KNIGHT)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves: Dictionary[Vector2i, int] = {}
	var offsets = [
		Vector2i(2, 1), Vector2i(1, 2),
		Vector2i(-1, 2), Vector2i(-2, 1),
		Vector2i(-2, -1), Vector2i(-1, -2),
		Vector2i(1, -2), Vector2i(2, -1)
	]

	for offset in offsets:
		var pos = board_position + offset
		if board.is_position_valid(pos, player_color) and not board.contains_ally(pos, player_color):
			moves[pos] = 0

	return moves
