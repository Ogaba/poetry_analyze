contains() { echo "$1" | grep "${2}" 1>/dev/null 2>&1 && return 0 || return 1; }
contains_from_begin() { echo "$1" | grep "^${2}" 1>/dev/null 2>&1 && return 0 || return 1; }
contains_from_end() { echo "$1" | grep "${2}$" 1>/dev/null 2>&1 && return 0 || return 1; }

complement() { echo "$1" | pcregrep -u -o2 "($2)(.*)" 2>/dev/null; }

is_utf8() {
 local _1
 _1=`echo "$1" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null`
 [ "$_1" = "$1" ] && return 1 || return 0
}

adjacent_pron() {
 # $1 : prononciation de gauche
 # $2 : prononciation de droite
 local _G _D _PPG
 _G=`echo $1 | rev | cut -d'.' -f1 | rev`
 _D=`echo $2 | cut -d'.' -f1`
 _PPG=`echo $1 | rev | cut -d'.' -f2- | rev`
 [ "$_G" = "$_D" ] && echo "${_PPG}.${2}"
}

is_adjacent_pron() {
 # $1 : prononciation de gauche
 # $2 : prononciation de droite
 local _G _D
 _G=`echo $1 | rev | cut -d'.' -f1 | rev`
 [ "$DEBUG" -eq 1 ] && echo -n "_G = $_G, "
 _D=`echo $2 | cut -d'.' -f1`
 [ "$DEBUG" -eq 1 ] && echo -n "_D = $_D, "
 [ "$_G" = "$_D" ] && return 1 || return 0
}

