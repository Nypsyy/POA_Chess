package piece;

import agent.Move;
import agent.Player;

public class Rook extends Piece {
    public Rook() {
    }

    public Rook(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        return mv.yI - mv.yF == 0 || mv.xI - mv.xF == 0;
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "T" : "t";
    }
}
