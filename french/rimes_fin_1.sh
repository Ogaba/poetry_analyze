#!/bin/bash
trap 'echo "Signal recu, purge et sortie."; f_purge; exit 0' KILL TRAP HUP INT QUIT ABRT SYS
# Recherche de rimes en fin de mot dans un dictionnaire
_LANG=french

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_DIR_PREFIX="dics"; _PREFIX="${_LANG}.UTF-8.1-"
_DIR_SUFFIX="rimes"; _SUFFIX="rimes"

f_purge() {
echo " purge de exec.*.p*.sh"
rm -f exec.*.p*.sh 2>/dev/null
}

for _P in {1..1}; do
 for _I in {2..20}; do
   echo "Recherche en cours de rimes en fin de mot de longueur $_I avec profondeur de $_P lettres."
   _EXEC="exec.${_I}.p${_P}.sh"
   >$_EXEC
   echo ">${_DIR_SUFFIX}/${_PREFIX}${_I}.p${_P}.${_SUFFIX}" >> $_EXEC
   echo "cat ${_DIR_PREFIX}/${_PREFIX}${_I}.rev.dic | while read _R1; do" >> $_EXEC
   for (( _J=1; _J<=$(($_P - 1)); _J++ )); do
    _K=$(($_J + 1))
    _L=$(($_I + $_J))
    echo "grep -E \"^\$_R${_J}([[:alnum:]]|-)\$\" ${_DIR_PREFIX}/${_PREFIX}${_L}.rev.dic | sort -u | while read _R${_K}; do" >> $_EXEC
   done
   echo -n "echo \"" >> $_EXEC
   for (( _J=1; _J<=$_P; _J++ )); do
    echo -n "\`echo \$_R${_J} | rev\`;" >> $_EXEC
   done
   echo "\" >> ${_DIR_SUFFIX}/${_PREFIX}${_I}.p${_P}.${_SUFFIX}" >> $_EXEC
   for (( _J=1; _J<=$_P; _J++ )); do
    echo "done" >> $_EXEC
   done
   echo "sed -i 's/;\$//' ${_DIR_SUFFIX}/${_PREFIX}${_I}.p${_P}.${_SUFFIX}" >> $_EXEC
   chmod u+x ./$_EXEC && ./$_EXEC &
 done
done
wait

# Résultats
echo "wc -l ${_DIR_SUFFIX}/${_PREFIX}*.p*.${_SUFFIX}"
wc -l ${_DIR_SUFFIX}/${_PREFIX}*.p*.${_SUFFIX}

echo " dont nombres de mots composés"
ls ${_DIR_SUFFIX}/${_PREFIX}*.p*.${_SUFFIX} | while read _F; do
 echo "dans $_F :" `grep -E " |-" $_F | wc -l`
done

# Purge
f_purge
