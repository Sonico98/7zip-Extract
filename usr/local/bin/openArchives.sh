#!/bin/bash

has_password=-2
password=""

check_password_protected()
{
	# Test the file and inmediately stop it,
	# because there's no better way to check if the file
	# is password protected
	7z t "$1" &>/tmp/7zout &
	sleep 0.1 && kill -9 "$!" &>/dev/null
	wait "$!" &>/dev/null
	grep "Enter password" /tmp/7zout &> /dev/null
	has_password=$?
	rm -f /tmp/7zout

	if [ "$has_password" -eq 0 ]; then
		echo "At least one of the files seems to be password protected."\
			"Do you want to try using the same password on all files?"
					exec 8<&0
					while true; do
						read -n 1 -u 8 -p "[Y/N]" yn
						case $yn in
							[yY] )
								echo "" && read -r -u 8 -p "Enter the password to use: " password;
								break;;
							[nN] )
								break;;
							* ) echo "" && echo "Please enter [Y]es or [N]o";;
						esac
					done
					exec 8<&-
				else
					has_password=-2
	fi
}

while getopts ":el:" option; do
	case $option in
		e) # Extract
			for file in "${@:2}"; do
				absolute_file_path="$(readlink -f "$file")"
				if [ $has_password -eq -2 ];then
					check_password_protected "$absolute_file_path"
				else
					break
				fi
			done

			for file in "${@:2}"; do
				absolute_file_path="$(readlink -f "$file")"
				DIR=$(rev <<< "$absolute_file_path" | cut -d"/" -f2- | rev)
				NAME=$(rev <<< "$absolute_file_path" | cut -d"." -f2- | cut --complement -d"/" -f2- | rev)
				if [[ "$NAME" = "" ]]; then
					NAME=$(rev <<< "$absolute_file_path" | cut --complement -d"/" -f2- | rev)
				fi

				if [ "$password" = "" ]; then
					7z x -ba -o"$DIR"/"$NAME" "$absolute_file_path"
				else
					7z x -ba -p"$password" -o"$DIR"/"$NAME" "$absolute_file_path"
				fi
			done
			exit;;

		l) # List contents
			for file in "${@:2}"; do
				7z l "$file"
				echo ""
				read -n 1 -r -p "Press any key to continue" input
			done
			exit;;

		\?) # Invalid option
			echo "Error: Invalid option"
			exit;;
	esac
done
