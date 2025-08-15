extends Node
class_name ChessPiece

var board_position: Vector2i
var player_color = Globals.PlayerColor.WHITE
var piece_type: Globals.PieceType


func full_initialize(board_pos: Vector2i, player_color: Globals.PlayerColor, piece_type: Globals.PieceType):
	self.player_color = player_color
	self.board_position = board_pos
	self.piece_type = piece_type

func is_equivalent(untrusted_piece: ChessPiece) -> bool:
	return (
		board_position == untrusted_piece.board_position
		and player_color == untrusted_piece.player_color
		and piece_type == untrusted_piece.piece_type
	)

func get_move_set(_board: BoardModel) -> Dictionary[Vector2i, int]:
	return {}
