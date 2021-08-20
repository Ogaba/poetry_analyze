#!/bin/bash
trap 'echo "Signal recu, purge et sortie."; f_purge * *; exit 0' KILL TRAP HUP INT QUIT ABRT SYS
# Recherche de rimes glissantes dans un dictionnaire
_LANG=french

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_DIR_PREFIX="dics"
_DIR_SUFFIX="rimes"
_PREFIX="${_LANG}.UTF-8"

f_purge() {
echo " purge de exec.g*.*.sh"
rm -f exec.g*.*.sh
echo " purge de words.$1.$2/*"
for _L in {{a..z},{A..Z},é,ê,è,à,ç,ù,û,â,ô,ö,û,ü,î,ï}; do
 rm -Rf words.$1.$2/words.${_L}* 2>/dev/null
done
rm -Rf words.$1.$2/* 2>/dev/null
if [ ! -f ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$_J.rimes ]; then
 echo " purge de ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$_J.rimes"
 rm -f ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$_J.rimes
fi
}

# 1ere partie
for (( _I=1; _I<=15; _I++ )); do
 for (( _J=1; _J<=25; _J++ )); do

  if [ $_J -gt $_I ]; then
   echo "Génération de ${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic sur la base de ${_DIR_PREFIX}/${_PREFIX}.1-${_J}.dic"
   _EXEC="exec.g${_I}.${_J}.sh"
   >$_EXEC
   echo ">${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic" >> $_EXEC
   echo "cat ${_DIR_PREFIX}/${_PREFIX}.1-${_J}.dic | tee\\" >> $_EXEC
   for (( _K=1; _K<=$(($_J-$_I+1)); _K++ )); do
    _RECORDS=""
    for (( _M=$_K; _M<=$(($_I+$_K-1)); _M++ )); do
     _RECORDS="$_RECORDS \$${_M} "
    done
    echo " >(awk 'BEGIN{ FS=\"\" } { print" $_RECORDS "}' | sort -u)\\" >> $_EXEC
   done
   echo "&>/dev/null" >> $_EXEC
   chmod u+x ./$_EXEC
   ./$_EXEC 1>${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic 2>&1
  fi

 done
done

# 2nd partie
for (( _I=1; _I<=15; _I++ )); do
 for (( _J=1; _J<=25; _J++ )); do

  if [ $_J -eq $_I ]; then
   echo "1" > ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$_J.rimes
  elif [ $_J -gt $_I ]; then
   if [ ! -f ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$_J.rimes ]; then
    if [ `cat ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-$(($_J-1)).rimes | wc -l` -gt 0 ]; then
     cat ${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic | sed -e 's/^-/\\-/' -e 's/^\\/\\\\/' -e 's/\\$//' -e 's/^ //' | sort -u | sponge ${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic
     # Create directory or delete files allready in it (and rimes associated)
     mkdir words.${_I}.${_J} 2>/dev/null || f_purge $_I $_J

     echo "Recherche de tous les mots de ${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic dans ${_DIR_PREFIX}/${_PREFIX}.1-${_J}.dic"
     cat ${_DIR_PREFIX}/${_PREFIX}.${_I}.${_J}.uniq.dic | while IFS="|" read -a _WORD; do
      grep "$_WORD" ${_DIR_PREFIX}/${_PREFIX}.1-${_J}.dic > words.${_I}.${_J}/words."`echo "$_WORD" | sed 's:\\\::g'`" &
     done
     wait

     echo "Recherche de mots contenant $_I lettres consécutives glissantes dans ${_DIR_PREFIX}/${_PREFIX}.1-${_J}.dic"
     _EXEC="exec.g${_I}.${_J}.sh"
     >$_EXEC
     echo ">${_DIR_SUFFIX}/${_PREFIX}.g${_I}-${_J}.rimes" >> $_EXEC
     echo "ls words.${_I}.${_J}/ | while IFS=\"|\" read _FIC; do" >> $_EXEC
     echo "_EXT=\`echo \$_FIC | cut -d'.' -f2\`" >> $_EXEC
     for (( _K=1; _K<=$(($_J-$_I+1)); _K++ )); do
      echo -n "_${_K}=\`grep \"^" >> $_EXEC
      for (( _L=0; _L<$(($_K-1)); _L++ )); do
       echo -n "[[:alnum:]]" >> $_EXEC
      done
      echo -n "\${_EXT}" >> $_EXEC
      for (( _L=$(($_J-$_I+1-$_K)); _L>0; _L-- )); do
       echo -n "[[:alnum:]]" >> $_EXEC
      done
      echo "\$\" \"words.${_I}.${_J}/\$_FIC\" | head -n 1\`" >> $_EXEC
      echo "if [ -n \"\$_${_K}\" ]; then" >> $_EXEC
     done
     echo ""
     echo -n "echo \"" >> $_EXEC
     for (( _K=1; _K<=$(($_J-$_I+1)); _K++ )); do
      echo -n "\$_${_K};" >> $_EXEC
     done
     echo "\" >> ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-${_J}.rimes" >> $_EXEC
     for (( _K=1; _K<=$(($_J-$_I+1)); _K++ )); do
      echo "fi"  >> $_EXEC
     done
     echo "done" >> $_EXEC
     chmod u+x ./$_EXEC && ./$_EXEC

     echo "Nombre de rimes glissantes minimales composées de ${_I} caractères et en séquence glissante dans des mots de ${_J} caractères :"
     wc -l ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-${_J}.rimes

     echo " dont nombres de mots composés"
     ls ${_PREFIX}.g${_I}-${_J}.rimes | while read _F; do
      echo "dans $_F :" `grep -E " |-" $_F | wc -l`
     done

     # Purge files and delete directory
     f_purge $_I $_J && rmdir words.${_I}.${_J} 2>/dev/null
    else
     break
    fi
   else
    echo "Fichier de rimes ${_DIR_SUFFIX}/${_PREFIX}.g${_I}-${_J}.rimes déjà généré."
   fi
  fi

 done
done
