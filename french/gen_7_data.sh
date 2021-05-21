_LANG=french

# Variables
_DIR_PREFIX="dics"
_PREFIX="${_LANG}.UTF-8"
_DIR_SUFFIX="rimes"
_SUFFIX="rimes"

_DATA=gnuplot/7.academie.data
>$_DATA
echo "Taille	g1	g2	g3	g4	g5	g6	g7	g8	g9	g10	gg" >> $_DATA
for (( _I=2; _I<=25; _I++ )); do
 declare -A TAB
 echo -n "$_I" >> $_DATA
 for (( _P=1; _P<=10; _P++ )); do
  [ $_P -lt $_I -a $_I -lt 11 ] && TAB["$_P"]=`wc -l ${_DIR_SUFFIX}/${_PREFIX}.g${_P}-${_I}.${_SUFFIX} | awk '{ print $1 }'` || TAB["$_P"]="N"
  [ $_I -ge 11 ] && TAB["$_P"]=`wc -l ${_DIR_SUFFIX}/${_PREFIX}.g${_P}-${_I}.${_SUFFIX} | awk '{ print $1 }'`
  printf "	%s"${TAB["$_P"]} >> $_DATA
  if [ $_P -eq 10 ]; then
	if [ $_I -lt 11 ]; then
		printf "      %s"${TAB["$(($_I - 1))"]} >> $_DATA
	else
		printf "      %s"0 >> $_DATA
	fi
  fi
 done
 echo "" >> $_DATA
 unset TAB
done
