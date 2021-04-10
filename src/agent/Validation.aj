package agent;

import main.Board;
import piece.Knight;
import piece.Pawn;
import piece.Piece;

public aspect Validation {
    pointcut MoveValidation(): call(boolean Player+.makeMove(..));
    pointcut IsPawnMoveLegal(): execution(boolean Pawn.isMoveLegal(..));

    // Englobe l'appel à la méthode Pawn.isMoveLegal pour éditer les mouvements autorisés par le pion
    boolean around(Move mv): IsPawnMoveLegal() && args(mv) {
        System.out.println("Vérification du pion");
        Pawn p = (Pawn) thisJoinPoint.getTarget();
        boolean valid = false;

        // Pour le joueur blanc, ne peut pas descendre
        // Pour le joueur noir, ne peut pas monter
        if ((p.getPlayer() == Player.WHITE && mv.yF < mv.yI) || (p.getPlayer() == Player.BLACK && mv.yF > mv.yI)) {
            // S'il s'agit du premier déplacement du pion
            // Le déplacement sera valide s'il avance de 1 à 2 cases ou s'il se déplace d'une case en diagonale
            if (p.firstMove)
                valid = (Math.abs(mv.yF - mv.yI) < 3 && mv.xF - mv.xI == 0) || (Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1);
            // Le déplacement sera valide s'il avance de 1 case ou s'il se déplace d'une case en diagonale
            else
                valid = Math.abs(mv.yF - mv.yI) == 1 && Math.abs(mv.xF - mv.xI) <= 1;
        }

        return valid;
    }

    // Englobe l'appel à la méthode Player.makeMove pour ajouter des règles de déplacement
    boolean around(Move mv): MoveValidation() && args(mv) {
        System.out.println("Validation du déplacement");
        Player p = (Player) thisJoinPoint.getTarget();
        Board board = p.playGround;

        // Pour un mouvement null
        if (mv == null) {
            System.out.println("Déplacement null.");
            return false;
        }
        // Vérifie que la position initiale saisie ne soit pas en dehors du plateau
        if (mv.xI < 0 || mv.xI >= Board.SIZE || mv.yI < 0 || mv.yI >= Board.SIZE) {
            System.out.println("Sélection hors du plateau.");
            return false;
        }
        // Vérifie que la position finale saisie ne soit pas en dehors du plateau
        if (mv.xF < 0 || mv.xF >= Board.SIZE || mv.yF < 0 || mv.yF >= Board.SIZE) {
            System.out.println("Destination hors du plateau.");
            return false;
        }
        // Vérifie que la case ne soit pas occupée
        if (!board.getGrid()[mv.xI][mv.yI].isOccupied()) {
            System.out.println("Case inoccupée.");
            return false;
        }

		Piece selectedPiece = board.getGrid()[mv.xI][mv.yI].getPiece();

        // Vérifie que la pièce appartienne au joueur
        if (selectedPiece.getPlayer() != p.getColor()) {
            System.out.println("Cette pièce ne vous appartient pas.");
            return false;
        }
        // Si le mouvement est autorisé par la pièce
        if (!selectedPiece.isMoveLegal(mv)) {
            System.out.println("Mouvement non autorisé.");
            return false;
        }
        // Vérifie que la pièce sur la case finale ne soit pas un pion qui lui appartienne
        if (board.getGrid()[mv.xF][mv.yF].isOccupied() && selectedPiece.getPlayer() == board.getGrid()[mv.xF][mv.yF].getPiece().getPlayer()) {
            System.out.println("Vous ne pouvez pas manger votre propre pièce !");
            return false;
        }

        // Vérifie s'il y a une pièce entre le départ et l'arrivée (sauf pour le cavalier)
        if (selectedPiece.getClass() != Knight.class) {
            System.out.println("Vérification des obstructions...");
            int x = mv.xF;
            int y = mv.yF;

            // Pour chaque case entre la position initiale et finale
            while (x != mv.xI || y != mv.yI) {
                // Incrémente ou décrémente x
                if (x > mv.xI)
                    x--;
                else if (x < mv.xI)
                    x++;

                // Incrémente ou décrémente y
                if (y > mv.yI)
                    y--;
                else if (y < mv.yI)
                    y++;

                // Vérifie que la case soit inoccupée
                if ((x != mv.xI || y != mv.yI) && board.getGrid()[x][y].isOccupied()) {
                    System.out.println("Vous ne pouvez pas vous déplacer par dessus une autre pièce !");
                    return false;
                }
            }
        }
        // Pour un pion
        if (selectedPiece.getClass() == Pawn.class) {
            // Si le pion avance mais qu'il y a quelqu'un en face de lui
            if (board.getGrid()[mv.xF][mv.yF].isOccupied() && mv.xF == mv.xI) {
                System.out.println("Le pion est bloqué par une autre pièce !");
                return false;
            // Si le pion avance en diagonale mais qu'il n'y a aucun autre pion adverse
            } else if (!board.getGrid()[mv.xF][mv.yF].isOccupied() && mv.xF != mv.xI) {
                System.out.println("Le pion ne mange personne !");
                return false;
            }

            // Si le mouvement est correct et qu'il s'agit du premier coup pour ce pion, mettre à jour son statut
            if (((Pawn) selectedPiece).firstMove)
                ((Pawn) selectedPiece).firstMove = false;
        }

        // Déplace la pièce
        board.movePiece(mv);
        return true;
    }
}
