#!/bin/bash
# Calcul de la distance de levenshtein entre les rimes

# https://fr.wikipedia.org/wiki/Mesure_de_similarit%C3%A9

# En mathématiques et en informatique théorique, une mesure de similarité, plus exactement une mesure de distance entre mots, est une façon de représenter par un nombre la différence entre deux mots, ou plus généralement deux chaînes de caractères. Cela permet de comparer des mots ou chaines de façon simple et pratique. C'est donc une forme de distance mathématique et de métrique pour les chaînes de caractères.

# En programmation, la mesure la plus simple et la plus courante est la distance de Levenshtein : elle est obtenue en comptant le nombre de modification de caractères individuels (ajout, retrait, ou changement) pour passer d'une chaîne à l'autre. 

# Ici on s'appuie sur une fonction compilée en C : levenshtein_s.o dont le code source est levenshtein_s.c :
f_levenshtein () {
 ls $_LIST_FILES | while read _FIC; do
  if [ -s "$_FIC" ]; then
   _DIR_FREQ="lev_freq"
   _NAME_FREQ=`echo "$_FIC" | rev | cut -d'/' -f1 | rev`.lev_freq
   _FIC_FREQ="${_DIR_FREQ}/${_NAME_FREQ}"
   >$_FIC_FREQ
   echo "Traitement de $_FIC en cours"
   cat $_FIC | while read _LINE; do
    # le séparateur compilé dans ../levenshtein_s.o est ";"
    _LVS=`../levenshtein_s.o "$_LINE"`
    echo "${_LVS}" >> "${_FIC_FREQ}"
   done
   cat "${_FIC_FREQ}" | sort -g | uniq -c | sponge "${_FIC_FREQ}"
  fi
 done
}

f_sum_column_keep_other_column () {
# check first getconf ARG_MAX before using
 >${1}2
 cat ${1} | while read _N1 _N2; do
  echo "$_N1 "`echo $_N2 | bc -l` >> ${1}2
 done
 sort -k2 -g ${1}2 | sponge ${1}2
 >$1
 _I=0
 cat ${1}2 | cut -d' ' -f2 | while read _N; do
  echo `grep " ${_N}$" ${1}2 | awk '{print $1}' | paste -sd+ | bc -l`" $_N" >> $1
 done
 sort -k2 -g $1 | sponge $1
 rm ${1}2
}

f_consolidation () {
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.1-*.p*.rimes.lev_freq"
 cat lev_freq/french.UTF-8.1-*.p*.rimes.lev_freq > gnuplot/rimes_fin1_debut2.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin1_debut2.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.1-*.rimes.lev_freq"
 cat lev_freq/french.UTF-8.1-*.rimes.lev_freq > gnuplot/rimes_fin4_debut3.lev_freq
 cat lev_freq/french.UTF-8.1-*.debut_rimes.lev_freq >> gnuplot/rimes_fin4_debut3.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin4_debut3.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.l*.rimes.lev_freq"
 cat lev_freq/french.UTF-8.l*.rimes.lev_freq > gnuplot/rimes_fin5_debut6.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin5_debut6.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.*g*.rimes.lev_freq"
 cat lev_freq/french.UTF-8.g*.rimes.lev_freq > gnuplot/rimes_glissantes.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_glissantes.lev_freq
}

mkdir lev_freq 2>/dev/null
if [ -n "$1" ]; then
 _LIST_FILES="$1"
 f_levenshtein
else
 echo "Traitement des fichiers de rimes french.UTF-8.*p*.rimes"
 _LIST_FILES="rimes/french.UTF-8.1-*.p*.rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1-[0-9].rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9].rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1-[0-9][0-9].rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9][0-9].rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1-[0-9].debut_rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9].debut_rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1-[0-9][0-9].debut_rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9][0-9].debut_rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.l*.rimes"
 _LIST_FILES="rimes/french.UTF-8.l*.rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.g*.rimes"
 _LIST_FILES="rimes/french.UTF-8.g*.rimes"
 f_levenshtein
fi
f_consolidation
