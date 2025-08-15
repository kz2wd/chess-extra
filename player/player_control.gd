extends Node
class_name PlayerControl

@export var board_model: BoardModel
@export var board_control: BoardControl

@rpc
func update_player_state(piece_that_moved: ChessPiece, position_reached: Vector2i) -> void:
	# update local board
	pass
	
@rpc
func set_board_state(new_board_model: BoardModel) -> void:
	self.board_model = new_board_model
