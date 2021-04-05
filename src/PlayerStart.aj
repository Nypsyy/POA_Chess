import agent.AiPlayer;
import agent.HumanPlayer;
import agent.Player;
import main.Board;
import main.Chess;
import main.Spot;
import piece.*;

public aspect PlayerStart {
	pointcut UpdatePlayerColor(): call(void main.Chess.play());
	pointcut UpdateChessBoard(): call(void main.Board.setupChessBoard());

	void around(): UpdatePlayerColor() {
		System.out.println("UpdatePlayerColor()");
		Chess chess = (Chess) thisJoinPoint.getTarget();
		Board board = chess.getBoard();

		Player hp = new HumanPlayer(Player.WHITE, board);
		Player ap = new AiPlayer(Player.BLACK, board);

		boolean isAIKingAlive;
		boolean isPlayerKingAlive;

		while (true) {
			board.print();
			hp.makeMove();
			board.print();
			ap.makeMove();

			isAIKingAlive = false;
			isPlayerKingAlive = false;

			for (int y = 0; y < Board.SIZE; y++) {
				for (int x = 0; x < Board.SIZE; x++) {
					if (board.getGrid()[x][y].isOccupied() && board.getGrid()[x][y].getPiece().getClass() == King.class) {
						if (board.getGrid()[x][y].getPiece().getPlayer() == Player.WHITE)
							isPlayerKingAlive = true;
						else
							isAIKingAlive = true;
					}
				}
			}

			if (!isPlayerKingAlive || !isAIKingAlive) {
				System.out.println("Victoire du joueur " + (isAIKingAlive ? "IA" : "Humain"));
				return;
			}
		}
	}

	void around(): UpdateChessBoard() {
		System.out.println("UpdateChessBoard()");
		Board board = (Board) thisJoinPoint.getTarget();
		Spot[][] grid = board.getGrid();

		for (int x = 0; x < Board.SIZE; x++) {
			grid[x][1].setPiece(new Pawn(Player.BLACK));
			grid[x][6].setPiece(new Pawn(Player.WHITE));
		}

		for (int x = 2; x < 8; x += 3) {
			grid[x][0].setPiece(new Bishop(Player.BLACK));
			grid[x][7].setPiece(new Bishop(Player.WHITE));
		}

		for (int x = 1; x < 8; x += 5) {
			grid[x][0].setPiece(new Knight(Player.BLACK));
			grid[x][7].setPiece(new Knight(Player.WHITE));
		}

		for (int x = 0; x < 8; x += 7) {
			grid[x][0].setPiece(new Rook(Player.BLACK));
			grid[x][7].setPiece(new Rook(Player.WHITE));
		}

		grid[3][0].setPiece(new Queen(Player.BLACK));
		grid[3][7].setPiece(new Queen(Player.WHITE));

		grid[4][0].setPiece(new King(Player.BLACK));
		grid[4][7].setPiece(new King(Player.WHITE));
	}
}
