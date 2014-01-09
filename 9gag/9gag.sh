#!/bin/bash


function help {

echo -e -n "Ce script permet de récupérer les derniers .gif poster sur le site 9GAG"
echo -e "Ces .gif seront envoyé chaque matin par mail."
echo -e "Utilisation : ./9gag.sh [-OPTS] [MOTS CLEFS...] \n"

}

function affiche {

#récuperer le code source de la page
#recupère tout les fichier contenant le mot gif que l'on stocke dans un fichier stockage
curl http://9gag.com/ | grep "gif" > stockage

#comprimer le fichier stockage à l'aide d'un zip que l'on nomme .zip
zip -r stockage.zip stockage

}




