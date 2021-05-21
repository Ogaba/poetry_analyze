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
 echo "set multiplot" >> $_TMP
 f_set_styleline 4
 echo "set key title \"$1\"" >> $_TMP
 f_set_xlabel_nombre
 f_set_ylabel_logarithme_rimes_uniques
 echo "set logscale y" >> $_TMP
 echo "set xrange [2:30]" >> $_TMP
 echo "set xtics (\"2\" 2, \"5\" 5, \"10\" 10, \"15\" 15, \"20\" 20, \"25\" 25, \"30\" 30)" >> $_TMP
 echo "set yrange [0.1:50000]" >> $_TMP
 echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000, \"50000\" 50000)" >> $_TMP
 # Set linestyle 1 to blue (#0060ad)
 echo -n "plot " >> $_TMP
 f_plot_LP "$2" p2 1 2 2
 echo -n "," >> $_TMP
 f_plot_LP "$2" p3 1 3 3
 echo -n "," >> $_TMP
 f_plot_LP "$2" p4 1 4 4
 echo -n "," >> $_TMP
 f_plot_LP "$2" p5 1 5 5
 echo -n "," >> $_TMP
 f_plot_LP "$2" p6 1 6 6
 echo -n "," >> $_TMP
 f_plot_LP "$2" p7 1 7 7
 echo -n "," >> $_TMP
 f_plot_LP2 "$2" "p2-7" 1 8 6
}

# Main
echo "Begining $0"

# Version
VERSION=1.1.0

# Need GNU Path
export PATH=/opt/freeware/bin:$PATH

# Gnuplot Data
_TMP=~/tmp/$0.tmp.$$
_DATA="2.data"

# Generate Plot if data exists
>$_TMP
ls "$_DATA" | while read _FIC; do
 _FIC2=`echo "$_FIC" | cut -d'.' -f1`.png
 echo " generating ${_FIC2} ..."
 f_gnuplot "profondeur de séquences de rimes en début de mot" "$_DATA"
 printf "\nEOF" >> $_TMP
 chmod u+x $_TMP
 $_TMP > ${_FIC2}
 rm $_TMP 2>/dev/null
done

# End
echo "Ending $0"
