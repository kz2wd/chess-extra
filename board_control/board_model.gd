extends Node
class_name BoardModel

@export var board_size: Vector2i = Vector2i(8, 8)

var pieces: Dictionary[Vector2i, ChessPiece]

signal board_changed

func board_index_1d(board_pos: Vector2i) -> int:
	return board_pos.x + board_pos.y * board_size.x
	
func max_board_index_1d() -> int:
	return board_size.x * board_size.y - 1


func is_position_in_board(board_pos: Vector2i) -> bool:
	return board_pos.x >= 0 and board_pos.y >= 0 and board_pos.x < board_size.x and board_pos.y < board_size.y

func is_position_available(board_pos: Vector2i, playing_piece_color: Globals.PlayerColor) -> bool:
	if not board_pos in pieces:
		return true
	return pieces[board_pos].player_color != playing_piece_color

func is_position_valid(board_pos: Vector2i, playing_piece_color: Globals.PlayerColor) -> bool:
	return is_position_in_board(board_pos) and is_position_available(board_pos, playing_piece_color)

func is_empty(board_pos: Vector2i) -> bool:
	return not board_pos in pieces

func contains_enemy(board_pos: Vector2i, playing_piece_color: Globals.PlayerColor):
	if not board_pos in pieces:
		return false
	return pieces[board_pos].player_color != playing_piece_color
