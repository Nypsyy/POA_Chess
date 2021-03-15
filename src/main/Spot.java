package main;

import piece.Piece;

import java.util.Objects;

public class Spot {
    private boolean occupied;
    private Piece piece;
    private int xPos, yPos;

    public Spot(int x, int y) {
        xPos = x;
        yPos = y;
        setOccupied(false);
    }

    public Spot(int x, int y, Piece p) {
        xPos = x;
        yPos = y;
        setPiece(p);
    }

    public void release() {
        setPiece(null);
        setOccupied(false);
    }

    public boolean isOccupied() {
        return occupied;
    }

    public void setOccupied(boolean occupied) {
        this.occupied = occupied;
    }

    public Piece getPiece() {
        return piece;
    }

    public void setPiece(Piece piece) {
        this.piece = piece;
        setOccupied(true);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Spot spot = (Spot) o;
        return xPos == spot.xPos && yPos == spot.yPos;
    }

    @Override
    public int hashCode() {
        return Objects.hash(occupied, piece, xPos, yPos);
    }

    @Override
    public String toString() {
        return "Spot{}";
    }
}
