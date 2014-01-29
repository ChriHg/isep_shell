#!/bin/bash
# On efface le dossier et les fichiers contenus
#Suprime le dossier
rm -rf 9gag_sh

# On créé un dossier dans le répertoire personnel et on se place dedans
mkdir 9gag_sh

#Accede au répertoir
cd 9gag_sh

# recupere les leins des gif de 9gag.com/gif et les met dans gif.txt
curl -s http://9gag.com/gif | sed -n '/data-image=.*/,/>/p' | cut -c68-127 |sed -e '2d;4d;6d;8d;10d;12d;14d;16d;18d;20d' > gif.txt

#compte le nombre de liens
nblien=$(cat gif.txt 2> /dev/null |wc -l)
echo "Il y a $nblien liens"

# télécharge les 10 premier gifs
let "url = 1"
let "max=11"
let "nblien=nblien+1"

while [ $url -ne $max ] && [ $url -ne $nblien ]
do
echo "$url"
temp=$(sed -n ''"${url////\/}"'p' gif.txt)
echo "$temp"
curl $temp > $url.gif
let "url=url+1"
done

#Boite de dialogue qui demande a l'utilisaeur de rentré son mail
mailuser=$(zenity --entry "Votre mail" --text "Taper votre addresse mail !")
if [ $? = 0 ] 
then
echo " mail : $mailuser"

#envoie par mail les gif qui sont dans le répertoir (CAD les 10 gifs téléchargé
echo "Ci-joint 10 gifs 9gag !!" | mutt -s "Les gifs de 9gag" -a *.gif -- $mailuser


fi

exit
