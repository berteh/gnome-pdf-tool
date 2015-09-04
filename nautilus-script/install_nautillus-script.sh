#!/bin/bash
CURDIR="$(cd "$(dirname "$0")"; pwd)"
cd "${CURDIR}"
DIR_NAUT="$HOME/.gnome2/nautilus-scripts"
mkdir -p "$DIR_NAUT"
echo '#!/bin/bash
executable="'$(dirname "${CURDIR}")'/go_GPDFTool.sh"
fichier=$(head -n 1 <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")

"${executable}" "${fichier}"' > "$DIR_NAUT/GPDFTool" && echo "Copie du Script → Ok" || echo "Copie Impossible"
 chmod +x "$DIR_NAUT/GPDFTool" && echo "Droit du Script → Ok" || echo "Impossible d'installer le script"
sleep 2
exit
