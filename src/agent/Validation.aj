package agent;

import piece.Knight;
import piece.Pawn;

public aspect Validation {
    pointcut MoveValidation(): call(boolean agent.HumanPlayer.makeMove(..));
    pointcut PawnMvmnt(): call(boolean piece.Pawn.isMoveLegal(..));

    boolean around(agent.Move mv): PawnMvmnt() && args(mv) {
        Pawn p = (Pawn) thisJoinPoint.getThis();
        boolean ok = false;
        System.out.println(mv.yI + "-" + mv.yF);
        if (p.getPlayer() == Player.WHITE) {
            // Ne peut pas reculer
            if (mv.yF > mv.yI) {
                // Si c'est son premier mouvement, peut avancer de 2 cases
                if (p.firstMove && Math.abs(mv.yF - mv.yI) < 3) {
                    ok = true;
                }

                // Peut avancer tout droit / en diagonale d'une case
                ok = mv.yF - mv.yI == 1 && (Math.abs(mv.xF - mv.xI) == 0 || Math.abs(mv.xF - mv.xI) == 1);
            }

            if (ok && p.firstMove)
                p.firstMove = false;

            return ok;
        }

        if (mv.yF < mv.yI) {
            // Si c'est son premier mouvement, peut avancer de 2 cases
            if (p.firstMove && Math.abs(mv.yF - mv.yI) < 3) {
                ok = true;
            }

            // Peut avancer tout droit / en diagonale d'une case
            ok = mv.yF - mv.yI == -1 && (Math.abs(mv.xF - mv.xI) == 0 || Math.abs(mv.xF - mv.xI) == 1);
        }

        if (ok && p.firstMove)
            p.firstMove = false;

        return ok;
    }

    boolean around(agent.Move mv): MoveValidation() && args(mv) {
        agent.HumanPlayer p = (agent.HumanPlayer) thisJoinPoint.getThis();

        System.out.println("Vérification de votre coup...");
        if (mv == null) {
            System.out.println("Déplacement null.");
            return false;
        } else if (!p.playGround.getGrid()[mv.xI][mv.yI].isOccupied()) {
            System.out.println("Case inoccupée.");
            return false;
        } else if (p.playGround.getGrid()[mv.xI][mv.yI].getPiece().getPlayer() == p.getColor()) {
            System.out.println("Cette pièce ne vous appartient pas.");
            return false;
        } else if (!p.playGround.getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv)) {
            System.out.println("Mouvement non autorisé.");
            return false;
        }

        if (p.playGround.getGrid()[mv.xF][mv.yF].isOccupied() && p.playGround.getGrid()[mv.xF][mv.yF].getPiece().getPlayer()
                == p.playGround.getGrid()[mv.xI][mv.yI].getPiece().getPlayer()) {
            System.out.println("Vous ne pouvez pas manger voter propre pièce !");
            return false;
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

        p.playGround.movePiece(mv);
        return true;
    }
}
