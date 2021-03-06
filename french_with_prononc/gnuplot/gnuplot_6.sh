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
 echo "set key title \"$1\"" >> $_TMP
 f_set_xlabel_nombre
 f_set_ylabel_nombre_rimes_uniques
 #f_set_ylabel_logarithme_rimes_uniques
 echo "set logscale y" >> $_TMP
 echo "set xrange [0:30]" >> $_TMP
 echo "set yrange [0.1:7000]" >> $_TMP
 #echo "set yrange [0.1:100000]" >> $_TMP
 #echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000, \"100000\" 100000)" >> $_TMP
 # Set linestyle 1 to blue (#0060ad)
 echo -n "plot " >> $_TMP
 f_plot_LP "$2" Mots 1 2 2
 echo -n "," >> $_TMP
 f_plot_LP "$2" "dont mots composés" 1 3 3
 echo -n "," >> $_TMP
 f_plot_LP "$2" "dont mots non composés" 1 4 4
}

# Main
echo "Begining $0"

# Version
VERSION=1.2.0

# Need GNU Path
export PATH=/opt/freeware/bin:$PATH

# Gnuplot Data
_TMP=~/tmp/$0.tmp.$$
_DATA="6.academie.data"

# Generate Plot if data exists
>$_TMP
ls "$_DATA" | while read _FIC; do
 _FIC2=`echo "$_FIC" | rev | cut -d'.' -f2- | rev`.png
 echo " generating ${_FIC2} ..."
 f_gnuplot "rimes en début de mots, avec n'importe quelle séquence de lettres" "$_DATA"
 printf "\nEOF" >> $_TMP
 chmod u+x $_TMP
 $_TMP > ${_FIC2}
 rm $_TMP 2>/dev/null
done

# End
echo "Ending $0"
