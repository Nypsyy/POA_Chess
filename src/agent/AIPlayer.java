package agent;

import main.Board;

import java.util.Random;

public class AIPlayer extends Player {
    private Random dices = new Random(0);

    public AIPlayer(int color, Board board) {
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
        int initX, initY, finalX, finalY;

        do {
            initX = dices.nextInt(8);
            initY = dices.nextInt(8);
            finalX = dices.nextInt(8);
            finalY = dices.nextInt(8);
            mv = new Move(initX, initY, finalX, finalY);
        } while (!makeMove(mv));

        System.out.println("Votre coup ? <" + mv.toString() + ">");
        return mv;
    }
}
