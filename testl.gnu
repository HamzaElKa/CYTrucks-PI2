set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_l.png'
set style fill solid
set boxwidth 0.8 relative
set yrange [0:*]
set xlabel "ROUTE ID"
set ylabel "DISTANCE (Km)"
set title "Option -l "
plot 'temp/resultats_l.txt' using 2:xticlabels(1) with boxes title "Nombre de trajets" 
