package agent;

import main.Board;

import java.io.IOException;

public class HumanPlayer extends Player {
    public HumanPlayer(int color, Board board) {
        setColor(color);
        playGround = board;
    }

    @Override
    public boolean makeMove(Move mv) {
        if (mv == null
                || !playGround.getGrid()[mv.xI][mv.yI].isOccupied()
                || playGround.getGrid()[mv.xI][mv.yI].getPiece().getPlayer() == getColor()
                || !playGround.getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv))
            return false;

        playGround.movePiece(mv);
        return true;
    }

    @Override
    public Move makeMove() {
        Move mv;
        char initX, initY, finalX, finalY;

        do {
            System.out.println("Votre coup ? <a2a4> ");
            initX = Lire();
            initY = Lire();
            finalX = Lire();
            finalY = Lire();
            ViderBuffer();

            mv = new Move(initX - 'a', initY - '1', finalX - 'a', finalY - '1');
        } while (!makeMove(mv));

        return mv;
    }

    private static char Lire() {
        char C = 'A';
        boolean OK;

        do {
            OK = true;
            try {
                C = (char) System.in.read();
            } catch (IOException e) {
                OK = false;
            }
        } while (!OK);

        return C;
    }

    private static void ViderBuffer() {
        try {
            while (System.in.read() != '\n') ;
        } catch (IOException e) {
        }
    }
}
