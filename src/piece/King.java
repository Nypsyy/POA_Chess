package piece;

import agent.Move;
import agent.Player;

public class King extends Piece {
    public King(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        return (Math.abs(mv.xI - mv.xF) <= 1f && Math.abs(mv.yI - mv.yF) <= 1f);
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "R" : "r";
    }
}
