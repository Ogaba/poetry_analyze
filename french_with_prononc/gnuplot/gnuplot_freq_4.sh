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
 #echo "set table \"outfile\"" >> $_TMP
 #echo -n "plot \"$1\" using 2:1 smooth csplines" >> $_TMP
 f_plot_LP3 "$1" 1 2 8 $2
 echo -n ", " >> $_TMP
 #echo "unset table" >> $_TMP
}

# Main
echo "Begining $0"

# Version
VERSION=1.1.0

# Need GNU Path
export PATH=/opt/freeware/bin:$PATH

# Gnuplot Data
_TMP=~/tmp/$0.tmp.$$
_DATA="4.*.freq"
_FIC2=4.freq.png

# Generate Plot if data exists
>$_TMP
f_set_terminal_png 8000 4000
f_set_margins
f_set_styleline 6
echo "set multiplot" >> $_TMP
echo "set key title \"fréquence d'apparition de rimes en fin de mots, en séquence, avec des mots ou expressions composés\"" >> $_TMP
f_set_xlabel_nombre_seq
f_set_ylabel_logarithme_seq_rimes_uniques
echo "set logscale y" >> $_TMP
echo "set xrange [2:30]" >> $_TMP
echo "set yrange [0.9:14000]" >> $_TMP
echo "set ytics (\"0\" 0.1, \"1\" 1, \"10\" 10, \"100\" 100, \"1000\" 1000, \"10000\" 10000, \"100000\" 100000, \"1000000\" 1000000)" >> $_TMP
#echo "set samples 400" >> $_TMP
echo -n "plot " >> $_TMP
ls $_DATA | while read _FIC; do
 _COLOR=`echo $_FIC | cut -d'.' -f2`
 echo " adding ${_FIC} ..."
 f_gnuplot "$_FIC" $_COLOR
done
# delete last comma
sed -i 's/, $//' $_TMP
echo " generating ${_FIC2} ..."
printf "\nEOF" >> $_TMP
chmod u+x $_TMP
$_TMP > ${_FIC2}
rm $_TMP 2>/dev/null

# End
echo "Ending $0"
