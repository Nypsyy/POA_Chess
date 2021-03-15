package piece;

import agent.Move;
import agent.Player;

public class Knight extends Piece {
    public Knight(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        if (Math.abs(mv.xI - mv.xF) == 2f)
            return Math.abs(mv.yI - mv.yF) == 1f;
        else if (Math.abs(mv.xI - mv.xF) == 1f)
            return Math.abs(mv.yI - mv.yF) == 2f;

        return false;
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "C" : "c";
    }
}
