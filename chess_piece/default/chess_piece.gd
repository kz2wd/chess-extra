extends Node2D
class_name ChessPiece

var board_position: Vector2i
var player_color = Globals.PlayerColor.WHITE

@export var WHITE_VISUALS : ShaderMaterial
@export var BLACK_VISUALS : ShaderMaterial


func new(piece_size: Vector2i) -> void:
	var piece_sprite = Sprite2D.new()
	piece_sprite.texture = CanvasTexture.new()
	piece_sprite.scale = Vector2(piece_size)
	piece_sprite.material = WHITE_VISUALS if player_color == Globals.PlayerColor.WHITE else BLACK_VISUALS
	piece_sprite.position = piece_size / 2
	add_child(piece_sprite)

func get_move_set(_board: ChessBoard) -> Dictionary[Vector2i, int]:
	return {}
