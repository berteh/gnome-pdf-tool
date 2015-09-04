#!/bin/bash
cd "$( cd "$(dirname "$0")"; pwd )/GUI"
combo="Title%%Author%%Subject%%Keywords%%Creator%%Producer%%CreationDate%%ModDate%%Trapped"
 ./glade2script.py -g ./GPDFTool.glade -d -s "./GPDFTool.sh $@" \
-t "@@treeview_metakey@@COMBO%%InfoKey%%$combo|InfoValue%%editable" \
-t "@@treeview_metadata@@Clés|Valeurs"
exit
