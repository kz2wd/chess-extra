extends ChessPiece
class_name ChessRook

func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.ROOK)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	
	for i in range(8):
		moves[Vector2i(board_position.x, i)] = 0
		moves[Vector2i(i, board_position.y)] = 0
	
	for move in moves.keys():
		if not board.is_position_valid(move, player_color):
			moves.erase(move)
	return moves
