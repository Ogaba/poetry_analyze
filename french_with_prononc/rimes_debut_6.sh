#!/bin/bash
trap 'echo "Signal recu, purge et sortie."; f_purge; exit 0' KILL TRAP HUP INT QUIT ABRT SYS
# Recherche de rimes en début de mot dans un dictionnaire
_LANG=french

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_DIR_PREFIX="dics"; _PREFIX="${_LANG}.UTF-8.1-"
_DIR_SUFFIX="rimes"; _SUFFIX="debut_rimes"

f_purge() {
echo " purge de exec.l*.${_SUFFIX}.sh"
rm -f exec.l*.${_SUFFIX}.sh 2>/dev/null
}

# Recherches indexées sur chaque dictionnaire de tous les mots qui riment du type :
for _I in {1..20}; do
 echo "Recherche en cours de tous les mots de ${_PREFIX}${_I}.debut_dic qui riment dans $_LANG.UTF-8.dic"
 _EXEC="exec.l${_I}.${_SUFFIX}.sh"
 >$_EXEC
 echo ">${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX}" >> $_EXEC
 echo "cat ${_DIR_PREFIX}/${_PREFIX}${_I}.debut_dic | while IFS=\";\" read -r _SEQ; do" >> $_EXEC
  echo "grep \"^\${_SEQ}\" ${_DIR_PREFIX}/$_LANG.UTF-8.dic | sort -u | sed -e 's/\\\\-/-/g' | tr '\\n' ';' | sed -e 's/;\$//' >> ${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX}" >> $_EXEC
  echo "echo \"\" >> ${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX}" >> $_EXEC
 echo "done" >> $_EXEC
 chmod u+x ./$_EXEC && ./$_EXEC &
done
wait

# On ne conserve que les suites de rimes qui ont au moins.. 1 rime !! :
echo "On ne conserve que les suites de rimes qui ont au moins.. 1 rime :"
for _I in {1..20}; do
 echo " traitement de ${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX}"
 awk -F';' '{ if (NF>2) { print $0 }; }' ${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX} | sponge ${_DIR_SUFFIX}/$_LANG.UTF-8.l${_I}.${_SUFFIX}
done

# Résultats
echo "Résultats :"
echo "wc -l ${_DIR_SUFFIX}/$_LANG.UTF-8.l*.${_SUFFIX}"
wc -l ${_DIR_SUFFIX}/$_LANG.UTF-8.l*.${_SUFFIX}

echo " dont nombres de mots composés"
ls ${_DIR_SUFFIX}/$_LANG.UTF-8.l*.${_SUFFIX} | while read _F; do
 echo "dans $_F :" `grep -E " |-" $_F | wc -l`
done

# Purge
f_purge
