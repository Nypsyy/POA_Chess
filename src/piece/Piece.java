package piece;

import agent.Move;

public abstract class Piece {
    public abstract boolean isMoveLegal(Move mv);

    public abstract String toString();

    protected int player;

    public Piece() {
    }

    public Piece(int player) {
        setPlayer(player);
    }

    public void print() {
        System.out.println(this.toString());
    }

    public Object clone() {
        try {
            return super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getPlayer() {
        return player;
    }

    public void setPlayer(int player) {
        this.player = player;
    }
}
