package piece;

import agent.Move;
import agent.Player;

public class Pawn extends Piece {
    public Pawn(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        boolean special = false;

        // Player 1
        if (player == Player.WHITE) {
            if (Math.abs(mv.xF - mv.xI) == 0f && Math.abs(mv.yF - mv.yI) < 3f)
                special = true;
            return mv.yF - mv.yI == 1 && Math.abs(mv.xF - mv.xI) <= 1 || special;
        }
        // Player 2
        if (Math.abs(mv.xF - mv.xI) == 0f && Math.abs(mv.yF - mv.yI) < 3f)
            special = true;
        return mv.yF - mv.yI == -1 && Math.abs(mv.xF - mv.xI) <= 1f || special;
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "P" : "p";
    }
}
