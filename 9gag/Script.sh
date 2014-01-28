#!/bin/bash


#si on rentre l'adresse mail a l'endroit du mail et qu'on lance le script on recevra les 10 premier gif de 9gag 



# On efface le dossier et les fichiers contenus
#Suprime le dossier
rm -rf 9gag_sh

# On créé un dossier dans le répertoire personnel et on se place dedans
mkdir 9gag_sh
cd 9gag_sh

# recupere les 10 premier lien des gif de 9gag et les met dans gif.txt
curl -s http://9gag.com/gif | sed -n '/data-image=.*/,/>/p' | cut -c68-127 |sed -e '2d;4d;6d;8d;10d;12d;14d;16d;18d;20d' > gif.txt

# télécharge les 10 gif
let "url = 1"
let "max=11"
while [ $url -ne $max ]
do
echo "$url"
temp=$(sed -n ''"${url////\/}"'p' gif.txt)
echo "$temp"
curl $temp > $url.gif
let "url=url+1"

done

#(echo -e "Ci-joint le fichier de gifs ";cat 1.gif & 2.gif | iconv -f utf8 -t iso-8859-1 | uuencode 1.gif & 2.gif) | mail -s "fichiers gif en PJ" mail@
 
#envoie par mail les 10 gif du repertoir
echo "Ci-joint 10 gif 9gag" | mutt -s "Les gif de 9gag" -a *.gif -- mail@mail.com

exit
