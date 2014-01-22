#!/bin/bash

SizeChoice(){
	 read -p "Choose  (pl or mi) " first
        read -p "Choose size example : 500 " second
        read -p "Choose weight example : k for Ko " third
                if [ $first ] && [ $second ] && [  $third ]; then
                        case $first in
                                pl)  sign=+;;
                                mi)  sign=-;;
                        esac
		echo "Execute "  $(date -d 'now')>>~/log
              find . -size $sign$second$third -exec rm -rfv {} + 1>>~/log     
echo Execute                
else
                        echo No Parameter
                fi  
};

TimeChoice(){

 read -p "Delete files older than  (enter a number)" day

if [ $day ]; then

find . -ctime +$day -exec rm -rfv {} + 1 >>~/log

echo Execute

else
	echo No Parameter
fi

};

#We go to the directory where the trash is
cd ~/.local/share/

trash=0
trashFull=1
#If trash directory exists, we go to "files" directory,  where the files we want to delete will be.
if [ -d "Trash/" ]; then
  
	#Si la corbeille existe, on se déplace dans le sous-dossier files contenant les éléments à supprimer
  echo Directory Trash exists
  cd Trash/files
  
	#La taille minimale du sous-dossier files est de 4ko
  sizeMin=4,0
  
	#La commande suivante permet d'obtenir la taille du sous-dossier files
  sizeFiles=$(du -h | grep . | sort -n | tail -n 1 | cut -d K -f 1)
  
	#Le dossier files pese 4ko,on v�rifie qu'il n'y est pas de petit fichier pour s'assurer que la corbeille est vide
  if [ $sizeFiles = $sizeMin ]; then
		findFile=`find . -type f`
    if [ "$findFile" = "" ]; then 
      echo Trash is empty
    else 
      trash=1
      echo Trash contains some files
    fi
	#Le dossier files est différent de 4ko, il contient des éléments
	else
    trash=1
		echo Trash contains some files
  fi
else
echo Trash doesn t exist. Task is going to stop
fi
		#On vérifie que tous les arguments nécessaires à la suppression 
		#sélective sont indiqués par l'utilisateur
		#$1: pl(plus) ou mi(minus); $2: taille; $3: unité (ko, mo)
if [ $trash = $trashFull ]; then

read -p "Do you want to delete by size(s) or time (t)?" choice

case $choice in 
 s)   SizeChoice;;
 t)  TimeChoice;;
esac
fi




exit
