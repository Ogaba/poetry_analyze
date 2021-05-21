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
_DATA="pron.1.freq"
_FIC2=pron.1.freq.png

# Generate Plot if data exists
>$_TMP
f_set_terminal_png 7500 5500
f_set_margins
f_set_styleline 10
#f_set_linetype 2 5
#f_set_linetype 5 5
echo "set multiplot" >> $_TMP
echo "set key title \"fréquence d'apparition d'une prononciation sonore en début de mot\"" >> $_TMP
f_set_xlabel_nombre_pron
#f_set_ylabel_logarithme_pron
f_set_ylabel_pron
#echo "set logscale y" >> $_TMP
echo "set xrange [1:300]" >> $_TMP
echo "set yrange [0.9:4000]" >> $_TMP
#echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000)" >> $_TMP
echo "set samples 400" >> $_TMP
echo -n "plot " >> $_TMP
ls $_DATA | while read _FIC; do
 echo " adding ${_FIC} ..."
 f_plot_LP4 "$_FIC" 2 1 1 2
 echo -n ", " >> $_TMP
done
# delete last comma
#sed -i "s/, $//" $_TMP
# 11/09/2020 avec un dictionnaire où il manque encore plusieurs milliers de prononciation du dictionnaire
#echo "393.8504*exp(31.1040/(x+11))+-190643.0604/(x+11)**2+-400.5545 w linespoints linestyle 5 smooth csplines" >> $_TMP
#echo "562.7807*exp(29.3870/(x+11))+-318285.3504/((x+11)*(x+11))+-584.2677 w linespoints linestyle 5 smooth csplines" >> $_TMP
echo "469.6033*exp(29.9052/(x+11))+-216471.4361/((x+11)*(x+11))+-477.1249 w linespoints linestyle 5 smooth csplines" >> $_TMP
echo " generating ${_FIC2} ..."
printf "\nEOF" >> $_TMP
chmod u+x $_TMP
$_TMP > ${_FIC2}
#rm $_TMP 2>/dev/null

# End
echo "Ending $0"
