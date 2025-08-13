extends Node2D
class_name ChessPiece

var board_position: Vector2i
var player_color = Globals.PlayerColor.WHITE

func get_move_set(board: ChessBoard) -> Dictionary[Vector2i, int]:
	return {}