find_uniq_word() {
 # $1 : le mot a rechercher
 # $2 : dans le dictionnaire
 local n m _W _P
 for (( m=1; m<=${#1}; m++ )); do
  for (( n=$((${#1} - m)); n>0; n-- )); do
   _W=`grep "^${1:m:n}|" $2 | cut -d'|' -f1`
   if [ -n "$_W" ]; then
    _P=`grep "^${1:m:n}|" $2 | cut -d'|' -f2`
    echo "$_W|$_P"
    return 0
   fi
  done
 done
}

function evaluate_begin() {
 # $1 : mot à évaluer
 # $2 : fichier de prononciation
 # $3 : position
 if [ -f $2 ]; then
  _TMPF=~/tmp/$$.evaluate_begin.tmp
  _TMPF2=~/tmp/$$.evaluate_begin.2.tmp
  grep "^$1" $2 | grep -v "|$" > $_TMPF
  grep "^${1}|" $2 | grep -v "|$" > $_TMPF2
  if [ `cat $_TMPF | wc -l` -gt 0 ]; then
   #[ "$DEBUG" -eq 1 ] && echo -n "1 = $1"
   _WC=`eval "cat $_TMPF | cut -d'|' -f2 | cut -d'.' -f$3 | sort | uniq -c | wc -l"`
   _MAX=`eval "cat $_TMPF | cut -d'|' -f2 | cut -d'.' -f$3 | sort | uniq -c | sort -k1 -g | tail -n 1 | awk '{ print \\$1 }'"`
   _PRON=`eval "cat $_TMPF | cut -d'|' -f2 | cut -d'.' -f$3 | sort | uniq -c | sort -k1 -g | tail -n 1 | awk '{ print \\$2 }'"`
   #[ "$DEBUG" -eq 1 ] && echo -n "_WC = $_WC, "
   #[ "$DEBUG" -eq 1 ] && echo -n "_MAX = $_MAX, "
   #[ "$DEBUG" -eq 1 ] && echo -n "_PRON = $_PRON, "
   _DIV=`echo "$_MAX/$_WC + 2 - $3" | bc`
   #[ "$DEBUG" -eq 1 ] && echo "_DIV = $_DIV"
   if [ -s $_TMPF2 ]; then
    _PRON=`cat $_TMPF2 | cut -d'|' -f2`
    [ -n "$_PRON" ] && echo "$1|$_PRON|`echo ${#1}*10|bc`"
   else
    if (( $(echo "$_DIV > 1" | bc) )); then
     [ -n "$_PRON" ] && echo "$1|$_PRON|$_DIV"
    fi
   fi 
  fi
  rm -f $_TMPF $_TMPF2 2>/dev/null
 else
  echo "Fichier de prononciation absent !"
 fi
}

function evaluate_end() {
 # $1 : mot à évaluer
 # $2 : fichier de prononciation
 # $3 : position
 if [ -f $2 ]; then
  _TMPF=~/tmp/$$.evaluate_end.tmp
  _TMPF2=~/tmp/$$.evaluate_end.2.tmp
  grep "$1|" $2 | grep -v "|$" > $_TMPF
  grep "^${1}|" $2 | grep -v "|$" > $_TMPF2
  if [ `cat $_TMPF | wc -l` -gt 0 ]; then
   #[ "$DEBUG" -eq 1 ] && echo -n "1 = $1"
   _WC=`eval "cat $_TMPF | cut -d'|' -f2 | rev | cut -d'.' -f$3 | rev |  sort | uniq -c | wc -l"`
   _MAX=`eval "cat $_TMPF | cut -d'|' -f2 | rev | cut -d'.' -f$3 | rev |  sort | uniq -c | sort -k1 -g | tail -n 1 | awk  '{ print \\$1 }'"`
   _PRON=`eval "cat $_TMPF | cut -d'|' -f2 | rev | cut -d'.' -f$3 | rev |  sort | uniq -c | sort -k1 -g | tail -n 1 | awk  '{ print \\$2 }'"`
   #[ "$DEBUG" -eq 1 ] && echo -n "_WC = $_WC, "
   #[ "$DEBUG" -eq 1 ] && echo -n "_MAX = $_MAX, "
   #[ "$DEBUG" -eq 1 ] && echo -n "_PRON = $_PRON, "
   _DIV=`echo "$_MAX/$_WC + 2 - $3" | bc`
   #[ "$DEBUG" -eq 1 ] && echo "_DIV = $_DIV"
   if [ -s $_TMPF2 ]; then
    _PRON=`cat $_TMPF2 | cut -d'|' -f2`
    [ -n "$_PRON" ] && echo "$1|$_PRON|`echo ${#1}*10|bc`"
   else
    if (( $(echo "$_DIV > 1" | bc) )); then
     [ -n "$_PRON" ] && echo "$1|$_PRON|$_DIV"
    fi
   fi
  fi
  rm -f $_TMPF $_TMPF2 2>/dev/null
 else
  echo "Fichier de prononciation absent !"
 fi
}

f_count_pron() {
# $1 : fichier d'apparition statistique de prononciations
>~/tmp/count
cat $1 | cut -d'|' -f1 | uniq | while read _W2; do
 _PF=""
 _PF=`grep "^${_W2}|" $1 | uniq | cut -d'|' -f2 | while read _P; do
  echo -n "${_P}."
 done`

 grep "^${_W2}|" $1 | uniq | cut -d'|' -f3 | tr '\n' '+' > ~/tmp/sum
 sed -i 's/+$/\n/' ~/tmp/sum
 echo "$_PF|"`cat ~/tmp/sum | bc`
done >> ~/tmp/count

>~/tmp/countf
cat ~/tmp/count | cut -d'|' -f1 | uniq | while read _P2; do
 grep "^${_P2}|" ~/tmp/count | uniq | cut -d'|' -f2 | tr '\n' '+' > ~/tmp/sum
 sed -i 's/+$/\n/' ~/tmp/sum
 echo "$_P2|"`cat ~/tmp/sum | bc`
done >> ~/tmp/countf

_SEUIL=`sort -t'|' -k2 -g ~/tmp/countf | tail -n1 | cut -d'|' -f2`
if [ -n "$_SEUIL" ]; then
 [ $_SEUIL -gt 30 ] && grep $_SEUIL ~/tmp/countf | sort -t'|' -k2 -g | tail -n1 | cut -d'|' -f1
fi
}
