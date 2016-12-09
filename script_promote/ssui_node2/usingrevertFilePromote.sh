FILENAME=revertinput.txt
_BACKUP_MAIN_FOLDER="/apps/jboss/Backup_Folder"
_LOG_FOLDER=`pwd`

echo "-------------------------------------------------------------" >> revertlog.log
echo "Starting $1 script on $HOSTNAME at $(date +"%x %r %Z")"
echo "Starting $1 script on $HOSTNAME at $(date +"%x %r %Z")" >> $_LOG_FOLDER/revertlog.log

FILELINES=$(cat $FILENAME)

#Reading the input file and checking all conditions before revert
echo "Starting condition check for revert"
echo "Starting condition check for revert" >> $_LOG_FOLDER/revertlog.log
for LINE in $FILELINES ; do
	str="$LINE"

	arr=(${str//;/ })
	FileName=${arr[0]}
	Source=${arr[1]}
	Destination=${arr[2]}
	Operation=${arr[3]}

	#check if source path is correct
	cd $Source
	if [ ! $Operation = "delete" ];then
	if [ "$?" = "1" ];then
		echo "Incorrect Source mentioned for File name "$FileName
		echo "Incorrect Source mentioned for File name "$FileName >> $_LOG_FOLDER/revertlog.log
		exit 1;
	fi
	fi

	#check if destination path is correct
	cd $Destination
	if [ "$?" = "1" ];then
		echo "Incorrect Destination for File name "$FileName
		echo "Incorrect Destination for File name "$FileName >> $_LOG_FOLDER/revertlog.log
		exit 1;
	fi

	#Check if revert file exists in correct path
	cd $Source
	if [ ! $Operation = "delete" ];then
	if [ ! -f $FileName ]; then
		echo "No files exist in revert folder for File name "$FileName" in path "$Source
		echo "No files exist in revert folder for File name "$FileName" in path "$Source >> $_LOG_FOLDER/revertlog.log
		exit 1
	fi
	fi

	#check if revert file exists in the destination path if modification or deletion
	if [ ! $Operation = "add" ];then
		cd $Destination
		if [ ! -f $FileName ]; then
			echo "Destination does not have file name "$FileName" in path "$Destination
			echo "Destination does not have file name "$FileName" in path "$Destination >> $_LOG_FOLDER/revertlog.log
			exit 1
		fi
	fi
done
echo "File path and file names checked successfully"
echo "File path and file names checked successfully" >> $_LOG_FOLDER/revertlog.log

#Creating Backup folder based on current timestamp
echo "Creating Backup Folder"
echo "Creating Backup Folder" >> $_LOG_FOLDER/revertlog.log
foldername=$(date +"%d%B%Y_%H:%M:%S")
mkdir -p  $_BACKUP_MAIN_FOLDER/"revert_$foldername"
if [ "$?" = "1" ]; then
	exit 1
fi
_BACKUP_FOLDER=$_BACKUP_MAIN_FOLDER/"revert_$foldername"

#Starting File copy after condition check
echo "Starting Files backup and copy"
echo "Starting Files backup and copy" >> $_LOG_FOLDER/revertlog.log


for LINE in $FILELINES ; do
	str="$LINE"

	arr=(${str//;/ })
	FileName=${arr[0]}
	Source=${arr[1]}
	Destination=${arr[2]}
	Operation=${arr[3]}

	echo "Starting revert for file "$FileName
	echo "Starting revert for file "$FileName >> $_LOG_FOLDER/revertlog.log

	#For addition of Files
	if [ $Operation = "add" ];then
		cd $Destination
		echo "addition"
		echo "addition" >> $_LOG_FOLDER/revertlog.log
		if [ ! -f $FileName ]; then
			cp -vrp $Source/$FileName $Destination/$FileName

			if [ "$?" = "1" ];then
				exit 1;
			fi
		else
			cd $_BACKUP_FOLDER
			mkdir -p $_BACKUP_FOLDER$Destination
			if [ "$?" = "1" ];then
				exit 1;
			fi
			cp -vrp $Destination/$FileName $_BACKUP_FOLDER$Destination/$FileName
			if [ "$?" = "1" ];then
				exit 1;
			fi
			cp -vrp $Source/$FileName $Destination/$FileName
			if [ "$?" = "1" ];then
				exit 1;
			fi
		fi

	#For Modification of Files
	elif [ $Operation = "modify" ];then
		echo "Modification"
		echo "Modification" >> $_LOG_FOLDER/revertlog.log
		cd $Destination
		if [ -f $FileName ]; then
			cd $_BACKUP_FOLDER
			mkdir -p $_BACKUP_FOLDER$Destination
			if [ "$?" = "1" ];then
				exit 1;
			fi
			cp -vrp $Destination/$FileName $_BACKUP_FOLDER$Destination/$FileName

			if [ "$?" = "1" ];then
				exit 1;
			fi
			cp -vrp $Source/$FileName $Destination/$FileName
			if [ "$?" = "1" ];then
				exit 1;
			fi
		else
			echo "Destination file does not exisit for "$FileName
			echo "Destination file does not exisit for "$FileName >> $_LOG_FOLDER/revertlog.log
		fi

	#For Deletion of Files
	elif [ $Operation = "delete" ];then
		echo "Deletion"
		echo "Deletion" >> $_LOG_FOLDER/revertlog.log
		cd $Destination
		if [ -f $FileName ]; then
			cd $_BACKUP_FOLDER
			mkdir -p $_BACKUP_FOLDER$Destination
			if [ "$?" = "1" ];then
				exit 1;
			fi
			cp -vrp $Destination/$FileName $_BACKUP_FOLDER$Destination/$FileName

			if [ "$?" = "1" ];then
				exit 1;
			fi
			while true; do
				read -p "Please confirm to delete file"$FileName"?" yn
				case $yn in
					[Yy]* ) cd $Destination; rm $FileName; break;;
					[Nn]* ) exit;;
					* ) echo "Please answer yes or no.";;
				esac
			done
		fi
	else
		echo "Incorrect operation mentioned for file "$FileName
		echo "Incorrect operation mentioned for file "$FileName >> $_LOG_FOLDER/revertlog.log
		exit 1;
	fi
done
echo "============================ Revert Completed Successfully ========================="
echo "============================ Revert Completed Successfully =========================" >> $_LOG_FOLDER/revertlog.log





