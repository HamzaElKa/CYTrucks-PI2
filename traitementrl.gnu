set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_rl.png'
set style fill solid
set boxwidth 0.8 relative
set yrange [0:*]
set xlabel "ID Route"
set ylabel "Distance"
set title "Option -rl : ID Route = f(Distance)"
plot 'temp/resultats_rl.txt' using 2:xticlabels(1) with boxes title "Nombre de trajets" 
