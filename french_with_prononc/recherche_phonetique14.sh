DEBUG=1
. ./fonctions_recherche_phonetique.sh
_FICP=french.UTF-8.dic.wiktionary.prononcement.without_span.uniq.withoutA-Z
#grep "|$" $_FICP | cut -d'|' -f1 | while read _WORD; do
 # Recherche de prononciations ressemblantes à $_WORD dans le dictionnaire"
 #_WORD="érythrodermie"
 #_WORD="anthoméduse"
 echo -n "${_WORD}|"
 _NBC=`echo "$_WORD" | wc -m`

 # verification si le mot n'a pas déjà un mot composé avec sa prononciation :
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
 [ "$DEBUG" -eq 1 ] && cat $_TMPB | cut -d'|' -f1 | uniq | awk '{ print length, $0 }' | sort -k1 -g | cut -d' ' -f2
 cat $_TMPB | cut -d'|' -f1 | uniq | awk '{ print length, $0 }' | sort -k1 -g | cut -d' ' -f2 | while read _W2; do
  _PF=`grep "^${_W2}|" $_TMPB | uniq | while IFS='|' read _W _P _S; do
   echo -n "${_P}."
  done`
  echo "$_PF"
 done | uniq > ~/tmp/1
 [ "$DEBUG" -eq 1 ] && cat ~/tmp/1
 _NBP=`cat ~/tmp/1 | wc -l`
 _II=0
 cat ~/tmp/1 | while read _PF1; do
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
 [ "$DEBUG" -eq 1 ] && cat $_TMPE | cut -d'|' -f1 | uniq | awk '{ print length, $0 }' | sort -k1 -g | cut -d' ' -f2
 cat $_TMPE | cut -d'|' -f1 | uniq | awk '{ print length, $0 }' | sort -k1 -g | cut -d' ' -f2 | while read _W2; do
  _PF=`grep "^${_W2}|" $_TMPE | uniq | while IFS='|' read _W _P _S; do
   echo -n "${_P}."
  done`
  echo "$_PF"
 done | uniq > ~/tmp/1
 [ "$DEBUG" -eq 1 ] && cat ~/tmp/1
 _NBP=`cat ~/tmp/1 | wc -l`
 _II=0
 cat ~/tmp/1 | while read _PF1; do
  if [ `echo "$_PF1" | tr '.' '\n' | wc -l` -gt 2 ]; then
   echo "$_PF1"
   break
  else
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
  fi
  [ "$_II" -eq "$_NBP" ] && echo "$_PF2" | rev | cut -c2- | rev
 done
 fi

 echo "-------"
#done
