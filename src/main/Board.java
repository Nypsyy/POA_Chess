package main;

import agent.Move;
import agent.Player;
import piece.*;

public class Board {
    private Spot[][] grid;

    public static final int SIZE = 8;

    public Board() {
        grid = new Spot[SIZE][SIZE];

        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                grid[j][i] = new Spot(j, i);
                grid[j][i].setOccupied(false);
            }
        }
    }

    public void setupChessBoard() {
        for (int i = 0; i < SIZE; i++) {
            grid[i][1].setPiece(new Pawn(Player.BLACK));
            grid[i][6].setPiece(new Pawn(Player.WHITE));
        }

        for (int i = 2; i < SIZE; i += 3) {
            grid[i][0].setPiece(new Bishop(Player.BLACK));
            grid[i][7].setPiece(new Bishop(Player.WHITE));
        }

        for (int i = 1; i < SIZE; i += 5) {
            grid[i][0].setPiece(new Knight(Player.BLACK));
            grid[i][7].setPiece(new Knight(Player.WHITE));
        }
        for (int i = 0; i < SIZE; i += 7) {
            grid[i][0].setPiece(new Rook(Player.BLACK));
            grid[i][7].setPiece(new Rook(Player.WHITE));
        }

        grid[3][0].setPiece(new Queen(Player.BLACK));
        grid[3][7].setPiece(new Queen(Player.WHITE));

        grid[4][0].setPiece(new King(Player.BLACK));
        grid[4][7].setPiece(new King(Player.WHITE));
    }

    public void movePiece(Move mv) {
        grid[mv.xF][mv.yF].setPiece(grid[mv.xI][mv.yI].getPiece());
        grid[mv.xI][mv.yI].release();
    }

    public Spot[][] getGrid() {
        return grid;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < SIZE; i++) {
            sb.append('1' + i).append("| ");
            for (int j = 0; j < SIZE; j++) {
                if (grid[j][i].isOccupied())
                    sb.append(grid[j][i].getPiece());
                sb.append(" ");
            }
            sb.append("\n");
        }

        sb.append(" ").append("--".repeat(SIZE)).append("\n").append(" ");

        for (int i = 0; i < SIZE; i++)
            sb.append('a' + i).append(" ");

        sb.append("\n");

        return sb.toString();
    }

    public void print() {
        System.out.println(toString());
    }

    @Override
    protected Object clone() {
        Board b = new Board();
        for (int i = 0; i < SIZE; i++)
            for (int j = 0; j < SIZE; j++)
                b.getGrid()[i][j].setPiece((Piece) grid[i][j].getPiece().clone());

        return b;
    }
}
