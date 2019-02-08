#!/bin/bash
# Indique au système que l'argument qui suit est le programme utilisé pour exécuter ce fichier
# En règle générale, les "#" servent à mettre en commentaire le texte qui suit comme ici
file=$1
echo PROCESS > $file
ps >> $file
echo TACHE >> $file
echo	PERIPHERIQUE >> $file
lsusb >> $file
lspci >> $file
echo MODELE >> $file
cat /proc/version >> $file
echo COPIE LOG




