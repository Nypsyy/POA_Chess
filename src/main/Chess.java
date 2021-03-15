package main;

import agent.AIPlayer;
import agent.HumanPlayer;
import agent.Player;

public class Chess {
    protected Board board;

    public Chess() {
        board = new Board();
        board.setupChessBoard();
    }

    private void play() {
        Player hp = new HumanPlayer(Player.BLACK, board);
        Player ap = new AIPlayer(Player.WHITE, board);

        while (true) {
            board.print();
            hp.makeMove();
            board.print();
            ap.makeMove();
        }
    }


    public Board getBoard() {
        return board;
    }

    public void setBoard(Board board) {
        this.board = board;
    }

    public static void main(String[] args) {
        new Chess().play();
    }
}
