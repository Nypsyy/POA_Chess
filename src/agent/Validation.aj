package agent;

import main.Board;
import piece.Knight;
import piece.Pawn;

public aspect Validation {
	pointcut MoveValidation(): call(boolean Player+.makeMove(..));
	pointcut IsPawnMoveLegal(): execution(boolean Pawn.isMoveLegal(..));

	boolean around(Move mv): IsPawnMoveLegal() && args(mv) {
		System.out.println("IsPawnMoveLegal()");
		Pawn p = (Pawn) thisJoinPoint.getTarget();
		boolean valid = false;

		if (p.getPlayer() == Player.WHITE) {
			// Ne peut pas reculer
			if (mv.yF < mv.yI) {
				if (p.firstMove)
					valid = (Math.abs(mv.yF - mv.yI) < 3 && mv.xF - mv.xI == 0) || (Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1);
				else
					valid =  Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1;
			}

			if (valid && p.firstMove)
				p.firstMove = false;

			return valid;
		}

		if (mv.yF > mv.yI) {
			// Si c'est son premier mouvement, peut avancer de 2 cases
			//valid = p.firstMove && Math.abs(mv.yF - mv.yI) < 3;
			// Peut avancer tout droit / en diagonale d'une case
			//if (!valid)
				//valid = Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1;

			if (p.firstMove)
				valid = (Math.abs(mv.yF - mv.yI) < 3 && mv.xF - mv.xI == 0) || (Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1);
			else
				valid =  Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1;
		}

		if (valid && p.firstMove)
			p.firstMove = false;

		return valid;
	}

	boolean around(Move mv): MoveValidation() && args(mv) {
		System.out.println("MoveValidation()");
		Player p = (Player) thisJoinPoint.getTarget();
		Board board = p.playGround;

		if(mv == null) {
			System.out.println("Déplacement null.");
			return false;
		}
		if (mv.xI < 0 || mv.xI >= Board.SIZE || mv.yI < 0 || mv.yI >= Board.SIZE) {
			System.out.println("Sélection hors du plateau.");
			return false;
		}
		if (mv.xF < 0 || mv.xF >= Board.SIZE || mv.yF < 0 || mv.yF >= Board.SIZE) {
			System.out.println("Destination hors du plateau.");
			return false;
		}
		if (!board.getGrid()[mv.xI][mv.yI].isOccupied()) {
			System.out.println("Case inoccupée.");
			return false;
		}
		if (board.getGrid()[mv.xI][mv.yI].getPiece().getPlayer() != p.getColor()) {
			System.out.println("Cette pièce ne vous appartient pas.");
			return false;
		}
		if (!board.getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv)) {
			System.out.println("Mouvement non autorisé.");
			return false;
		}
		if (p.playGround.getGrid()[mv.xF][mv.yF].isOccupied() && board.getGrid()[mv.xI][mv.yI].getPiece().getPlayer() == board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer()) {
			System.out.println("Vous ne pouvez pas manger votre propre pièce !");
			return false;
		}
		if (p.playGround.getGrid()[mv.xI][mv.yI].getPiece().getClass() != Knight.class) {
			System.out.println("Vérification des obstructions...");
			int x = mv.xF;
			int y = mv.yF;

			while (x != mv.xI || y != mv.yI) {
				if (x > mv.xI)
					x--;
				else if (x < mv.xI)
					x++;

				if (y > mv.yI)
					y--;
				else if (y < mv.yI)
					y++;

				if ((x != mv.xI || y != mv.yI) && p.playGround.getGrid()[x][y].isOccupied()) {
					System.out.println("Vous ne pouvez pas vous déplacer par dessus une autre pièce !");
					return false;
				}
			}
		}
		if (p.playGround.getGrid()[mv.xI][mv.yI].getPiece().getClass() == Pawn.class) {
			if (p.playGround.getGrid()[mv.xF][mv.yF].isOccupied() && mv.xF == mv.xI) {
				System.out.println("Le pion est bloqué par une autre pièce !");
				return false;
			} else if (!p.playGround.getGrid()[mv.xF][mv.yF].isOccupied() && mv.xF != mv.xI) {
				System.out.println("Le pion ne mange personne !");
				return false;
			}
		}

		p.playGround.movePiece(mv);
		return true;
	}
}
