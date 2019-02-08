#!/bin/bash
# Indique au système que l'argument qui suit est le programme utilisé pour exécuter ce fichier
# En règle générale, les "#" servent à mettre en commentaire le texte qui suit comme ici
touch log
echo PROCESS > log
ps >> log
echo	TACHE >> log
echo	PERIPHERIQUE >> log
lsusb >> log
lspci >> log
echo MODELE >> log
cat /proc/version >> log
echo COPIE LOG




