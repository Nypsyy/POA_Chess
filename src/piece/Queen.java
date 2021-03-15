package piece;

import agent.Move;
import agent.Player;

public class Queen extends Piece {
    public Queen(int player) {
        super(player);
    }

    @Override
    public boolean isMoveLegal(Move mv) {
        Rook r = new Rook();
        Bishop b = new Bishop();

        return r.isMoveLegal(mv) || b.isMoveLegal(mv);
    }

    @Override
    public String toString() {
        return player == Player.WHITE ? "D" : "d";
    }
}
