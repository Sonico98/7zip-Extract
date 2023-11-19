## Instructions

### Install 7-zip-full
`paru -S 7-zip-full`
(or use any other AUR helper or install it manually)

### Rename the folder "local" to ".local" and move it to your $HOME.
The path would look something like `/home/<user>/.local`.
The command to do so right from the current directory would be:

`mv ./local ./.local && cp -r ./.local ~/`

### Update the desktop database (requires desktop-file-utils, can be uninstalled later)
`update-desktop-database ~/.local/share/applications`

### Give execute permissions to the script
`chmod +x ./usr/local/bin/openArchives.sh`

### As root, copy the "usr" folder to root ("/")
`sudo cp -r ./usr /`

### Set archive files to open with the extractArchives desktop files
Generally, right click any archive file, open with, and choose extractArchives
