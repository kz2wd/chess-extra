extends Node2D
class_name BoardView


@export var board_model: BoardModel
@export var board_control: BoardControl

@export_group("Board")
@export var piece_size: Vector2i = Vector2i(64, 64)

@export var SQUARE_ONE = preload("res://chess_board/square_one.tscn")
@export var SQUARE_TWO = preload("res://chess_board/square_two.tscn")

@export_group("Pieces")
@export var piece_visuals: Dictionary[Globals.PieceType, PackedScene] = {
	Globals.PieceType.PAWN: preload("res://chess_piece/pawn/pawn.tscn"),
	Globals.PieceType.ROOK: preload("res://chess_piece/rook/Rook.tscn"),
	Globals.PieceType.KNIGHT: preload("res://chess_piece/knight/knight.tscn"),
	Globals.PieceType.BISHOP: preload("res://chess_piece/bishop/bishop.tscn"),
	Globals.PieceType.QUEEN: preload("res://chess_piece/queen/queen.tscn"),
	Globals.PieceType.KING: preload("res://chess_piece/king/king.tscn"),
}

@export var missing_visual = preload("res://chess_piece/default/missing_piece.tscn")

signal on_move_request(piece: ChessPiece, board_pos: Vector2i)

@onready var piece_container: Node2D = $PieceContainer
@onready var tile_container: Node2D = $TileContainer


func update_visuals() -> void:
	for child in piece_container.get_children():
		child.queue_free()
	for board_pos in board_model.pieces.keys():
		var current_piece: ChessPiece = board_model.pieces[board_pos]
		var world_pos = to_world_pos(board_pos)
		if not current_piece.piece_type in piece_visuals:
			var missing = missing_visual.instantiate()
			piece_container.add_child(missing)
			missing.position = world_pos
			continue
		var visual_instance: ChessPieceVisual = piece_visuals[current_piece.piece_type].instantiate()
		piece_container.add_child(visual_instance)
		visual_instance.new(world_pos, piece_size, current_piece.player_color)
		

func to_world_pos(board_pos: Vector2i) -> Vector2:
	return Vector2(piece_size * board_pos)

func build_board() -> void:
	# build board
	for i in range(board_model.board_size.x):
		for j in range(board_model.board_size.y):
			var board_pos = Vector2i(i, j)
			var current_square = SQUARE_ONE if (i + j) % 2 == 0 else SQUARE_TWO
			var square = current_square.instantiate()
			tile_container.add_child(square)
			square.position = board_pos * piece_size


func _ready() -> void:
	build_board()
	update_visuals()
	board_model.board_changed.connect(update_visuals)
	

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const SELECT = preload("res://chess_board/select.wav")


@onready var visor: Node2D = $Visor

func hide_visor() -> void:
	visor.visible = false

func set_visor_on_board_pos(pos: Vector2i) -> void:
	visor.visible = true
	visor.position = to_world_pos(pos)

@onready var move_preview: MultiMeshInstance2D = $MovePreview

func preview_moves(moves: Dictionary[Vector2i, int]) -> void:
	var index := 0
	var instance_count = len(moves)
	move_preview.multimesh.instance_count = instance_count
	move_preview.multimesh.visible_instance_count = instance_count
	for move in moves:
		move_preview.multimesh.set_instance_transform_2d(index, Transform2D(0, to_world_pos(move)))
		index += 1

func hide_move_preview() -> void:
	move_preview.multimesh.instance_count = 0
	move_preview.multimesh.visible_instance_count = 0

var selected_piece = null

func unselect_all() -> void:
	unselect()
	hide_visor()
	
func unselect() -> void:
	hide_move_preview()
	selected_piece = null

func select_on_world(board_pos: Vector2i, as_player: Globals.PlayerColor):
	if not board_model.is_position_in_board(board_pos):
		unselect_all()
		return

	if not audio_stream_player.playing:
		audio_stream_player.stream = SELECT
		audio_stream_player.play()
		
	if selected_piece != null:
		# try move!
		var moves = selected_piece.get_move_set(board_model)
		if board_pos in moves:
			# move is valid!
			
			on_move_request.emit(selected_piece, board_pos)
			unselect_all()
			return
		
	set_visor_on_board_pos(board_pos)
	if board_pos in board_model.pieces.keys():
		selected_piece = board_model.pieces[board_pos]
		
		if selected_piece.player_color != as_player:
			unselect()
			return
		
		var moves = selected_piece.get_move_set(board_model)
		preview_moves(moves)
	else:
		unselect()
