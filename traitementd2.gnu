set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'histogramme_d2.png' 
set style fill solid
set boxwidth 0.8 relative
set ylabel "DISTANCE (Km)"
set xlabel "DRIVER NAMES"
set title "Option -d2 "
plot 'resultats_d2.txt' using ($0+1):1:xtic(2) with boxes title "Nombre de trajets"
