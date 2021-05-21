trap 'echo "Signal recu, purge et sortie."; f_purge; exit 0' KILL TRAP HUP INT QUIT ABRT SYS

f_purge() {
echo " purge de ~/tmp/*.evaluate_*.tmp"
rm -f ~/tmp/*.evaluate_*.tmp 2>/dev/null
}

DEBUG=0
# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8
# Chargement des fonctions communes
. ./fonctions_recherche_phonetique.sh
# Fichier de dictionnaire
_FICP=french.UTF-8.dic.wiktionary.prononcement.without_span.uniq.withoutA-Z

# Main
grep "|$" $_FICP | cut -d'|' -f1 | while read _WORD; do
 # Recherche de prononciations ressemblantes à $_WORD dans le dictionnaire"
 #_WORD="érythrodermie"
 #_WORD="anthoméduse"
 #_WORD="acétabulaire"
 #_WORD="absorptiométrie"
 #_WORD="acariasis"
 #_WORD="acyltransférase"
 #_WORD="anthropotechnique"
 #_WORD="acrylonitrile"
 echo -n "${_WORD}|"
 _NBC=`echo "$_WORD" | wc -m`

 # verification si le mot n'a pas déjà un mot composé avec sa prononciation :
 >~/tmp/wordc
 for (( _M=1; _M<$((${#_WORD} - 1)); _M++ )); do
  _WORDC=`grep "${_WORD:0:$_M}\-${_WORD:$_M:$((${#_WORD} - $_M - 1))}" $_FICP`
  #[ "$DEBUG" -eq 1 ] && echo "${_WORD:0:$_M}\-${_WORD:$_M:$((${#_WORD} - $_M - 1))}"
  if [ -n "$_WORDC" ]; then
   echo "$_WORDC" | cut -d'|' -f2
   break
  fi
 done > ~/tmp/wordc

 if [ -s ~/tmp/wordc ]; then
  cat ~/tmp/wordc
  rm ~/tmp/wordc
 else
 # sinon :
 _MIDDLE=`echo "$_NBC / 2" | bc`
 _TMPB=~/tmp/evaluate_begin_middle.tmp; >$_TMPB
 _TMPE=~/tmp/evaluate_middle_end.tmp; >$_TMPE
 for (( _M=$(($_MIDDLE / 2)); _M>=0; _M-- )); do
  evaluate_begin ${_WORD:0:$(($_MIDDLE - $_M))} $_FICP 1 >> $_TMPB
  evaluate_begin ${_WORD:0:$(($_MIDDLE - $_M))} $_FICP 2 >> $_TMPB
  evaluate_begin ${_WORD:0:$(($_MIDDLE - $_M))} $_FICP 3 >> $_TMPB
  evaluate_end ${_WORD:$(($_MIDDLE - $_M)):$(($_MIDDLE + $_M))} $_FICP 3 >> $_TMPE
  evaluate_end ${_WORD:$(($_MIDDLE - $_M)):$(($_MIDDLE + $_M))} $_FICP 2 >> $_TMPE
  evaluate_end ${_WORD:$(($_MIDDLE - $_M)):$(($_MIDDLE + $_M))} $_FICP 1 >> $_TMPE  
 done
 for (( _M=1; _M<=$(($_MIDDLE / 2)); _M++ )); do
  evaluate_begin ${_WORD:0:$(($_MIDDLE + $_M))} $_FICP 1 >> $_TMPB
  evaluate_begin ${_WORD:0:$(($_MIDDLE + $_M))} $_FICP 2 >> $_TMPB
  evaluate_begin ${_WORD:0:$(($_MIDDLE + $_M))} $_FICP 3 >> $_TMPB 
  evaluate_end ${_WORD:$(($_MIDDLE + $_M)):$(($_MIDDLE - $_M))} $_FICP 3 >> $_TMPE
  evaluate_end ${_WORD:$(($_MIDDLE + $_M)):$(($_MIDDLE - $_M))} $_FICP 2 >> $_TMPE
  evaluate_end ${_WORD:$(($_MIDDLE + $_M)):$(($_MIDDLE - $_M))} $_FICP 1 >> $_TMPE
 done

 # solution pour le debut de mot
 >~/tmp/debut
 #[ "$DEBUG" -eq 1 ] && cat $_TMPB | uniq | cut -d'|' -f1 | uniq | cut -d' ' -f2
 cat $_TMPB | cut -d'|' -f1 | uniq | cut -d' ' -f2 | while read _W2; do
  _PF=`grep "^${_W2}|" $_TMPB | uniq | while IFS='|' read _W _P _S; do
   echo -n "${_P}."
  done`
  echo "$_PF"
 done > ~/tmp/debut
 [ "$DEBUG" -eq 1 ] && cat ~/tmp/debut
 _NBP=`cat ~/tmp/debut | wc -l`
 _PF2=""
 _II=0
 cat ~/tmp/debut | while read _PF1; do
  _II=$(($_II + 1))
  if [ -n "$_PF2" ]; then
   contains_from_begin "$_PF1" "$_PF2"
   if [ $? -eq 0 ]; then
    _PF2="$_PF1"
   else
    _NP1=`echo "$_PF1" | awk -F'.' '{ print NF-1 }'`
    _NP2=`echo "$_PF2" | awk -F'.' '{ print NF-1 }'`
    [ "$_NP2" -eq "$_NP1" ] && _PF2="$_PF1"
   fi
  else
   _PF2="$_PF1"
  fi
  [ "$_II" -eq "$_NBP" ] && echo -n "$_PF2"
 done

 # solution pour la fin de mot
 # 1ère analyse
 _PF2=`f_count_pron $_TMPE`
 if [ -n "$_PF2" ]; then
  echo "$_PF2" | cut -d'|' -f1
 else
 # 2nd analyse
 >~/tmp/fin
 [ "$DEBUG" -eq 1 ] && cat $_TMPE | cut -d'|' -f1 | uniq | head -n1 | cut -d' ' -f2
 cat $_TMPE | cut -d'|' -f1 | uniq | head -n1 | cut -d' ' -f2 | while read _W2; do
  _PF=`grep "^${_W2}|" $_TMPE | uniq | while IFS='|' read _W _P _S; do
   echo -n "${_P}."
  done`
  echo "$_PF"
 done > ~/tmp/fin
 [ "$DEBUG" -eq 1 ] && cat ~/tmp/fin
 _NBP=`cat ~/tmp/fin | wc -l`
 _II=0
 cat ~/tmp/fin | while read _PF1; do
  _II=$(($_II + 1))
  if [ -n "$_PF2" ]; then
   contains_from_end "$_PF1" "$_PF2"
   if [ $? -eq 0 ]; then
    _PF2="$_PF1"
   else
    _NP1=`echo "$_PF1" | awk -F'.' '{ print NF-1 }'`
    _NP2=`echo "$_PF2" | awk -F'.' '{ print NF-1 }'`
    [ "$_NP2" -eq "$_NP1" ] && _PF2="$_PF1"
   fi
  else
   _PF2="$_PF1"
  fi
  [ "$_II" -eq "$_NBP" ] && echo "$_PF2" | rev | cut -c2- | rev
 done
 fi

 fi
 echo "-------"
done
