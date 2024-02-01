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
gcc prog_c/avl_s.c -o mon_programme

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
cut -d';' -f1,6 $fichier | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | head -n10 | awk '{print $2"; "$1}' > ./temp/resultats_d1.csv
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
set title "Option -d1 : Nom=f(Nbr trajets)" 
plot 'temp/resultats_d1.csv' using 2:xtic(1) notitle 
EOF
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
cut -d';' -f1,6 $fichier | sort -t';' -k2 | uniq | cut -d ';' -f2 | uniq -c | sort -nr | tail -n11 | head -10 | awk '{print $2"; "$1}' > ./temp/resultats_dr1.csv
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
set boxwidth 0.5
plot 'temp/resultats_dr1.csv' using 2:xtic(1) notitle 
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
set boxwidth 0.5
plot 'temp/resultats_d2.csv' using 2:xtic(1) notitle
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
echo "Progrès: [####################] (0%)"
start=$(date +%s)
awk -F';' 'NR>1 {distance[$6] += $5+0} END {for (driver in distance) if (distance[driver] > 0) printf "%.3f %s\n", distance[driver], driver}' $fichier > temp/tmp_dr2.csv
sort -nr temp/tmp_dr2.csv | tail -11 | head -10 | awk '{print $2"; "$1}' > ./temp/resultats_dr2.csv 
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
set boxwidth 0.5
plot 'temp/resultats_dr2.csv' using 2:xtic(1) notitle
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
set title "Option -l : ID Route = f(Distance)"
plot 'temp/resultats_l.txt' using 2:xticlabels(1) with boxes title "Nombre de trajets" 
EOF
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
sort -n -t';' -k1 $fichier | cut -d';' -f1,5,6 > temp/tmp_rl.csv
echo "Progrès: [####################] (33%)"
awk -F';' 'NR>1 { distances[$1] += $2+0 } END { for (id in distances) printf "%s %.2f\n", id, distances[id] }' temp/tmp_rl.csv | sort -n -r -t' ' -k2 | tail -n11 | head -10 | sort -n -r -k1,1 > temp/resultats_rl.txt
echo "Progrès: [####################] (66%)"
gnuplot << EOF
set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_rl.png'
set style fill solid
set boxwidth 0.5 relative
set yrange [0:*]
set xlabel "ID Route"
set ylabel "Distance"
set title "Option -rl : ID Route = f(Distance)"
plot 'temp/resultats_rl.txt' using 2:xticlabels(1) with boxes title "Nombre de trajets" 
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
   awk -F';' '{
   if($2==1){
   count2[$3]++;
   if(!visited[$1, $3]){
   count[$3]++;
   }
   visited[$1, $3]++;
   }
   if($3 != $4 && !visited[$1, $4]){
   count[$4]++;
   visited[$1, $4]++;
   }
   }
   END {
   for (i in count){
   printf("%s;%d;%d\n", i, count[i], count2[i]);
   }
   }' $fichier > temp/data_t.txt
   sort -n -r -t';' -k2 temp/data_t.txt | sort -t';' -k1 | head -n10 > temp/data_t_sorted
   ;;
   "-s") 
   echo "Traitement s : 
   "
    echo "Progrès: [####################] (0%)"
   start=$(date +%s)  
awk -F ";" '
  BEGIN {
    OFS=";"
    printf "%d;%f;%f;%f\n", "Route ID", "Min Distance", "Max Distance", "Difference"
  }
  function update_stats(route_id, distance) {
    if (distance < min_distance[route_id] || min_distance[route_id] == 0) {
      min_distance[route_id] = distance
    }
    if (distance > max_distance[route_id]) {
      max_distance[route_id] = distance
    }
  }
  NR > 1 {
    route_id = $1
    distance = $5
    update_stats(route_id, distance)
  }
  END {
    for (key in min_distance) {
      difference = max_distance[key] - min_distance[key]
      printf "%d;%f;%f;%f\n", key, min_distance[key], max_distance[key], difference
    }
    
  }' data_1.csv > temp/data_temp.txt 
  gcc prog_c/avl_s.c -o myprog
  ./myprog temp/data_temp.csv 
  awk -W sprintf=num '{x++; printf("%d;%s\n", x, $1)}' temp/data_s.txt >temp/data_s_sorted.csv 
  echo "Progrès: [####################] (66%)"
  gnuplot << EOF
set terminal png font "Arial,6"
  set output "images/trai_s.png"
  set title "Option -s"
  set style data lines
  set style fill solid 0.5
  set datafile separator ";"
  set xrange [1:*]
  set xtic rotate by 45 right
  set xlabel "ID"
  set ylabel "Distance" rotate by -270
  plot "temp/data_s_sorted.csv" using 1:3:5:xtic(2) with filledcurves below title "Test" lc rgb "blue", '' u 1:4 lc rgb "blue" title "Test"
EOF
echo "Progrès: [####################] (100%)"
    end=$(date +%s) 
    time=$(( end - start ))
    echo "Durée d'exec : ${time} secondes" 
    echo " "
   ;;
    *)
    echo "Option non reconnue : $arg";;
   *) 
   echo "$arg existe pas ";;
   esac
done
