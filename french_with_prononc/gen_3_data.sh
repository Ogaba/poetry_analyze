_LANG=french

# Variables
_DIR_PREFIX="dics"
_PREFIX="${_LANG}.UTF-8.1-"
_DIR_SUFFIX="rimes"
_SUFFIX="dic.debut_rimes"

_DATA=gnuplot/3.academie.data
>$_DATA
echo "# Taille Rimes_debut	Mots_composées	Mots_non_composés" >> $_DATA
for (( _I=2; _I<=20; _I++ )); do
 declare -A TAB
 echo -n "$_I" >> $_DATA
 # nombre de mots trouvés
 TAB["$_I"]=`wc -l ${_DIR_SUFFIX}/${_PREFIX}${_I}.${_SUFFIX} | awk '{ print $1 }'`
 printf "	%s"${TAB["$_I"]} >> $_DATA
 # dont nombre de mots composés
 TAB["$_I"]=`grep -E " |-" ${_DIR_SUFFIX}/${_PREFIX}${_I}.${_SUFFIX} | wc -l`
 printf "	%s"${TAB["$_I"]} >> $_DATA
 # dont nombre de mots non composés
 TAB["$_I"]=`grep -v -E " |-" ${_DIR_SUFFIX}/${_PREFIX}${_I}.${_SUFFIX} | wc -l`
 printf "	%s"${TAB["$_I"]} >> $_DATA
 echo "" >> $_DATA
 unset TAB
done
