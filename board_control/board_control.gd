extends Node
class_name BoardControl

@export var board_model: BoardModel

var playing_player: Globals.PlayerColor = Globals.PlayerColor.WHITE

@export var player_one: PlayerControl
@export var player_two: PlayerControl

func get_player_control(player_color: Globals.PlayerColor) -> PlayerControl:
	if player_color == Globals.PlayerColor.WHITE:
		return player_one
	return player_two
	
func get_current_player_control() -> PlayerControl:
	return get_player_control(playing_player)

func change_playing_player() -> void:
	if playing_player == Globals.PlayerColor.WHITE:
		playing_player = Globals.PlayerColor.BLACK
	else:
		playing_player = Globals.PlayerColor.WHITE

func ensure_piece_is_valid(untrusted_moving_piece: ChessPiece) -> bool:
	if untrusted_moving_piece.board_position in board_model.pieces:
		var existing_piece = board_model.pieces[untrusted_moving_piece.board_position]
		return existing_piece.is_equivalent(untrusted_moving_piece)
	return false

func ensure_move_is_valid(
	untrusted_moving_piece: ChessPiece, 
	untrusted_board_pos: Vector2i) -> bool:
		# Ensure player is playing its piece
		if untrusted_moving_piece.player_color != playing_player:
			return false
		# Ensure the piece is valid
		if not ensure_piece_is_valid(untrusted_moving_piece):
			return false
		var moving_piece = untrusted_moving_piece
		
		# Ensure the moving position is available
		if not untrusted_board_pos in moving_piece.get_move_set(board_model):
			return false
			
		var board_pos = untrusted_board_pos
		return true

# Untrusted prefix: expect any kind of inputs and that they might be built to deceive you!
# Return True if move was accepted and applied, false otherwise
@rpc
func untrusted_request_play(
	untrusted_player: PlayerControl, 
	untrusted_moving_piece: ChessPiece, 
	untrusted_board_pos: Vector2i
	) -> bool:
	# Player identity might be an issue
	
	if untrusted_player.player_color != playing_player:
		return false
	
	if not ensure_move_is_valid(untrusted_moving_piece, untrusted_board_pos):
		return false
	var moving_piece = untrusted_moving_piece
	var board_pos = untrusted_board_pos
	
	# modify board state
	force_move_piece(board_pos, moving_piece)
	
	# update playing player
	change_playing_player()
	
	# send move notification to other player
	get_current_player_control().update_player_state(moving_piece, board_pos)
	
	return true


func force_put_piece(board_pos: Vector2i, piece: ChessPiece, emit_signal=true):
	board_model.pieces[board_pos] = piece
	piece.board_position = board_pos
	if emit_signal:
		board_model.board_changed.emit()
	
func force_move_piece(board_pos: Vector2i, piece: ChessPiece, emit_signal=true):
	board_model.pieces.erase(piece.board_position)
	force_put_piece(board_pos, piece, emit_signal)
	

func _ready() -> void:
	place_pieces()

func add_piece(type: Object, player_color: Globals.PlayerColor, board_pos: Vector2i) -> void:
	var piece = type.new()
	piece.initialize(board_pos, player_color)
	add_child(piece)
	force_put_piece(board_pos, piece, false)

func place_pieces() -> void:
	for i in range(board_model.board_size.x):
		add_piece(ChessPawn, Globals.PlayerColor.BLACK, Vector2i(i, 1))
		add_piece(ChessPawn, Globals.PlayerColor.WHITE, Vector2i(i, 6))
	
	add_piece(ChessRook, Globals.PlayerColor.BLACK, Vector2i(0, 0))
	add_piece(ChessRook, Globals.PlayerColor.BLACK, Vector2i(7, 0))
	add_piece(ChessRook, Globals.PlayerColor.WHITE, Vector2i(0, 7))
	add_piece(ChessRook, Globals.PlayerColor.WHITE, Vector2i(7, 7))
	
	add_piece(ChessKnight, Globals.PlayerColor.BLACK, Vector2i(1, 0))
	add_piece(ChessKnight, Globals.PlayerColor.WHITE, Vector2i(6, 7))
	add_piece(ChessKnight, Globals.PlayerColor.BLACK, Vector2i(6, 0))
	add_piece(ChessKnight, Globals.PlayerColor.WHITE, Vector2i(1, 7))
	
	add_piece(ChessBishop, Globals.PlayerColor.BLACK, Vector2i(2, 0))
	add_piece(ChessBishop, Globals.PlayerColor.WHITE, Vector2i(5, 7))
	add_piece(ChessBishop, Globals.PlayerColor.BLACK, Vector2i(5, 0))
	add_piece(ChessBishop, Globals.PlayerColor.WHITE, Vector2i(2, 7))
	
	add_piece(ChessQueen, Globals.PlayerColor.BLACK, Vector2i(3, 0))
	add_piece(ChessQueen, Globals.PlayerColor.WHITE, Vector2i(3, 7))
	add_piece(ChessKing, Globals.PlayerColor.BLACK, Vector2i(4, 0))
	add_piece(ChessKing, Globals.PlayerColor.WHITE, Vector2i(4, 7))
