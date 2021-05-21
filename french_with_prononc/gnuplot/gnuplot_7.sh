#!/bin/bash
#* h***************************************************************************
# Generate Gnuplot from various data collected.
#
# Author...... : Olivier Gabathuler
# Created..... : 2009-09-16 OGA V1.0.0
# Modified.... : 2016-01-06 OGA V1.1.0
# Notes....... :
#
# Miscellaneous.
# --------------
# - Version: don't forget to update VERSION (look for VERSION below)!
# - Exit codes EXIT_xxxx are for internal use (see below).
#
#**************************************************************************h *#
# Fonctions communes GnuPlot
. ./fonctions.sh

# Fonction specifique GnuPlot
f_gnuplot() {
 # Generating png gnuplot
 f_set_terminal_png 8000 4000
 f_set_margins
 f_set_styleline 6
 echo "set multiplot" >> $_TMP
 echo "set key title \"$1\"" >> $_TMP
 f_set_xlabel_nombre
 #f_set_ylabel_rimes_glissantes
 f_set_ylabel_logarithme_rimes_glissantes
 echo "set logscale y" >> $_TMP
 echo "set xrange [0:25]" >> $_TMP
 echo "set yrange [0.1:600]" >> $_TMP
 echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"500\" 500, \"2000\" 2000)" >> $_TMP
 # Set linestyle 1 to blue (#0060ad)
 echo -n "plot " >> $_TMP
 f_plot_LP2 "$2" g1 1 2 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g2 1 3 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g3 1 4 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g4 1 5 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g5 1 6 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g6 1 7 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g7 1 8 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g8 1 9 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g9 1 10 2.5
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" g10 1 11 2.5
 echo -n "," >> $_TMP
 #echo "-3.1801*(1.4122-x)*(1.4122-x)*(1.4122-x)+-51.9462*(1.4122-x)*(1.4122-x)+-224.3573*(1.4122-x)+-102.9652 w linespoints" >> $_TMP
 #f_plot_LP2 "$2" "gMax" 1 12 6
 f_plot_LP2 "$2" "gTotal" 1 13 8
}

# Main
echo "Begining $0"

# Version
VERSION=1.2.0

# Need GNU Path
export PATH=/opt/freeware/bin:$PATH

# Gnuplot Data
_TMP=~/tmp/$0.tmp.$$
_DATA="7.academie.data"

# Generate Plot if data exists
>$_TMP
ls "$_DATA" | while read _FIC; do
 _FIC2=`echo "$_FIC" | rev | cut -d'.' -f2- | rev`.png
 echo " generating ${_FIC2} ..."
 f_gnuplot "sequences de lettres glissantes à l'intérieur de mots" "$_DATA"
 printf "\nEOF" >> $_TMP
 chmod u+x $_TMP
 $_TMP > ${_FIC2}
 rm $_TMP 2>/dev/null
done

# End
echo "Ending $0"
