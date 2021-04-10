# POA Chess

L'objectif est de prendre contact avec la programmation orientée aspect. Vous avez à modifier un jeu d'échecs. Cependant, en général aucune modification au code source n'est permise, mais vous aurez la flexibilité pour modifier le code si nécessaire. Vous devrez ajouter des aspects :

* Implémenter la validation des déplacements avec des Aspects (indiqués dans le code). Cette validation peut être :
    
    * Le joueur déplace une pièce et non une case vide. 
        
    * Cette pièce lui appartient.
        
    * Le mouvement est autorisé par la pièce en question.
        
    * Le mouvement final ne sort pas de l’échiquier (1<= xfinal, yfinal <= 8).
      
    * La pièce ne mange pas une pièce qui appartient à ce même joueur.
      
    * La pièce ne saute pas d’autres pièces, excepté pour le cavalier.

* Journaliser tous les coups joués dans un fichier(pas besoin de noter les prises, les promotions, etc.). Placer un coup par ligne.

* Le code fonctionne avec le code source original.

# Comment jouer

* Compilé le projet avec IntelliJ IDEA ou Eclipse.

* Une fois le projet lancé, utilisé la combinaison de touches suivantes pour effectuer un déplacement :

    * a1a2 avec a une lettre allant de a à h (coordonnée horizontale) et 1 un chiffre de 1 à 8 (coordonnée verticale).
    
    * Dans le cas des coordonnées précédentes, la première combinaison a1 correspond à la position initiale de votre pièce et a2 correspond à la destination.

# Participants

* Mayeul MARSAUT - MARM19109805

* Guillaume BLANC DE LANAUTE - BLAG22029701