import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public aspect Logging {
    pointcut Logging(): call(agent.Move agent.Player+.makeMove());
    pointcut CleanLogging(): call(void main.Chess.play());

    after(agent.Player player) returning(agent.Move mv): Logging() && target(player) {
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
        try {
            new PrintWriter("logging.txt").close();
        } catch (FileNotFoundException e) {
            System.out.println("Erreur lors de l'ouverture du fichier de sortie.");
            return;
        }
    }
}
