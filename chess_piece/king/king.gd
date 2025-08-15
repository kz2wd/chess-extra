extends ChessPiece
class_name ChessKing


func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.KING)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, 1),
		Vector2i(1, -1), Vector2i(-1, -1)
	]

	for dir in directions:
		var pos = board_position + dir
		if board.is_position_valid(pos, player_color):
			moves[pos] = 0

	return moves
