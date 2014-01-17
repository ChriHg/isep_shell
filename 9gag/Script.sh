#!/bin/bash
# On efface le dossier et les fichiers contenus
rm -rf ~/9gag_sh/
# On créé un dossier dans le répertoire personnel et on se place dedans
mkdir ~/9gag_sh/ 
cd ~/9gag_sh/

# On télécharge le code source qu'on enregistre dans un fichier page, sans afficher les opérations.
curl -s http://9gag.com/ > 9gag_sh/stockage

#compter le nombre de .gif qu'il y a 
max=$(grep -o "\.gif$" stockage | wc -l)

echo "" > url

# On telecharge chacun des gif et on y créé un fichier url par gif
if [[ $max != 0 ]] ; then
        for i
                do
                        grep -o "\.gif$" 9gag_sh/stockage | grep -o -E 'data-image="([^"#]+)"' | cut -d'"' -f2  >> url
                done
fi

rm -rf 9gag_sh/stockage/images/
# On créé un dossier dans le répertoire personnel et on se place dedans
mkdir 9gag_sh/stockage/images/ 
cd 9gag_sh/stockage/images/

for url in $(cat urls)
do
	curl $url
done

exit
















#recuperer une url > création d'un fichier/url
#url1
#url2

#telecharger les images contenu dans les url des fichers

