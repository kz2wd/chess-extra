extends Node2D
class_name ChessBoard


var pieces: Dictionary[Vector2i, ChessPiece]

	
@export_group("Board")
@export var piece_size: Vector2i = Vector2i(64, 64)
@export var board_size: Vector2i = Vector2i(8, 8)

@export var SQUARE_ONE = preload("res://chess_board/square_one.tscn")
@export var SQUARE_TWO = preload("res://chess_board/square_two.tscn")

func board_index_1d(board_pos: Vector2i) -> int:
	return board_pos.x + board_pos.y * board_size.x
	
func max_board_index_1d() -> int:
	return board_size.x * board_size.y - 1

func to_world_pos(board_pos: Vector2i) -> Vector2:
	return Vector2(piece_size * board_pos)

func force_put_piece(board_pos: Vector2i, piece: ChessPiece):
	pieces[board_pos] = piece
	piece.position = board_pos * piece_size
	piece.board_position = board_pos
	
func force_move_piece(board_pos: Vector2i, piece: ChessPiece):
	pieces.erase(piece.board_position)
	force_put_piece(board_pos, piece)


func build_board() -> void:
	# build board
	for i in range(board_size.x):
		for j in range(board_size.y):
			var board_pos = Vector2i(i, j)
			var current_square = SQUARE_ONE if (i + j) % 2 == 0 else SQUARE_TWO
			var square = current_square.instantiate()
			add_child(square)
			square.position = board_pos * piece_size

@export_group("Pieces")
const PAWN = preload("res://chess_piece/pawn/pawn.tscn")
const ROOK = preload("res://chess_piece/rook/Rook.tscn")

func add_piece(type: PackedScene, player_color: Globals.PlayerColor, board_pos: Vector2i) -> void:
	var piece = type.instantiate()
	piece.player_color = player_color
	piece.new(piece_size)
	add_child(piece)
	force_put_piece(board_pos, piece)

func place_pieces() -> void:
	for i in range(board_size.x):
		add_piece(PAWN, Globals.PlayerColor.BLACK, Vector2i(i, 1))
	
	add_piece(ROOK, Globals.PlayerColor.BLACK, Vector2i(0, 0))
	add_piece(ROOK, Globals.PlayerColor.BLACK, Vector2i(7, 0))

func _init() -> void:
	build_board()
	place_pieces()
	
			
func screen_pos_to_board_pos(screen_pos: Vector2) -> Vector2i:
	var local_screen_pos := screen_pos - position
	var board_pos := Vector2i((local_screen_pos / Vector2(piece_size)).floor())
	return board_pos	
	
	 
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

func select_on_world(board_pos: Vector2i):
	if not is_position_in_board(board_pos):
		unselect_all()
		return

	if not audio_stream_player.playing:
		audio_stream_player.stream = SELECT
		audio_stream_player.play()
		
	if selected_piece != null:
		# try move!
		var moves = selected_piece.get_move_set(self)
		if board_pos in moves:
			# move is valid!
			force_move_piece(board_pos, selected_piece)
			unselect_all()
			return
		
	set_visor_on_board_pos(board_pos)
	if board_pos in pieces:
		selected_piece = pieces[board_pos]
		var moves = selected_piece.get_move_set(self)
		preview_moves(moves)
	else:
		unselect()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index != 1:
			return
		var board_pos := screen_pos_to_board_pos(event.position)
		select_on_world(board_pos)
			

func is_position_in_board(board_pos: Vector2i) -> bool:
	return board_pos.x >= 0 and board_pos.y >= 0 and board_pos.x < board_size.x and board_pos.y < board_size.y

func is_position_available(board_pos: Vector2i, playing_piece_color: Globals.PlayerColor) -> bool:
	if not board_pos in pieces:
		return true
	return pieces[board_pos].player_color != playing_piece_color

func is_position_valid(board_pos: Vector2i, playing_piece_color: Globals.PlayerColor) -> bool:
	return is_position_in_board(board_pos) and is_position_available(board_pos, playing_piece_color)
