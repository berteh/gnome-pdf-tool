#!/bin/bash
CURDIR="$(cd "$(dirname "$0")"; pwd)"
cd "${CURDIR}"
DIR_NAUT="$HOME/.local/share/nautilus/scripts/"
mkdir -p "$DIR_NAUT"
echo '#!/bin/bash
executable="'$(dirname "${CURDIR}")'/go_GPDFTool.sh"
fichier=$(head -n 1 <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")

"${executable}" "${fichier}"' > "$DIR_NAUT/GPDFTool" && echo "Copying Script → Ok" || echo "Could not copy Script"
 chmod +x "$DIR_NAUT/GPDFTool" && echo "Changing Script Rights → Ok" || echo "Could not install Script, check your write access rights to $DIR_NAUT"
sleep 2
exit
