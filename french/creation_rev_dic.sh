# Création de fichiers dictionnaires dont la longueur des mots est fixe
_LANG=french
mkdir gnuplot 2>/dev/null
mkdir dics 2>/dev/null
mkdir rimes 2>/dev/null

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_DIR_PREFIX="dics"; _PREFIX="${_LANG}.UTF-8"

# Transformer en UTF-8 tout d'abord car plus simple à manipuler :
iconv -f UTF-16 -t UTF-8//TRANSLIT ../dela-fr-public.dic | awk -F',' '{ printf ("%s\n",$1); }' | sort -u > ${_DIR_PREFIX}/${_PREFIX}.dic
# Construire le dictionnaire inversé :
cat ${_DIR_PREFIX}/${_PREFIX}.dic | tr -d '\\' | rev | sort -u | sed -e 's/-/\\-/g' > ${_DIR_PREFIX}/${_PREFIX}.rev.dic

# Optimiser la recherche en créant des indexes (a partir de ${_DIR_PREFIX}/${_PREFIX}.dic et en conservant le \- pour grep) :
echo "Construction des fichiers d'indexes d'après ${_DIR_PREFIX}/${_PREFIX}.dic :"
for _I in {2..70}; do
 if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic ]; then
  echo "Construction de ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic de mots contenant $_I lettres depuis le début des mots trouvés dans ${_DIR_PREFIX}/${_PREFIX}.dic"
  cat ${_DIR_PREFIX}/${_PREFIX}.dic | tr -d '\\' | awk -v _val=${_I} '{ lgn=length($0); if (lgn == _val) { print $0 } }' | sort -u | sed -e 's/-/\\-/g' > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic &
 fi
 if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.debut_dic ]; then
  echo " ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.debut_dic en cours.."
  cat ${_DIR_PREFIX}/${_PREFIX}.dic | tr -d '\\' | awk -v _val=${_I} '{ print substr($0,1,_val); }' | sort -u | sed -e 's/ $//' | awk -v _val=${_I} '{ lgn=length($0); if (lgn == _val) { print $0 } }' | sed -e 's/-/\\-/g' > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.debut_dic &
 fi
 if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.dic ]; then
  echo " ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.dic en cours à partir de ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic.."
  cat ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic | tr -d '\\' | rev | sort -u | sed -e 's/-/\\-/g' > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.dic &
 fi
 if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.debut_dic ]; then
  echo " ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.debut_dic en cours.."
  cat ${_DIR_PREFIX}/${_PREFIX}.dic | tr -d '\\' | rev | awk -v _val=${_I} '{ print substr($0,1,_val); }' | sort -u | sed -e 's/ $//' | awk -v _val=${_I} '{ lgn=length($0); if (lgn == _val) { print $0 } }' | sed -e 's/-/\\-/g' > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.debut_dic &
 fi
 #if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.dic ]; then
  #echo " ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.dic en cours.."
  #sed 's/^/^/' ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.dic > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.dic
 #fi
 #if [ ! -f ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.rev.dic ]; then
  #echo " ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.rev.dic en cours.."
  #sed 's/^/^/' ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.rev.dic > ${_DIR_PREFIX}/${_PREFIX}.1-${_I}.carret.rev.dic
 #fi
done
wait
