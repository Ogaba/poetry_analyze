#!/bin/bash
trap 'echo "Signal recu, purge et sortie."; f_purge; exit 0' KILL TRAP HUP INT QUIT ABRT SYS
# Recherche de rimes sonores en fin de mot dans un dictionnaire
_LANG=french

# Pour que les commandes rev ne plante pas
export LC_ALL=fr_FR.UTF-8

# Variables
_PREFIX="${_LANG}.UTF-8.dic"
_SUFFIX="fin_rimes_sonores"
#_DIC_NAME="wiktionary.prononcement.without_span.uniq"
_DIC_NAME="prononcement.all"

f_purge() {
echo " purge"
rm -f ${_SUFFIX}.log.* pron_fin.* gnuplot/pron.fin.*.freq
}

# Main
for _P in {1..3}; do
	>${_SUFFIX}.log.${_P}
	echo "Recherche en cours de rimes sonores en fin de mot de profondeur $_P."
	>pron_fin.${_P}
	if [ "$_P" -eq 3 ]; then
	cat $_PREFIX.$_DIC_NAME | while IFS='|' read _WO _PR; do
		eval "echo "$_PR" | rev | cut -d'.' -f1-${_P} | rev" | grep "\..*\."
	done >> pron_fin.${_P}
	fi
	if [ "$_P" -eq 2 ]; then
	cat $_PREFIX.$_DIC_NAME | while IFS='|' read _WO _PR; do
		eval "echo "$_PR" | rev | cut -d'.' -f1-${_P} | rev" | grep "\."
	done >> pron_fin.${_P}
	fi
	if [ "$_P" -eq 1 ]; then
	cat $_PREFIX.$_DIC_NAME | while IFS='|' read _WO _PR; do
		eval "echo "$_PR" | rev | cut -d'.' -f1 | rev"
	done >> pron_fin.${_P}
	fi
	sort pron_fin.${_P} | grep . | uniq -c | sponge pron_fin.${_P}
	echo " prononciations trouvées :"
	wc -l pron_fin.${_P}
	echo " génération des données pour gnuplot :"
	sort -k1 -g -r pron_fin.${_P} | awk '{ print NR " " $1 }' > gnuplot/pron.fin.${_P}.freq
	echo " classement des listes de rimes sonores dans un fichier :"
	cat pron_fin.${_P} | awk '{ print $2 }' | while read _PRON; do
		echo -n "$_PRON : " >> ${_SUFFIX}.log.${_P}
		grep "\.${_PRON}$" $_PREFIX.$_DIC_NAME | while IFS='|' read _WO _PR; do
			echo -n "${_WO}," >> ${_SUFFIX}.log.${_P}
		done
		grep "|${_PRON}$" $_PREFIX.$_DIC_NAME | while IFS='|' read _WO _PR; do
			echo -n "${_WO}," >> ${_SUFFIX}.log.${_P}
		done
		echo "" >> ${_SUFFIX}.log.${_P}
	done
	sed -i "s/\,$//" ${_SUFFIX}.log.${_P}
done

# Résultat
echo " résultats trouvés :"
wc -l ${_SUFFIX}.log.*

# Purge
f_purge	
