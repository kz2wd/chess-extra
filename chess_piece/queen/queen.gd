extends ChessPiece
class_name ChessQueen


func initialize(board_pos: Vector2i, player_color: Globals.PlayerColor):
	full_initialize(board_pos, player_color, Globals.PieceType.QUEEN)


func get_move_set(board: BoardModel) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	
	var directions = [
		Vector2i(1, 0), Vector2i(0, 1),
		Vector2i(-1, 0), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, 1),
		Vector2i(-1, -1), Vector2i(1, -1),
	]
	
	var pos
	for dir in directions:
		pos = board_position + dir
		while board.is_position_in_board(pos) and board.is_empty(pos):
			moves[pos] = 0
			pos += dir
		if board.is_position_in_board(pos) and board.contains_enemy(pos, player_color):
			moves[pos] = 0

	return moves
