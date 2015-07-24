#!/bin/bash
if ! zenity --info --text "EasyBackup GTK 0.0.1 \n(C) 2015 Dierk-Bent Piening \ndierk.bent.piening@gmail.com \nLicense: GPL"; then
  exit;
fi
ans=$(zenity  --list  --text "Modus wählen?" --checklist  --column "Pick" --column "options" FALSE "Backup" FALSE "Recovery" --separator=":"); 


#BACKUP BEREICH 
if [ "$ans" = "Backup" ]; then 
	{
		QUELL=`zenity --file-selection --directory --title="Quellordner wählen ..."`
		ZIEL=`zenity --file-selection --directory --title="Zielordner wählen ..."`
		if ! NAME=$(zenity --entry --text "Bitte geben sie den Gwünschten Backup-Title ein::" --title "Backup-Title"); then
  			{
  				exit;
  			}
		fi
		if tar czvf ${ZIEL}/${NAME}.tar $QUELL | zenity --progress --pulsate --text="Erstelle Backup von $QUELL in $ZIEL ..."
		then
			{
				if ! tar tf ${ZIEL}/${NAME}.tar &> /dev/null | zenity --progress --pulsate --text="Überprüfe Backup $NAME auf fehler... " ; then 
					{
						zenity --error --text "Error: fehlerhaftes Archiv\n Beende!";
						exit 0;
					}
				fi
				zenity --info --text "Archiv $NAME .tar fehlerfrei\nBackup für $QUELL erfolgreich in $ZIEL angelegt!\nBackup-Name: ${NAME}.tar"
			}
		else
			{
				zenity --error --text "Error: Backup $NAME von $QUELL wurde nicht durchgeführt!";
				exit 0;
			}
		fi
	}
fi



# RECOVERY BEREICH 
if [ "$ans" = "Recovery" ]; then 
	{
		tmp=".backup_tmp";
		QUELLR=`zenity --file-selection --title="Backupfile wählen ..."`
		ZIELR=`zenity --file-selection --directory --title="Zielordner wählen.."`
	
		if ! tar tf ${QUELLR} &> /dev/null | zenity --progress --pulsate --text=" Überprüfe $QUELL auf fehler ...";  then
 			{
 				zenity --error --text " $QUELLR ist fehlerhaft\n Beende";
				exit 0;
			}
		fi
		mkdir ${ZIELR}/${tmp}
		echo "$QUELLR"

		if tar -xzf ${QUELLR} --show-transformed-names -C ${ZIELR}/${tmp} | zenity --progress --pulsate --text=" $QUELLR in $ZIELR wird wiederhergestellt ...";
		then
			{
				mv -i -v -u ${ZIELR}/${tmp}/${ZIELR}/* ${ZIELR} | zenity --progress --pulsate --text=" Cleane ...";
				cd ${ZIELR};
				rm -f -r ${tmp};
				chmod -R 777 ${ZIELR};
				zenity --info --text "Wiederherstellen von $QUELLR in $ZIELR erfolgreich!";
			}
		else
			{
				zenity --error --text "Wiederherstellen von $QUELLR in $ZIELR nicht erfolgreich!";
				exit 0;
			}
		fi


	} 
fi