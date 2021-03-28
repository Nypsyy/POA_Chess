package agent;

public aspect Validation {
	pointcut MoveValidation(): call(boolean agent.HumanPlayer.makeMove(..));

	boolean around(agent.Move mv): MoveValidation() && args(mv) {
		agent.HumanPlayer hp = ((agent.HumanPlayer) thisJoinPoint.getThis());

		System.out.println("Vérification de votre coup...");
		if (mv == null) {
			System.out.println("Déplacement null.");
			return false;
		} else if (!hp.playGround.getGrid()[mv.xI][mv.yI].isOccupied()) {
			System.out.println("Case inoccupée.");
			return false;
		} else if(hp.playGround.getGrid()[mv.xI][mv.yI].getPiece().getPlayer() == hp.getColor()) {
			System.out.println("Cette pièce ne vous appartient pas.");
			return false;
		} else if (!hp.playGround.getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv)) {
			System.out.println("Mouvement non autorisé.");
			return false;
		}

		hp.playGround.movePiece(mv);
		return true;
	}
}
