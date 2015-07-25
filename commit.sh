#!/bin/bash

# GIT SCRIPT 

if ! NAME=$(zenity --entry --text "Bitte geben sie den Gwünschten Commit-Title ein::" --title "Backup-Title"); then
  	{
		exit;
 	}
fi
if ! git add .; then 
	{
		zenity --text-info --text "Alle Dateien werden hinzugefügt";
	}
fi
if ! git commit -m "$NAME"; then
	{
		zenity --text-info --text "Commit mit der Nachricht $NAME";
	}
fi
if ! git push >(zenity --text-info --width 530); then 
	{
	exit;
	}
fi
