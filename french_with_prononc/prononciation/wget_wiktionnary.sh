#_DIC=../french.UTF-8.dic
#_DIC=../vide
#_DIC=../recherche
#_DIC=../recherche2
#_DIC=../span.dic
_DIC=../tata
_SUFFIX=wiktionary.prononcement
>${_DIC}.${_SUFFIX}
IFS=";"
cat $_DIC | grep -v ' ' | cut -d'|' -f1 | sed -e 's:\\::g' | while read _LINE; do
 _WORD=`echo "$_LINE" | sed -e 's: :\&nbsp;:g'`
 _WG1=`wget -T 60 -t 2 https://fr.wiktionary.org/wiki/${_WORD}`
 echo -n "${_LINE}|" >> ${_DIC}.${_SUFFIX}
 if [ ! -n "$_WG1" ]; then
  _TOTO="<b>${_LINE}</b>.*\\\\(.*)\\\\"
  _1=`pcregrep -o1 $_TOTO "${_LINE}"* | head -n1`
  if [ -n "$_1" ]; then
   echo "$_1" >> ${_DIC}.${_SUFFIX}
   #rm -f "${_WORD}"* "*\&nbsp*"
   continue
  fi
  _TOTO="<span class=\"API\" title=\"Prononciation API\">\\\\(.*)\\\\</span>"
  _2=`pcregrep -o1 $_TOTO "${_LINE}"* | head -n1`
  if [ -n "$_2" ]; then
   echo "$_2" >> ${_DIC}.${_SUFFIX}
   #rm -f "${_WORD}"* "*\&nbsp*"
   continue
  fi
 fi
 echo "" >> ${_DIC}.${_SUFFIX}
done
sort -k1 -t"|" -u ${_DIC}.${_SUFFIX} | sponge ${_DIC}.${_SUFFIX}
