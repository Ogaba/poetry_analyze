#_DIC=../french.UTF-8.dic.wiktionary.prononcement.without_span.uniq.une_syllabe
_DIC=../french.UTF-8.dic.wiktionary.prononcement.without_span.uniq
_SUFFIX=silabas
>${_DIC}.${_SUFFIX}
IFS="|"
cat $_DIC | grep -v ' ' | cut -d'|' -f1 | sed -e 's:\\::g' | while read _LINE; do
 rm -f "${_LINE}"* "*\&nbsp*"
 _WORD=`echo "$_LINE" | sed -e 's: :\&nbsp;:g'`
 _WG1=`wget -T 60 -t 2 -O "$_LINE" https://www.silabas.net/index-fr.php?p=${_WORD}`
 echo -n "${_LINE}|" >> ${_DIC}.${_SUFFIX}
 if [ ! -n "$_WG1" ]; then
  _1=`pcregrep -o2 "<li>Combien de syllabes dans (.*)? <strong>(.*) syllabe" "${_LINE}"`
  if [ -n "$_1" ]; then
   echo "$_1" >> ${_DIC}.${_SUFFIX}
   rm -f "${_LINE}"* "*\&nbsp*"
   continue
  fi
 fi
 echo "" >> ${_DIC}.${_SUFFIX}
done
sort -k1 -t"|" -u ${_DIC}.${_SUFFIX} | sponge ${_DIC}.${_SUFFIX}
