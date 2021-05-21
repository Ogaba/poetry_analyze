#!/bin/bash
trap 'echo "Signal recu, purge et sortie."; exit 0' KILL TRAP HUP INT QUIT ABRT SYS
# Recherche de rimes en début de mot dans un dictionnaire
_LANG=french

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_DIR_PREFIX="dics"; _PREFIX="${_LANG}.UTF-8.1-"
_DIR_SUFFIX="rimes"; _SUFFIX="dic.debut_rimes"

for _I in {1..20}; do
 echo "Recherche en cours pour $_I caractères en début de mots dans ${_PREFIX}${_I}.dic"
 >${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX
 cat ${_DIR_PREFIX}/${_PREFIX}${_I}.dic | while read _WORD; do
  echo -n "${_WORD};" >> ${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX
  for (( _J=2; _J<=20; _J++ )); do
   if [ $_J -gt $_I ]; then
    grep "^${_WORD}" ${_DIR_PREFIX}/${_PREFIX}${_J}.dic | tr -d '\\' | tr '\n' ';' >> ${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX
   fi
  done
  echo "" >> ${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX
 done
 echo "Nettoyage : on ne conserve que les rimes ayant plusieurs mots."
 ls ${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX | while read _FILE; do
  >${_FILE}.ok
  cat $_FILE | grep . | while read _LINE; do
   [ `echo "$_LINE" | awk -F\; '{print NF-1}'` -gt 1 ] && echo "$_LINE" >> ${_FILE}.ok
  done
  mv ${_FILE}.ok ${_FILE}
 done
 echo "Calcul des fréquences d'apparition de séquences de rimes de taille différente." 
 ls ${_DIR_SUFFIX}/${_PREFIX}${_I}.$_SUFFIX | while read _FILE; do
  echo -n " calcul de la fréquence d'apparition dans $_FILE redirigé vers gnuplot/3.${_I}.freq"
  cat $_FILE | grep . | while read _LINE; do
   echo "$_LINE" | awk -F\; '{print NF-1}'
  done | sort -g | uniq -c > gnuplot/3.${_I}.freq
 done
done

# Résultats
echo "wc -l ${_DIR_SUFFIX}/${_PREFIX}*.$_SUFFIX"
wc -l ${_DIR_SUFFIX}/${_PREFIX}*.$_SUFFIX

echo " dont nombres de mots composés"
ls ${_DIR_SUFFIX}/${_PREFIX}*.$_SUFFIX | while read _F; do
 echo "dans $_F :" `grep -E " |-" $_F | wc -l`
done
