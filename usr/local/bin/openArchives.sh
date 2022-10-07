#!/bin/bash

checked=0
password=""

check_password_protected()
{
	(7z t -p'' "$1" &>/dev/null)
	has_password=$?
	if [ "$has_password" -eq 2 ]; then
		echo "At least one of the files seems to be password protected."\
			 "Do you want to try using the same password on all files?"
		while true; do
			read -n 1 -p "[Y/N]" yn
			case $yn in
				[yY] ) checked=1;
					echo "" && read -p "Enter the password to use: " password;
					break;;
				[nN] ) checked=1;
					break;;
				* ) echo "" && echo "Please enter [Y]es or [N]o";;
			esac
		done
	fi
}

while getopts ":el:" option; do
	case $option in
		e) # Extract
			for file in "${@:2}"; do
				DIR=`rev <<< "$file" | cut -d"/" -f2- | rev`
				NAME=`rev <<< "$file" | cut -d"." -f2- | cut --complement -d"/" -f2- | rev`
				if [ "$NAME" = "" ]; then
					NAME=`rev <<< "$file" | cut --complement -d"/" -f2- | rev`
				fi

				if [ $checked -eq 0 ];then
					check_password_protected "$file"
				fi

				if [ "$password" = "" ]; then
					7z x -o"$DIR"/"$NAME" "$file"
				else
					7z x -p"$password" -o"$DIR"/"$NAME" "$file"
				fi
			done
			exit;;

		l) # List contents
			for file in "${@:2}"; do
				7z l "$file"
				echo ""
				read -p "Press ENTER to continue" input
			done
			exit;;

		\?) # Invalid option
			echo "Error: Invalid option"
			exit;;
	esac
done
