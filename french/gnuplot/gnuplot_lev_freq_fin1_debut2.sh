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
_DATA="rimes_fin1_debut2.lev_freq"
_FIC2=${_DATA}.png

# Generate Plot if data exists
>$_TMP
f_set_terminal_png 6000 4000
f_set_margins
echo "set boxwidth 0.5" >> $_TMP
echo "set style fill solid" >> $_TMP
echo "set multiplot" >> $_TMP
echo "set key title \"Fréquence d'apparition d'une distance cumulée entre les mots d'une séquence de rimes, en fonction de la distance cumulée\"" >> $_TMP
f_set_xlabel_nombre_lev
f_set_ylabel_nombre_lev_seq_rimes
#echo "set logscale y" >> $_TMP
echo "set xrange [1:8]" >> $_TMP
echo "set yrange [0.9:40000]" >> $_TMP
#echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000, \"100000\" 100000, \"1000000\" 1000000)" >> $_TMP
#echo "set samples 400" >> $_TMP
echo -n "plot " >> $_TMP
echo " adding ${_DATA} ..."
f_plot_BOXES3 "$_DATA" 1 2 8 3
echo " generating ${_FIC2} ..."
printf "\nEOF" >> $_TMP
chmod u+x $_TMP
$_TMP > ${_FIC2}
rm $_TMP 2>/dev/null

# End
echo "Ending $0"
