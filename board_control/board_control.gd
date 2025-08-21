extends Node
class_name BoardControl

@export var board_model: BoardModel
@export var player_control: PlayerControl


var playing_player: Globals.PlayerColor = Globals.PlayerColor.WHITE

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

var players = {}

func add_player(id: int, color: Globals.PlayerColor) -> void:
	players[id] = color
	print("Adding player ", id, " of color ", color)

# Untrusted prefix: expect any kind of inputs and that they might be built to deceive you!
# Return True if move was accepted and applied, false otherwise
@rpc("any_peer", "call_local", "reliable", 0)
func untrusted_request_play(
	untrusted_start_board_pos: Vector2i,
	untrusted_end_board_pos: Vector2i,
	) -> bool:
	
	print("PLAYING REQUEST from ", multiplayer.get_remote_sender_id())
	# Only server may update the board
	if not multiplayer.is_server():
		return false
		

	# Player identity might be an issue
	var id = multiplayer.get_remote_sender_id()
	if id not in players:
		return false
	var player_color = players[id]
	if player_color != playing_player:
		return false
	if untrusted_start_board_pos not in board_model.pieces:
		return false
	var untrusted_moving_piece = board_model.pieces[untrusted_start_board_pos]
	
	if not ensure_move_is_valid(untrusted_moving_piece, untrusted_end_board_pos):
		return false
	var moving_piece = untrusted_moving_piece
	var board_pos = untrusted_end_board_pos
	var premove_pos = moving_piece.board_position
	
	# modify board state
	force_move_piece(board_pos, moving_piece)
	
	# update playing player
	change_playing_player()
	
	# send move notification to players
	player_control.update_player_state.rpc(premove_pos, board_pos)
	print("OK PLAYED")
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
	print("Board control created!")
	print("is server? ", multiplayer.is_server())
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
