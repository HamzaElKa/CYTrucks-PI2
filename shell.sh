#!/bin/bash

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
if [ "$#" -eq 0 ]
then 
    echo "Veuillez spécifier au moins un traitemnt."
    exit 1
fi
fichier="$1"
dos_temp="temp"
dos_images="images"
exe_c="prog_c"
if [ ! -d "$dos_temp" ]; then
    mkdir "$dos_temp"
    echo "Dossier $dos_temp créé."
else
    echo "Le dossier $dos_temp existe déjà."
    rm -r "$dos_temp"/*
    echo "Le dossier $dos_temp a été vidé."
fi
if [ ! -d "$dos_images" ]; then
    mkdir "$dos_images"
    echo "Dossier $dos_images créé."
else
    echo "Le dossier $dos_images existe déjà."
fi
if [ ! -e "exe_c" ]; then
    echo "L'executable C n'existe pas. Compilation en cours..."
    ##gcc
    if [ $? -eq 0 ]; then
        echo "Compilation réussie. "
    else 
        echo "Erreur lors de la compilation."
    fi
else 
    echo "L'executable C existe. "
fi
shift
option_h=0
for arg in "$@"; do
    if [ "$arg" = "-h" ]; then
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
if [ "$option_h" -eq 1 ]
then
    exit 0
fi

for arg in "$@"; do
   case "$arg" in
   "-d1") 
   echo "Traitement d1 : "
   echo "Progrès: [####################] (0%)"
   start=$(date +%s)
cut -d';' -f1,6 data_1.csv | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | head -n10 | awk '{print $2"; "$1}' > ./temp/resultats_d1.csv
echo "Progrès: [####################] (33%)"
gnuplot traitementd1.gnu
echo "Progrès: [####################] (66%)"
convert -rotate 90 temp/histogramme_d1.png images/histogramme_d1.png
echo "Progrès: [####################] (100%)"
end=$(date +%s) 
time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
    "-dr1")
    echo "Traitement dr1 : "
    echo "Progrès: [####################] (0%)"
    start=$(date +%s)
cut -d';' -f1,6 data_1.csv | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | tail -n10 | awk '{print $2"; "$1}' > ./temp/resultats_dr1.csv
echo "Progrès: [####################] (33%)"
gnuplot traitementdr1.gnu
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
awk -F';' 'NR>1 {distance[$6] += $5+0} END {for (driver in distance) if (distance[driver] > 0) printf "%.3f %s\n", distance[driver], driver}' data_1.csv > temp/tmp_d2.csv
sort -nr temp/tmp_d2.csv | head -10 | awk '{print $2"; "$1}' > ./temp/resultats_d2.csv 
echo "Progrès: [####################] (33%)"
gnuplot traitementd2.gnu 
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
echo "Progrès: [####################] (0%)"
start=$(date +%s)
awk -F';' 'NR>1 {distance[$6] += $5+0} END {for (driver in distance) if (distance[driver] > 0) printf "%.3f %s\n", distance[driver], driver}' data_1.csv > temp/tmp_dr2.csv
sort -nr temp/tmp_dr2.csv | tail -10 | awk '{print $2"; "$1}' > ./temp/resultats_dr2.csv 
echo "Progrès: [####################] (33%)"
gnuplot traitementdr2.gnu 
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
sort -n -t';' -k1 data_1.csv | cut -d';' -f1,5,6 > temp/tmp_l.csv
echo "Progrès: [####################] (33%)"
awk -F';' 'NR>1 { distances[$1] += $2+0 } END { for (id in distances) printf "%s %.2f\n", id, distances[id] }' temp/tmp_l.csv | sort -n -r -t' ' -k2 | head -n10 | sort -n -r -k1,1 > temp/resultats_l.txt
echo "Progrès: [####################] (66%)"
gnuplot traitementl.gnu
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
    "-rl")
   echo "Traitement rl : "
   echo "Progrès: [####################] (0%)"
   start=$(date +%s)  
sort -n -t';' -k1 data_1.csv | cut -d';' -f1,5,6 > temp/tmp_rl.csv
echo "Progrès: [####################] (33%)"
awk -F';' 'NR>1 { distances[$1] += $2+0 } END { for (id in distances) printf "%s %.2f\n", id, distances[id] }' temp/tmp_rl.csv | sort -n -r -t' ' -k2 | tail -n10 | sort -n -r -k1,1 > temp/resultats_rl.txt
echo "Progrès: [####################] (66%)"
gnuplot traitementrl.gnu
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
    ;;
   "-t") 
   echo "Traitement t : 
   ";;
   "-s") 
   echo "Traitement s : 
   ";;
    *)
    echo "Option non reconnue : $arg";;
   *) 
   echo "$arg existe pas ";;
   esac
done
