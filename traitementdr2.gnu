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
