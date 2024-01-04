set terminal pngcairo enhanced font 'Verdana,12'
set output 'histogramme_l.png'
set title "Histogramme des distances par ID"
set xlabel "ID"
set ylabel "Distance"
# Style de l'histogramme
set style data histograms
set style fill solid
set boxwidth 0.5
plot "resultats.txt" using 2:xtic(1) with histogram title "Distances"