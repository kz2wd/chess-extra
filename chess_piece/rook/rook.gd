extends ChessPiece
class_name ChessRook

func get_move_set(board: ChessBoard) -> Dictionary[Vector2i, int]:
	var moves : Dictionary[Vector2i, int] = {}
	
	for i in range(8):
		moves[Vector2i(board_position.x, i)] = 0
		moves[Vector2i(i, board_position.y)] = 0
	
	print(len(moves))
	for move in moves.keys():
		if not board.is_position_valid(move, player_color):
			moves.erase(move)
	print(len(moves))
	return moves
