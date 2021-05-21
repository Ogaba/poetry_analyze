_DIC=../french.UTF-8.dic
#_DIC=../vide
#_DIC=../recherche
_SUFFIX=le-dictionnaire.prononcement
>${_DIC}.${_SUFFIX}
IFS=";"
cat $_DIC | grep -v ' ' | cut -d'|' -f1 | sed -e 's:\\::g' | while read _LINE; do
 _WORD=`echo "$_LINE" | sed -e 's: :\&nbsp;:g'`
 _WG1=`wget -T 60 -t 2 -O "$_LINE" https://www.le-dictionnaire.com/definition/${_WORD}`
 echo -n "${_LINE}|" >> ${_DIC}.${_SUFFIX}
 if [ ! -n "$_WG1" ]; then
  _1=`pcregrep -o1 "<div class=\"motboxinfo\">\[(.*)\]" "${_LINE}"* | head -n 1`
  if [ -n "$_1" ]; then
   echo "$_1" >> ${_DIC}.${_SUFFIX}
   rm -f "${_LINE}"* "*\&nbsp*"
   continue
  fi
 fi
 echo "" >> ${_DIC}.${_SUFFIX}
done
sort -k1 -t"|" -u ${_DIC}.${_SUFFIX} | sponge ${_DIC}.${_SUFFIX}
