contains() { [ "${1#*$2}" != "$1" ] && return 0 || return 1; }

adjacent_prononc_with_API() {
 local n m
 _1=${1/ə/ø} && _F1=1
 _1=${1/œ/ø} && _F2=1
 _1=${1/ɥ/i} && _F3=1
 #echo "_1 = $_1 ; 2 = $2"
 for (( m=${#_1}; m>0; m-- )); do
  for (( n=0; n<${#2}; n++ )); do
   if [ "${_1:m:1}" = "${2:n:1}" ]; then
    #echo " n = $n ; m = $m"
    _N=$((${#2} - $n))
    contains "${_1:0:m}" "."
    [ $? -eq 0 ] && echo ${_1:0:m}.${2:n:$_N} || echo ${_1:0:m}${2:n:$_N}
    break
   fi
  done
 done | sort | uniq -c | sort -k1 -g | tail -n1 | awk '{ print $2 }' > adjacent_prononc_with_API.res
 #done
_RES=`cat adjacent_prononc_with_API.res`
echo $_RES | grep -o "[[:alpha:]]\." | tr -d '.' | sort | uniq -c |  sort -k1 -g | awk '{ print $2 }' | while read _LETTER; do
 #[ "$_F3" -eq 1 ] && _RES=${_RES/i/ɥ}
 if [ `echo $_RES | grep "${_LETTER}\.${_LETTER}"` ]; then
  echo $_RES | sed -e "s/${_LETTER}\.${_LETTER}/${_LETTER}/" -e "s/i/ɥ/g" -e "s/\.\././"
 fi
done
#[ "$_F3" -eq 1 ] && _RES=${_RES/i/ɥ}
echo $_RES | sed -e "s/i/ɥ/g" -e "s/\.\././"
}
#adjacent_prononc_with_API "plø" "løz"
#adjacent_prononc_with_API "plə" "løz"

is_adjacent_prononc_with_API() {
 local n m
 _1=${1/ə/ø} || _1=${1/œ/ø}
 _1=${1/ɥ/i}
 local _I=0
 for (( m=${#_1}; m>0; m-- )); do
  for (( n=0; n<${#2}; n++ )); do
   if [ "${_1:m:1}" = "${2:n:1}" ]; then
    _I=$(($_I + 1))
   fi
  done
 done
 [ $_I -gt 0 ] && return 1 || return 0
}

echo "# Exécution de $0" :
_FILE=french.UTF-8.dic.wiktionary.prononcement.without_span.uniq
#_FILE=words_prons.all2

grep -v "#" toto | cut -d'|' -f1 | grep -v '-' | while read _WORD; do
#grep -v "#" recherche4 | cut -d'|' -f1 | grep -v '-' | while read _WORD; do
#grep -v "#" recherche5_2 | cut -d'|' -f1 | grep -v '-' | while read _WORD; do
 echo "WORD = $_WORD"
 _LAST_W_L=0
 for (( m=0; m<=${#_WORD}; m++ )); do
  for (( n=${#_WORD}; n>m; n-- )); do
   echo -n "${_WORD:m:n} "
   _PRON=`grep "^${_WORD:m:n}" $_FILE | cut -d'|' -f2 | grep . | sort | uniq -c | sort -k1 -g | tail -n1 | awk '{ print $2 }'`
   _W=`grep "|${_PRON}$" $_FILE | cut -d'|' -f1`
   if [ -n "$_PRON" ]; then
    _LAST_M=$(($m - 1))
    _RACINE=${_WORD:$_LAST_M:m}
    echo "WORD : ${_WORD:m:n}, PRON : $_PRON"
    _LAST_W="${_WORD:m:n}"
    _LAST_PRON="$_PRON"
    if [ $(($n -$m + 1)) -gt $_LAST_W_L ]; then
     echo "recherche partielle de ${_WORD:m:n}, prononciation trouvée pour $_W : $_PRON"
     _LAST_W_L=$(($n -$m + 1))
     [ -n "$_RACINE" ] && echo "${_RACINE}${_LAST_W}|${_RACINE}.${_LAST_PRON}" > debut.$$ || echo "${_LAST_W}|${_LAST_PRON}" > debut.$$
    fi
   fi
  done
 done

 declare -A SYLFIN
 for (( m=1; m<=${#_WORD}; m++ )); do
  for (( n=$((${#_WORD} - m)); n>0; n-- )); do
   #echo "_WORD:m:n = ${_WORD:m:n}"
   _PRON=`grep "${_WORD:m:n}" $_FILE | cut -d'|' -f2 | rev | cut -d'.' -f1 | rev | grep . | sort | uniq -c | sort -k1 -g | tail -n1 | awk '{ print $2 }'`
   _W=`grep "${_PRON}$" $_FILE | cut -d'|' -f1 | grep . | sort | uniq -c | sort -k1 -g | tail -n1 | awk '{ print $2 }'`
   if [ -n "$_PRON" ]; then
    #echo "WORD : ${_WORD:m:n}, PRON : $_PRON"
    #if [ $n -eq $((${#_WORD} - m)) ]; then
     #echo "recherche partielle de ${_WORD:m:n}, prononciation trouvée pour $_W : $_PRON"
     SYLFIN["${_WORD:m:n}"]="$_PRON"
    #fi
   else
    break
   fi
  done
 done
 for _I in "${!SYLFIN[@]}"; do
  echo "${_I}|${SYLFIN["$_I"]}|${#_I}"
 done | sort -k3 -t'|' -g | tail -n1 | cut -d'|' -f1-2 > fin.$$
 unset SYLFIN

 _W=`cat debut.$$ | cut -d'|' -f1`
 _W_SYLLABES=`grep "^${_W}|" french.UTF-8.dic.wiktionary.prononcement.without_span.uniq.silabas | cut -d'|' -f2`
 if [ -n "$_W_SYLLABES" ]; then
  echo -n "Une possibilité (1) : "
  echo "${_W_SYLLABES}|${_WORD}|"`cat debut.$$ | cut -d'|' -f2 | rev | cut -d'.' -f2- | rev``echo -n "."; cat fin.$$ | cut -d'|' -f2`
  echo -n "Une possibilité (2) : "
  _C=$((${_W_SYLLABES} - 1))
  [ "$_C" -gt 1 ] && echo "${_W_SYLLABES}|${_WORD}|"`eval "cat debut.$$ | cut -d'|' -f2 | cut -d'.' -f1-${_C}"``echo -n "."; cat fin.$$ | cut -d'|' -f2`
  #set -x
  _P1=`cat debut.$$ | cut -d'|' -f2 | rev | cut -d'.' -f2 | rev`
  _P2=`cat fin.$$ | cut -d'|' -f2`
  #set -x
  is_adjacent_prononc_with_API $_P1 $_P2
  if [ $? -eq 1 ]; then
   _P3=`adjacent_prononc_with_API $_P1 $_P2 | head -n1`
   echo -n "Une possibilité (3) : "
   [ "$_C" -gt 0 ] && echo "${_W_SYLLABES}|${_WORD}|"`eval "cat debut.$$ | cut -d'|' -f2 | cut -d'.' -f1-${_C}"`".$_P3"
  fi
  #set +x
 else
  echo -n "Une possibilité (1) : "
  echo "${_WORD}|"`cat debut.$$ | cut -d'|' -f2 | rev | cut -d'.' -f2- | rev``echo -n "."; cat fin.$$ | cut -d'|' -f2`
  #set -x
  #_P1=`cat debut.$$ | cut -d'|' -f2 | rev | cut -d'.' -f2 | rev`
  _P1=`cat debut.$$ | cut -d'|' -f2`
  _P2=`cat fin.$$ | cut -d'|' -f2`
  is_adjacent_prononc_with_API $_P1 $_P2
  if [ $? -eq 1 ]; then
   _P3=`adjacent_prononc_with_API $_P1 $_P2 | head -n1`
   echo -n "Une possibilité (3) : "
   #echo "${_WORD}|"`cat debut.$$ | cut -d'|' -f2 | rev | cut -d'.' -f3- | rev`".$_P3"
   echo "${_WORD}|$_P3"
  fi
  #set +x
 fi

 echo ""
 rm debut.$$ fin.$$
done
