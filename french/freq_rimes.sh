#!/bin/bash
# Calcul de la distance de levenshtein entre les rimes

f_levenshtein () {
 ls $_LIST_FILES | while read _FIC; do
  if [ -s "$_FIC" ]; then
   _DIR_FREQ="lev_freq"
   _NAME_FREQ=`echo "$_FIC" | rev | cut -d'/' -f1 | rev`.lev_freq
   _FIC_FREQ="${_DIR_FREQ}/${_NAME_FREQ}"
   if [ ! -f "${_FIC_FREQ}" ]; then
    echo "Traitement de $_FIC en cours"
    cat $_FIC | while read _LINE; do
     _I=0
     IFS=";"
     for _WORD in $_LINE; do
      _I=$(($_I + 1))
      [ $_I -gt 1 ] && echo -n "`../levenshtein.o $_PREVIOUS $_WORD`+" >> "${_FIC_FREQ}" && _PREVIOUS="$_WORD" || _PREVIOUS="$_WORD"
     done
     echo "" >> "${_FIC_FREQ}"
    done
    sort "${_FIC_FREQ}" | sed -e 's/+$//' | uniq -c | sponge "${_FIC_FREQ}"
   else
    echo " le fichier ${_FIC_FREQ} a déjà été généré. On passe."
   fi
  fi
 done
}

f_sum_column_keep_other_column () {
# check first getconf ARG_MAX before using
 >${1}2
 cat $1 | awk '{print $2}' | sort -g | uniq | while read _N; do
  echo `grep " "${_N}"$" $1 | awk '{print $1}' | paste -sd+ | bc -l`" $_N" >> ${1}2
 done
 mv ${1}2 $1
}

f_consolidation () {
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.p*.lev_freq"
 cat lev_freq/french.UTF-8.p*.lev_freq > gnuplot/rimes_fin1_debut2.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin1_debut2.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.*.dic.rimes"
 cat lev_freq/french.UTF-8.*.dic.rimes.lev_freq > gnuplot/rimes_fin4_debut3.lev_freq
 cat lev_freq/french.UTF-8.*.dic.debut_rimes.lev_freq >> gnuplot/rimes_fin4_debut3.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin4_debut3.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.l*.lev_freq"
 cat lev_freq/french.UTF-8.l*.lev_freq > gnuplot/rimes_fin5_debut6.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_fin5_debut6.lev_freq
 echo "Calcul de la somme des fréquences des fichiers lev_freq/french.UTF-8.*g*.lev_freq"
 cat lev_freq/french.UTF-8.*g*.lev_freq > gnuplot/rimes_glissantes.lev_freq
 f_sum_column_keep_other_column gnuplot/rimes_glissantes.lev_freq
}

mkdir lev_freq 2>/dev/null
if [ -n "$1" ]; then
 _LIST_FILES="$1"
 f_levenshtein
else
 echo "Traitement des fichiers de rimes french.UTF-8.*p*.rimes"
 _LIST_FILES="rimes/french.UTF-8.*p*.rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1.[0-9].rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9].rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1.[0-9][0-9].rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9][0-9].rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1.[0-9].debut_rimes"
 _LIST_FILES="rimes/french.UTF-8.1-[0-9].debut_rimes"
 f_levenshtein
 echo "Traitement des fichiers de rimes french.UTF-8.1.[0-9][0-9].debut_rimes"
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
