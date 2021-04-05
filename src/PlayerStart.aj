import agent.AiPlayer;
import agent.HumanPlayer;
import agent.Player;
import main.Board;
import main.Chess;
import main.Spot;
import piece.*;

public aspect PlayerStart {
	pointcut UpdatePlayerColor(): call(void Chess.play());
	pointcut UpdateChessBoard(): call(void Board.setupChessBoard());

	// Englobe l'appel à la méthode Chess.play() pour éditer la couleur des joueurs et ajouter une condition de fin
	void around(): UpdatePlayerColor() {
		System.out.println("Lancement de la boucle de jeu");
		Chess chess = (Chess) thisJoinPoint.getTarget();
		Board board = chess.getBoard();

		// Le joueur humain prend les pions blancs et l'IA les pions noirs
		Player hp = new HumanPlayer(Player.WHITE, board);
		Player ap = new AiPlayer(Player.BLACK, board);

		boolean isAIKingAlive;
		boolean isPlayerKingAlive;

		while (true) {
			// Affiche le plateau
			board.print();
			// Demande à l'humain d'effectuer un mouvement
			hp.makeMove();
			board.print();
			// Effectuer le mouvement de l'IA
			ap.makeMove();

			isAIKingAlive = false;
			isPlayerKingAlive = false;

			// Parcourt chaque case du plateau
			for (int y = 0; y < Board.SIZE; y++) {
				for (int x = 0; x < Board.SIZE; x++) {
					if (board.getGrid()[x][y].isOccupied() && board.getGrid()[x][y].getPiece().getClass() == King.class) {
						// Le roi du joueur humain est vivant
						if (board.getGrid()[x][y].getPiece().getPlayer() == Player.WHITE)
							isPlayerKingAlive = true;
						// Le roi de l'IA est vivant
						else
							isAIKingAlive = true;
					}
				}
			}

			// Condition d'arrêt si un des deux rois est mort
			if (!isPlayerKingAlive || !isAIKingAlive) {
				System.out.println("Victoire du joueur " + (isAIKingAlive ? "IA" : "Humain"));
				return;
			}
		}
	}

	// Englobe l'appel à la méthode Board.setupChessBoard pour changer la position initiale des pièces
	void around(): UpdateChessBoard() {
		System.out.println("Initialisation du plateau");
		Board board = (Board) thisJoinPoint.getTarget();
		Spot[][] grid = board.getGrid();

		// Ajoute les pions
		for (int x = 0; x < Board.SIZE; x++) {
			grid[x][1].setPiece(new Pawn(Player.BLACK));
			grid[x][6].setPiece(new Pawn(Player.WHITE));
		}

		// Ajoute les fous
		for (int x = 2; x < 8; x += 3) {
			grid[x][0].setPiece(new Bishop(Player.BLACK));
			grid[x][7].setPiece(new Bishop(Player.WHITE));
		}

		// Ajoute les cavaliers
		for (int x = 1; x < 8; x += 5) {
			grid[x][0].setPiece(new Knight(Player.BLACK));
			grid[x][7].setPiece(new Knight(Player.WHITE));
		}

		// Ajoute les tours
		for (int x = 0; x < 8; x += 7) {
			grid[x][0].setPiece(new Rook(Player.BLACK));
			grid[x][7].setPiece(new Rook(Player.WHITE));
		}

		// Ajoute les reines
		grid[3][0].setPiece(new Queen(Player.BLACK));
		grid[3][7].setPiece(new Queen(Player.WHITE));

		// Ajoute les rois
		grid[4][0].setPiece(new King(Player.BLACK));
		grid[4][7].setPiece(new King(Player.WHITE));
	}
}
