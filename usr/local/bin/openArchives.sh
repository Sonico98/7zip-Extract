#!/bin/bash

while getopts ":el:" option; do
	case $option in
		e) # Extract
			for file in "${@:2}"; do
				DIR=$(rev <<< "$file" | cut -d"/" -f2- | rev)
				NAME=$(rev <<< "$file" | cut -d"." -f2- | cut --complement -d"/" -f2- | rev)
				if [[ "$NAME" = "" ]]; then
					NAME=$(rev <<< "$file" | cut --complement -d"/" -f2- | rev)
				fi

				mkdir -p "$DIR"/"$NAME"
				7z x -o"$DIR"/"$NAME" "$file"
			done
			exit;;

		l) # List contents
			for file in "${@:2}"; do
				7z l "$file"
				echo ""
				read -r -p "Press ENTER to continue" input
			done
			exit;;

		\?) # Invalid option
			echo "Error: Invalid option"
			exit;;
	esac
done
