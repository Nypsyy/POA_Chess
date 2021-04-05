import agent.Move;
import agent.Player;
import main.Chess;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public aspect Logging {
    pointcut OnMove(): call(Move Player+.makeMove());
    pointcut Cleaning(): call(Chess.new());

    // Après l'exécution de la méthode Player.makeMove() pour sauvegarder le coup joué
    after(Player player) returning(Move mv): OnMove() && target(player) {
        System.out.println("Sauvegarde du coup du joueur " + (player.getColor() == 0 ? "IA" : "Humain") + " en " + mv.toString());
        PrintWriter printWriter;
        try {
            // Initialise le fichier de log pour enregistrer le coup
            printWriter = new PrintWriter(new FileWriter("logging.txt", true));
        } catch (IOException e) {
            // Erreur lors de l'ouverture
            System.out.println("Erreur lors de l'ouverture du fichier de sortie.");
            return;
        }
        // Ajout d'une nouvelle ligne au fichier avec le coup joué
        printWriter.println("Coup du joueur " + (player.getColor() == 0 ? "IA" : "Humain") + " en " + mv.toString());
        // Fermeture du fichier
        printWriter.close();
    }

    // Avant l'appel au constructeur de la classe Chess pour intercepter le début d'une partie
    before(): Cleaning() {
        System.out.println("Pion blanc (joueur Humain) en bas");
        System.out.println("Pion noir (joueur IA) en haut");

        System.out.println("Nettoyage des logs");
        try {
            // Ouvre et ferme le fichier de log pour le nettoyer en début de partie
            new PrintWriter("logging.txt").close();
        } catch (FileNotFoundException e) {
            // Erreur lors de l'ouverture
            System.out.println("Erreur lors de l'ouverture du fichier de sortie.");
            return;
        }
    }
}
