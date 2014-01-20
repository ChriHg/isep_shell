#!/bin/bash

# just put in a variable to have the clearest code
url_flux1="http://www.sport.fr/RSS/sport1.xml"
url_flux2="http://www.futura-sciences.com/rss/actualites.xml"

############### Title & Description of RRS 1 ############### 
function showTitleAndDescriptionOfURL1() {
curl -s  "$url_flux1" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g'  | sed -e '1,3d' | sed 'G;n;G;' 
}

############### Title & Description of RRS 2 ############### 
function showTitleAndDescriptionOfURL2() {
curl -s  "$url_flux2" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g' 
echo
}

############### Creation of .txt files ############### 
showTitleAndDescriptionOfURL1 - > titleAndDescriptionOfURL1.txt
showTitleAndDescriptionOfURL2 - > titleAndDescriptionOfURL2.txt

############### Filter CDATA in URL2 ############### 
function filterCDATA() {
cat titleAndDescriptionOfURL2.txt | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g'  | sed -e '1,3d' | sed -e :a -e '/.!$/N ; G ; ta'
}

function fusionRSS1andRSS2(){
echo "------- Résultats du flux choisi n°1 : " 
curl -s  "$url_flux1" | grep -E -m 1 "(title>)" | sed -e 's/<title>//g' -e 's/<\/title>//g'
echo
echo
showTitleAndDescriptionOfURL1
echo
echo
echo
echo "------- Résultats du flux choisi n°2 : "
curl -s  "$url_flux2" | grep -E -m 1 "(title)" | sed -e 's/<title>//g' -e 's/<\/title>//g' | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g' 
echo
echo
filterCDATA
}

fusionRSS1andRSS2 - > fusionRSS1andRSS2.txt
############### Refine text ############### 
function deleteSpaceBeforeLine() {
cat fusionRSS1andRSS2.txt | sed 's/^[ \t]*//g;s/[ \t]*$//g' | fold -w 80 -s 
}
#-s : no cut a word in end of line

############### Final .txt ############### 
deleteSpaceBeforeLine - > yourRSSNews.txt