#!/bin/bash

############### Chosen RSS Feeds ############################
# just put in a variable to have the clearest code
url_flux1="http://www.sport.fr/RSS/sport1.xml"
url_flux2="http://www.futura-sciences.com/rss/actualites.xml"
#############################################################


############### Title & Description of RRS 1 ############### 
function showTitleAndDescriptionOfURL1() {
curl -s  "$url_flux1" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g'  | sed -e '1,3d' | sed 'G;n;G;' 
}
############################################################


############### Title & Description of RRS 2 ############### 
function showTitleAndDescriptionOfURL2() {
curl -s  "$url_flux2" | grep -E "(title>|description>)" | sed -e 's/<title>//g' -e 's/<\/title>//g' -e 's/<description>/   /g' -e 's/<\/description>//g' 
echo
}
############################################################


############### Creation of .txt files #####################
showTitleAndDescriptionOfURL1 - > titleAndDescriptionOfURL1.txt
showTitleAndDescriptionOfURL2 - > titleAndDescriptionOfURL2.txt
############################################################


############### Filter CDATA in URL2 #######################
function filterCDATA() {
cat titleAndDescriptionOfURL2.txt | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g'  | sed -e '1,3d' | sed -e :a -e '/.!$/N ; G ; ta'
}


############### Fusion of both RSS #########################
function fusionRSS1andRSS2(){
echo "------- Results for RRS n°1 : " 
curl -s  "$url_flux1" | grep -E -m 1 "(title>)" | sed -e 's/<title>//g' -e 's/<\/title>//g'
echo
echo
showTitleAndDescriptionOfURL1
echo
echo
echo
echo "------- Results for RSS n°2 : "
curl -s  "$url_flux2" | grep -E -m 1 "(title)" | sed -e 's/<title>//g' -e 's/<\/title>//g' | grep '\(<!\[CDATA\[\|\]\]>\)' | sed -e 's/<!\[CDATA\[//g' -e 's/\]\]>//g' 
echo
echo
filterCDATA
}
fusionRSS1andRSS2 - > fusionRSS1andRSS2.txt
#############################################################


############### Refine text #################################
function deleteSpaceBeforeLine() {
cat fusionRSS1andRSS2.txt | sed 's/^[ \t]*//g;s/[ \t]*$//g' | fold -w 80 -s 
}
#-s : no cut a word in end of line
#############################################################


############### Final .txt ##################################
deleteSpaceBeforeLine - > yourRSSNews.txt
#############################################################


############### Delete unused .txt ########################## 
rm titleAndDescriptionOfURL1.txt titleAndDescriptionOfURL2.txt fusionRSS1andRSS2.txt
#############################################################

############### Send mail ###################################
function sendMail() {
mail -s "Your RSS News" $email < yourRSSNews.txt
}
#############################################################


############### INTERFACE ###################################
function choiceToSeeNews()
{
echo
echo "Welcome on Your RSS New !"
echo "Your News concern Sport.fr and Futura-Sciences"
echo "Now you can read them if you desire..."
echo

continue=true

while $continue
do

echo "Do you want your RSS News now by email ?"
read -p "So choose Y (Yes) or N (No)." answer
echo
if [ "$answer" == "Y" ] || [ "$answer" == "N" ] 
then 
continue=false
else
echo "Oups there is a mistake !"
fi
done
if [ "$answer" == "Y" ] 
then
read -p "Enter your email : " email
sendMail
echo "You will receive very soon your RRS News !"
echo "Good bye."
echo
elif [ "$answer" == "N" ] 
then
echo "Goodbye, and come back !"
echo
fi
}


choiceToSeeNews
#############################################################
