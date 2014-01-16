#!/bin/bash

#keep the results in a .txt file
#exec >resultatflux.txt

# just put in a variable to have the clearest code
url_flux1="http://www.sport.fr/RSS/sport1.xml"
url_flux2="http://rss.leparisien.fr/leparisien/rss/une.xml"

function rss1() {
echo "------- Résultats du flux choisi n°1 : " 
curl -s  "$url_flux1" | grep -E -m 1 "(title>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' 
echo
curl -s  "$url_flux1" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g'  | sed -e '1d'
echo
echo
echo
echo
echo "------- Résultats du flux choisi n°2 : "
echo
}

function rss2() {
curl -s  "$url_flux2" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g' 
echo
}

rss1 - > rss1.txt
rss2 - > rss2.txt

function filter() {
cat rss2.txt | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g' 
}

filter - > rss2b.txt

cat rss2b.txt >> rss1.txt
   
# send the content of a text file by mail :
#function mail() {
#mail -s "Flux RSS Quotidiens" ayako.dumont@gmail.com < resultatflux4.txt
#}

# if just want to send a mail
#echo "Bonjour, voici le contenu des flux que vous avez choisis :" | mail -s "Flux RSS : News" ayako.dumont@gmail.com

# execute fluxrss.sh everyday at 9:oo
#function freq() {
#crontab -e
#0 9 * * * fluxrss.sh
#}