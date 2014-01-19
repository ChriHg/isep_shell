#!/bin/bash





# just put in a variable to have the clearest code
url_flux1="http://www.sport.fr/RSS/sport1.xml"
url_flux2="http://rss.leparisien.fr/leparisien/rss/une.xml"

############### RRS 1 ############### 
function showTitleAndDescriptionOfURL1() {
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

############### RRS 2 ############### 
function showTitleAndDescriptionOfURL2() {
curl -s  "$url_flux2" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g' 
echo
}

############### Creation of .txt files ############### 
showTitleAndDescriptionOfURL1 - > titleAndDescriptionOfURL1.txt
showTitleAndDescriptionOfURL2 - > titleAndDescriptionOfURL2.txt

############### Filter CDATA in URL2 ############### 
function filterCDATA() {
cat titleAndDescriptionOfURL2.txt | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g' 
}

############### Fusion of .txt files ############### 
filterCDATA - > titleAndDescriptionOfURL2-filtered.txt
cat titleAndDescriptionOfURL2-filtered.txt >> titleAndDescriptionOfURL1.txt

############### Refine text ############### 
function deleteSpaceBeforeLine() {
cat titleAndDescriptionOfURL1.txt | sed -e 's/^[ \t]*//g' | fold -w 80 -s
}
#-s : no cut a word in end of line

############### Final .txt ############### 
deleteSpaceBeforeLine - > yourRSSNews.txt
   
# send the content of a text file by mail :
#function mail() {
#mail -s "Flux RSS Quotidiens" ayako.dumont@gmail.com < resultatflux4.txt
#}

# if just want to send a mail
#echo "Bonjour, voici le contenu des flux que vous avez choisis :" | mail -s "Flux RSS : News" ayako.dumont@gmail.com

# execute fluxrss.sh everyday at 9:oo
#function freq() {
#crontab -e
#0 9 * * * fluxrss-aya.sh
#}