import agent.Move;
import agent.Player;
import main.Chess;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public aspect Logging {
    pointcut Logging(): call(Move Player+.makeMove());
    pointcut CleanLogging(): call(Chess.new());

    after(Player player) returning(Move mv): Logging() && target(player) {
        System.out.println("Logging()");
        PrintWriter printWriter;
        try {
            printWriter = new PrintWriter(new FileWriter("logging.txt", true));
        } catch (IOException e) {
            System.out.println("Erreur lors de l'ouverture du fichier de sortie.");
            return;
        }
        printWriter.println("Coup du joueur " + (player.getColor() == 0 ? "IA" : "Humain") + " en " + mv.toString());
        printWriter.close();
    }

    before(): CleanLogging() {
        System.out.println("Pion blanc (joueur Humain) en bas");
        System.out.println("Pion noir (joueur IA) en haut");

        System.out.println("CleanLogging()");
        try {
            new PrintWriter("logging.txt").close();
        } catch (FileNotFoundException e) {
            System.out.println("Erreur lors de l'ouverture du fichier de sortie.");
            return;
        }
    }
}
