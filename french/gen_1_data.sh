_LANG=french

# Variables
_DIR_PREFIX="dics"
_PREFIX="${_LANG}.UTF-8.1-"
_DIR_SUFFIX="rimes"
_SUFFIX="rimes"

_DATA=gnuplot/1.academie.data
>$_DATA
echo "Taille	g1	g2	g3	g4	g5	g6	gg" >> $_DATA
for (( _I=2; _I<=20; _I++ )); do
 declare -A TAB
 echo -n "$_I" >> $_DATA
 for (( _P=1; _P<=6; _P++ )); do
  [ $_P -lt $_I -a $_I -lt 7 ] && TAB["$_P"]=`wc -l ${_DIR_SUFFIX}/${_PREFIX}${_I}.p${_P}.${_SUFFIX} | awk '{ print $1 }'` || TAB["$_P"]="N"
  [ $_I -ge 7 ] && TAB["$_P"]=`wc -l ${_DIR_SUFFIX}/${_PREFIX}${_I}.p${_P}.${_SUFFIX} | awk '{ print $1 }'`
  printf "	%s"${TAB["$_P"]} >> $_DATA
  if [ $_P -eq 6 ]; then
	if [ $_I -lt 7 ]; then
		printf "      %s"${TAB["$(($_I - 1))"]} >> $_DATA
	else
		printf "      %s"0 >> $_DATA
	fi
  fi
 done
 echo "" >> $_DATA
 unset TAB
done
