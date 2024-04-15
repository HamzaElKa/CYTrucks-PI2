### Gestion de trajets d'une société nationale de transport routier
Bienvenue dans votre gestionnaire de trajets d'une société de transport. Le projet se compose de differents graphiques de gestion des trajets effectuées par les conducteurs qui sont générés à partir de traitement choisi par l'utilisateur.
### Fonctionnalités 
-	Le programme est codé en Script Shell et language C, et les graphiques sont générées à l'aide de GnuPlot.
-	Il permet d'analyser, trier et faire des calculs de distance à partir d'un fichier de données ".csv" qui contient l'ensemble des données sur les trajets.
- Il y a differents traitements qui peuvent être effectués par le programme et qui sont :
  - "-d1" : Affichage des 10 conducteurs avec le plus de trajets effectués.
  - "-dr1" : Affichage des 10 conducteurs avec le moins de trajets effectués.
  - "-d2" : Affichage des 10 conducteurs avec la plus grande distance.
  - "-dr2" : Affichage des 10 conducteurs avec la plus petite distance.
  - "-l" : Affichage des 10 trajets les plus longs.
  - "-rl" : Affichage des 10 trajets les plus courts.
  - "-t" : Affichage des 10 villes les plus traversées.
  - "-s" : Affichage des statistiques sur les étapes. (Distance min, max et moy)
- Vous pouvez effectuer plusieurs traitements à la fois.
### Ce que vous devriez avoir 
- Un fichier.csv dans le répértoire.
- Vous devrez avaoir Git et GnuPlot installé sur votre machine pour pouvoir les utiliser.
- Le fichier .csv doit avoir 5 colonnes selon le format suivant : Route ID;Step ID;Town A;Town B;Distance;Driver name
### Utilisation
Pour obtenir une copie de ce projet, vous pouvez utiliser soi le git clone ou le télécharger au format ZIP.
-  git clone (Vous devrez avoir Git installé sur votre machine pour pouvoir utiliser la commande git clone):
   -  Copiez l'URL du dépôt GitHub en cliquant sur le bouton "Code" sur la page principale du dépôt.
   -  Ouvrez votre teminal.
   -  Utilisez la commande git clone suivie de l'URL du dépôt GitHub.
   -  Une fois terminée, vous allez avoir une version du projet sur votre machine.
-  Format ZIP :
   -  Clickez sur le bouton "Code" sur la page principale du dépôt GitHub.
   -  Sélectionnez "Download ZIP".
   -  Une fois le téléchargement est terminé, vous pouvez extraire le fichier ZIP sur un répertoire de votre choix.
Execution du programme : 
-	Ouvrez votre terminal Linux.
-	Accéder au répertoire ou se trouve le makefile et l’ensemble des codes utilisés pour le programme.
-	 Tapez bash shell.sh "nom_de_fichier.csv" "traitements souhaités"
-	 Exemple : bash shell.sh data.csv -d1 -dr2 -l
### Auteurs
-	Hamza EL KARCHOUNI
-	Allan SOUGANI KONE
-	Adam EL KHLIFI
