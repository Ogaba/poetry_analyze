# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8
# Chargement des fonctions communes
. ./fonctions_recherche_phonetique.sh

consolidate_prononc() {
 local _m _w1 _w2 _NBSYL
 _NBSYL=`echo $1 | tr -c -d "." | wc -m`
 for (( _m=1; _m<=$(($_NBSYL + 1)); _m++ )); do
  _w1=`eval "echo $1 | cut -d'.' -f${_m}"`
  if [ -n "$_w2" ]; then
   [ "$_w1" = "$_w2" ] || echo -n "${_w1}."
  else
   echo -n "${_w1}."
  fi
  _w2="$_w1"
 done | sed 's/\.$//'
}

consolidate_prononc2() {
 local _m _w1 _w2 _NBSYL
 _NBSYL=`echo $1 | tr -c -d "." | wc -m`
 for (( _m=1; _m<=$(($_NBSYL + 1)); _m++ )); do
  _w1=`eval "echo $1 | cut -d'.' -f${_m}"`
  if [ -n "$_w2" ]; then
   contains_from_begin "$_w1" "$_w2" && [ "$_w1" != "$_w2" ] && echo -n "`complement ${_w1} ${_w2}`"
   contains_from_begin "$_w1" "$_w2" || echo -n "${_w1}."
  else
   echo -n "${_w1}."
  fi
  _w2="$_w1"
 done | sed 's/\.$//'
}

consolidate_prononc3() {
 local _m _w1 _w2 _1l_w1 _1l_w2 _first_w2 _NBSYL
 _NBSYL=`echo $1 | tr -c -d "." | wc -m`
 [ $_NBSYL -gt 1 ] && eval "echo -n $1 | cut -d'.' -f1-$((${_NBSYL} - 1))" | tr "\n" "."
 for (( _m=$_NBSYL; _m<=$(($_NBSYL + 1)); _m++ )); do
  [ $_NBSYL -eq 0 ] && _w1="" || _w1=`eval "echo $1 | cut -d'.' -f${_m}"`
  if [ -n "$_w2" ]; then
   _1l_w2=`echo $_w2 | rev | cut -c1`
   is_utf8 "$_1l_w2"
   if [ $? -eq 1 ]; then   
    # non UTF8 prononc
    _1l_w1=`echo $_w1 | cut -c1`
    _first_w2=`echo $_w2 | rev | cut -c2- | rev`
   else
    # UTF8 prononc
    _1l_w2=`echo $_w2 | rev | cut -c1-2`    
    _1l_w1=`echo $_w1 | cut -c1-2`
    _first_w2=`echo $_w2 | rev | cut -c3- | rev`
   fi
   [ "$_1l_w1" = "$_1l_w2" ] && echo -n "${_first_w2}.${_w1}" || echo -n "${_w2}.${_w1}"
  fi
  _w2="$_w1"
 done
}

#_FILE=test.log
_FILE=recherche_phonetique15.div_sup1_seuil_sup30.new2.log
cat $_FILE | grep -v "#" | while IFS="|" read _W _P; do
 _3=`consolidate_prononc "$_P"`
 if [ "$_3" = "$_P" ]; then
  _2=`consolidate_prononc2 "$_3"`
  if [ "$_2" = "$_P" ]; then
   _1=`consolidate_prononc3 "$_2"`
   [ "$_1" = "$_P" ] && echo "$_W|$_P" || echo "$_W|$_1"
  else
   _2=`echo "$_2" | sed "s/\.\([[:alpha:]]\)$/\1/"`
   echo "$_W|$_2"
  fi
 else
  echo "$_W|$_3"
 fi
done
