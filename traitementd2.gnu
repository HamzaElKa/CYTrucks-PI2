set terminal pngcairo enhanced font "arial,10" size 800,600 
set output 'images/histogramme_d2.png' 
set xtics font 'blue,8'
set xrange [ 0 : 100]
set style fill solid
set datafile separator ''
set boxwidth 0.8 relative
set xlabel "DISTANCE (Km)"
set ylabel "DRIVER NAMES"
set title "Option -d2 : Distance=f(Drivers)"
plot 'temp/resultats_d2.txt' using ($2*0.5):0:($2*0.5):(0.3):yticlabels(1) with boxxyerrorbars t '', \
     ''          using 2:0:2 with labels center boxed notitle column
