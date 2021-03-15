package piece;

import agent.Move;
import agent.Player;

public class Bishop extends Piece {
    public Bishop() {
    }

    public Bishop(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        float x = mv.xI - mv.xF;
        float y = mv.yI - mv.yF;

        if (x == 0) return false;

        return Math.abs(y / x) == 1f;
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "P" : "p";
    }
}
