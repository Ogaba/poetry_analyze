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

# Main
echo "Begining $0"

# Version
VERSION=1.1.0

# Need GNU Path
export PATH=/opt/freeware/bin:$PATH

# Gnuplot Data
_TMP=~/tmp/$0.tmp.$$
_DATA="1.freq"
_FIC2=1.freq.png

# Generate Plot if data exists
>$_TMP
f_set_terminal_png 6000 4000
f_set_margins
f_set_styleline 6
echo "set multiplot" >> $_TMP
echo "set key title \"fréquence du nombre de séquences de rimes en fonction de la profondeur de séquence des rimes :\"" >> $_TMP
f_set_xlabel_profondeur_seq
#f_set_ylabel_nombre_seq_rimes_uniques
f_set_ylabel_logarithme_seq_rimes_uniques
echo "set logscale y" >> $_TMP
echo "set xrange [2:8]" >> $_TMP
echo "set yrange [-1000:28000]" >> $_TMP
echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000, \"100000\" 100000, \"1000000\" 1000000)" >> $_TMP
#echo "set samples 400" >> $_TMP
#echo -n "plot " >> $_TMP
ls $_DATA | while read _FIC; do
 echo " adding ${_FIC} ..."
 #f_plot_LP3 "$_FIC" 1 2 8 4
 #echo -n ", " >> $_TMP
 echo "set samples 18" >> $_TMP
 echo "set table \"outfile\"" >> $_TMP
 echo "plot \"$_FIC\" using 2:1 smooth bezier with table" >> $_TMP
 echo "unset table" >> $_TMP
done
# delete last comma
#sed -i 's/,$//' $_TMP
echo "" >> $_TMP
echo " generating ${_FIC2} ..."
printf "\nEOF" >> $_TMP
chmod u+x $_TMP
$_TMP > ${_FIC2}
rm $_TMP 2>/dev/null

# End
echo "Ending $0"
