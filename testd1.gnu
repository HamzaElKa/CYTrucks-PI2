set terminal pngcairo enhanced font 'Verdana,12'
set output 'histogramme_d1.png'
set title 'Nombre de trajets par conducteur'
set xlabel 'Nombre de trajets'
set ylabel 'Conducteurs'
set style fill solid
set boxwidth 0.5
plot "resultatsd1.txt" using 2:0:xtic(1) with boxes lc rgb 'blue' notitle