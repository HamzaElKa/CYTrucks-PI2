#!/bin/bash
# Afficher un message de bienvenue
echo "
Bienvenue à
           _________     __________
          /  ______/    |___    ___|
         /  /               |  |
        /  /        ____    |  |
       /  /        |____|   |  |
      /  /______            |  |
     /_________/            |__|    
		
		    CY-TRUCKS
		2023/2024 CY-TECH
" 
#Verifier le nombre d'arguments
if [ $# -lt 1 ] # si pas d'argument
then
    echo "pas le nbr d'argument"
    exit 1
fi

if [ ! -f $1 ] #si n'est pas un fichier
then 
    echo "$1 n'est pas un fichier"
    exit 2
fi
# Vérifier s'il n'y a aucune option de traitement spécifiée
if [ "$#" -eq 0 ]
then 
    echo "Veuillez spécifier au moins un traitemnt."
    exit 1
fi

fichier="$1"
dos_temp="temp"
dos_images="images"
exe_c="prog_c"
# Créer le dossier temporaire s'il n'existe pas
if [ ! -d "$dos_temp" ]; then
    mkdir "$dos_temp"
    echo "Dossier $dos_temp créé."
else #s'il existe, le vider
    echo "Le dossier $dos_temp existe déjà."
    rm -r "$dos_temp"/*
    echo "Le dossier $dos_temp a été vidé."
fi
# Créer le dossier images s'il n'existe pas
if [ ! -d "$dos_images" ]; then
    mkdir "$dos_images"
    echo "Dossier $dos_images créé."
else
    echo "Le dossier $dos_images existe déjà."
fi
# Compiler le programme C s'il n'existe pas
if [ ! -e "exe_c" ]; then
    echo "L'executable C n'existe pas. Compilation en cours..."
 cd prog_c
 make
 cd ..
    if [ $? -eq 0 ]; then
        echo "Compilation réussie. "
    else 
        echo "Erreur lors de la compilation."
    fi
else 
    echo "L'executable C existe. "
fi
shift #se décaler vers la gauche (vers les traitements)
option_h=0
for arg in "$@"; do
    if [ "$arg" = "-h" ]; then #affichage menu aide
        echo "Options de traitements : "
        echo "-d1 : Les 10 conducteurs avec le plus de trajets."
        echo "-dr1 : Les 10 conducteurs avec le moins de trajets."
        echo "-d2 : Les 10 conducteurs et la plus grande distance parcourue par chacun."
        echo "-dr2 : Les 10 conducteurs et la plus petite distance parcourue par chacun."
        echo "-l : Les 10 trajets les plus longs."
        echo "-rl : Les 10 trajets les plus courts."
        echo "-t : Les 10 villes les plus traversées."
        echo "-s : Statistiques sur les étapes."
        echo "-h : Ignorer toutes les autres options et afficher ce menu."
        option_h=1
        break 
    fi
done
if [ "$option_h" -eq 1 ] # si le menu aide affiché, quitter le programme
then
    exit 0
fi
#----------------------------------------TRAITEMENTS---------------------------------------
for arg in "$@"; do
   case "$arg" in
   "-d1") 
   echo "Traitement d1 : "
   echo "Progrès: [####################] (0%)"
   start=$(date +%s)
   #Prendre les chamos ID et nom, trier en fct du nom, supprimer les lignes en double consécutives, extraire le 2eme champs de chaque ligne, compter le nombre d'occurence de chaque ligne, trier par ordre numérique décroissant, prendre les 10 premieres lignes puis les enregistrer dans un fichier temp
cut -d';' -f1,6 $fichier | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | head -n10 | awk '{print $2"; "$1}' > temp/resultats_d1.csv
echo "Progrès: [####################] (33%)"
gnuplot << EOF
set datafile separator ';'
set terminal png size 800,600
set output 'temp/histogramme_d1.png'
set style data histograms
set style histogram rowstacked
set style fill solid border 1.0 -1
set ytics nomirror
set ylabel 'Nombre de trajets'
set xlabel 'Nom du Conducteur'
set xtics nomirror rotate by -270
set ytics nomirror rotate by 90
set boxwidth 0.5
set title "Option -d1 " 
plot 'temp/resultats_d1.csv' using 2:xtic(1) notitle lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (66%)"
convert -rotate 90 temp/histogramme_d1.png images/histogramme_d1.png #inverser l'histogramme temporaire pour obtenir un histogramme horizontal
echo "Progrès: [####################] (100%)"
end=$(date +%s) 
time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" #Affichage de temps
    echo " "
    ;;
    "-dr1")
    echo "Traitement dr1 : "
    # DE MÊME QUE DR1 SAUF ON PREND LES 10 PETITES VALEURS
    echo "Progrès: [####################] (0%)"
    start=$(date +%s)
cut -d';' -f1,6 $fichier | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | tail -n11 | head -10 | awk '{print $2"; "$1}' > ./temp/resultats_dr1.csv # utiliser tail puis head pour ne pas avoir la ligne de DRIVER
echo "Progrès: [####################] (33%)"
gnuplot << EOF
set datafile separator ';'
set terminal png size 800,600
set output 'temp/histogramme_dr1.png'
set style data histograms
set style histogram rowstacked
set style fill solid border 1.0 -1
set ytics nomirror
set ylabel 'Nombre de trajets'
set xlabel 'Nom du Conducteur'
set xtics nomirror rotate by -270
set ytics nomirror rotate by 90
set title "Option -dr1 "
set boxwidth 0.5
plot 'temp/resultats_dr1.csv' using 2:xtic(1) notitle lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (66%)"
convert -rotate 90 temp/histogramme_dr1.png images/histogramme_dr1.png
echo "Progrès: [####################] (100%)"
end=$(date +%s) 
time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
"-d2")
echo "Traitement d2 : "
echo "Progrès: [####################] (0%)"
start=$(date +%s)
# creer un tableau où la clé est le nom du conducteur et la valeur est la somme des distances parcourues, stocker les resultats dans un 1er fichier temp, trier en ordre décroissant, prendre les 10 premieres valeurs et les stocker dans un 2eme fichier temp
awk -F';' 'NR>1 {distance[$6] += $5+0} END {for (driver in distance) if (distance[driver] > 0) printf "%.3f %s\n", distance[driver], driver}' $fichier > temp/tmp_d2.csv
sort -nr temp/tmp_d2.csv | head -10 | awk '{print $2"; "$1}' > ./temp/resultats_d2.csv 
echo "Progrès: [####################] (33%)"
gnuplot << EOF
set datafile separator ';' 
set terminal png size 800,1024
set output 'temp/histogramme_d2.png'
set style data histograms
set style histogram rowstacked
set style fill solid border 1.0 -1
set ytics nomirror
set ylabel 'Distance totale'
set xlabel 'Nom du Conducteur'
set xtics nomirror rotate by -270
set ytics nomirror rotate by 90
set title "Option -d2 "
set boxwidth 0.5
plot 'temp/resultats_d2.csv' using 2:xtic(1) notitle lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (66%)"
convert -rotate 90 temp/histogramme_d2.png images/histogramme_d2.png
end=$(date +%s) 
time=$(( end - start ))
echo "Progrès: [####################] (100%)"
    echo "Durée d'exec : ${time} secondes" 
    echo " "
  ;;
  "-dr2")
echo "Traitement dr2 : "
#DE MÊME QUE D2 SAUF LES 10 DISTANCES PLUS PETITES TRAVERSÉES PAR UN CONDUCTEUR
echo "Progrès: [####################] (0%)"
start=$(date +%s)
awk -F';' 'NR>1 {distance[$6] += $5+0} END {for (driver in distance) if (distance[driver] > 0) printf "%.3f %s\n", distance[driver], driver}' $fichier > temp/tmp_dr2.csv
sort -nr temp/tmp_dr2.csv | tail -10 | awk '{print $2"; "$1}' > ./temp/resultats_dr2.csv # tail au lieu de head
echo "Progrès: [####################] (33%)"
gnuplot << EOF 
set datafile separator ';' 
set terminal png size 800,1024
set output 'temp/histogramme_dr2.png'
set style data histograms
set style histogram rowstacked
set style fill solid border 1.0 -1
set ytics nomirror
set ylabel 'Distance totale'
set xlabel 'Nom du Conducteur'
set xtics nomirror rotate by -270
set ytics nomirror rotate by 90
set title "Option -dr2 "
set boxwidth 0.5
plot 'temp/resultats_dr2.csv' using 2:xtic(1) notitle lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (66%)"
convert -rotate 90 temp/histogramme_dr2.png images/histogramme_dr2.png
echo "Progrès: [####################] (100%)"
end=$(date +%s) 
time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
  ;;
   "-l")
   echo "Traitement l : "
   echo "Progrès: [####################] (0%)"
   start=$(date +%s)  
 # trier en fct des id, creer un tableau ou la clé est l'id et la valeur est la somme des distances, trier par orde numérique decroissant, prendre les 10 premieres lignes et puis trier en fct de l'id
sort -n -t';' -k1 $fichier | cut -d';' -f1,5,6 > temp/tmp_l.csv
echo "Progrès: [####################] (33%)"
awk -F';' 'NR>1 { distances[$1] += $2+0 } END { for (id in distances) printf "%s %.2f\n", id, distances[id] }' temp/tmp_l.csv | sort -n -r -t' ' -k2 | head -n10 | sort -n -r -k1,1 > temp/resultats_l.txt
echo "Progrès: [####################] (66%)"
gnuplot << EOF
set terminal pngcairo enhanced font "arial,10" size 800,600
set output 'images/histogramme_l.png'
set style fill solid
set boxwidth 0.5 relative
set yrange [0:*]
set xlabel "ID Route"
set ylabel "Distance"
set title "Option -l "
plot 'temp/resultats_l.txt' using 2:xticlabels(1) with boxes title "Distance" lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
    "-rl")
   echo "Traitement rl : "
   # DE MÊME QUE L SAUF TAIL AU LIEU DE HEAD 
   echo "Progrès: [####################] (0%)"
   start=$(date +%s)  
sort -n -t';' -k1 $fichier | cut -d';' -f1,5,6 > temp/tmp_rl.csv
echo "Progrès: [####################] (33%)"
awk -F';' 'NR>1 { distances[$1] += $2+0 } END { for (id in distances) printf "%s %.2f\n", id, distances[id] }' temp/tmp_rl.csv | sort -n -r -t' ' -k2 | tail -n10 | sort -n -r -k1,1 > temp/resultats_rl.txt
echo "Progrès: [####################] (66%)"
gnuplot << EOF
set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_rl.png'
set style fill solid
set boxwidth 0.5 relative
set yrange [0:*]
set xlabel "ID Route"
set ylabel "Distance"
set title "Option -rl "
plot 'temp/resultats_rl.txt' using 2:xticlabels(1) with boxes title "Distance" lc rgb "#64DC64"
EOF
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
   "-t") 
   echo "Traitement t : 
   "
    echo "Progrès: [####################] (0%)"
   start=$(date +%s) 
   awk -F';' '{
   # Si le Step ID ($2) est égal à 1 (point de départ)
   if($2==1){
   count_depart_trajet[$3]++; # Incrémenter le compteur count_depart_trajet
   if(!visited[$1, $3]){  # si la combinaison entre Id de la route et la ville de départ est vide 
   count_visited[$3]++; # Incrémenter le compteur count_visited
   }
   visited[$1, $3]++; 
   }
   # si la ville de départ est differente que la ville darrivé et la combinaison entre Id de la route et la ville darrivé est vide 
   if($3 != $4 && !visited[$1, $4]){
   count_visited[$4]++; # Incrémenter le compteur count_visited
   visited[$1, $4]++;
   }
   }
   END {
   for (i in count_visited){ #print les resultat
   printf("%s;%d;%d\n", i, count_visited[i], count_depart_trajet[i]);
   }
   }' $fichier > temp/data_t.txt
   echo "Progrès: [####################] (33%)"
   sort -n -r -t';' -k2 temp/data_t.txt | head -n10 | sort -t';' -k1 > temp/data_t_sorted.csv 
   echo "Progrès: [####################] (66%)"
   gnuplot << EOF
set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_t.png'
set datafile separator ";"
set style data histogram
set style fill solid
set boxwidth 1.2 relative
set yrange [0:*]
set ylabel "Nombres de fois"
set xlabel "Noms de villes" 
set xtics nomirror rotate by 45 right 
set title "Option -t "
plot 'temp/data_t_sorted.csv' using 2:xtic(1) notitle lc rgb "#64DC64", '' using 3:xtic(1) lc rgb "#99DC99" notitle
EOF
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
   ;;
   "-s") 
   echo "Traitement s : 
   "
    echo "Progrès: [####################] (0%)"
   start=$(date +%s)  
#extraire l'id et la distance et appeler une fct update_stats pour mettre à jour les statistiques de distance pour une route en fct de la clé qui est l'id, puis calculer la difference entre la distance maximale est minimale, et calculer la moyenne. et stocker les resultats dans un fichier temp
awk -F ";" '
  BEGIN {
    OFS=";"
    printf "%d;%f;%f;%f;%f\n", "Route ID", "Min Distance", "Moyenne", "Max Distance", "Difference"
  }
  function update_stats(route_id, distance) {
    if (distance < min_distance[route_id] || min_distance[route_id] == 0) {
      min_distance[route_id] = distance
    }
    if (distance > max_distance[route_id]) {
      max_distance[route_id] = distance
    }
    sum_distance[route_id] = sum_distance[route_id] + distance
    count_distance[route_id] = count_distance[route_id] + 1
  }
  NR > 1 {
    route_id = $1
    distance = $5
    update_stats(route_id, distance)
  }
  END {
    for (key in min_distance) {
      difference = max_distance[key] - min_distance[key]
      moyenne = sum_distance[key] / count_distance[key]
      printf "%d;%f;%f;%f;%f\n", key, min_distance[key], moyenne, max_distance[key], difference
    }
  }' $fichier > temp/data_temp.csv
  echo "Progrès: [####################] (33%)"
  ./prog_c/myprog temp/data_temp.csv #executer le programme C pour trier les valeurs
  head -n50 temp/data_s.txt > temp/data_s_sort.cvs #prendre les 50 premiers valeurs
  awk -W sprintf=num '{x++; printf("%d;%s\n", x, $1)}' temp/data_s_sort.cvs >temp/data_s_sorted.csv #ajouter un numéro de ligne à chaque ligne du fichier pour pouvoir générer le gnuplot
  echo "Progrès: [####################] (66%)"
  gnuplot << EOF
set terminal png font "arial,10"
  set output "images/s.png"
  set title "Option -s"
  set style data lines
  set style fill solid 0.5
  set datafile separator ";"
  set xrange [1:*]
  set xtic rotate by 45 right
  set xlabel "ID"
  set ylabel "Distance" rotate by -270
  set title "Option -s "
  plot "temp/data_s_sorted.csv" using 1:3:5:xtic(2) with filledcurves below title "Distance Min/Max" lc rgb "#64DC64", '' u 1:4 lc rgb "#99DC99" title "Distance Moy"
EOF
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
   ;;
    *)
    # si l'un des paramétres n'est pas reconnu
    echo "Option non reconnue : $arg"
   esac
done
