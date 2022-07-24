## Instructions


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

