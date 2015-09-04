#!/bin/bash
PID=$$
FIFO=/tmp/FIFO${PID}
mkfifo $FIFO
#############################################################################################
## FICHIER ENTREE ##
####################
_fichier_entree()
{
[[ "$1" == "None" ]] || [[ "$1" == "$HOME" ]] && return
path_fichier_entree="${@}"
 ClearTree
echo -e "$(date): \n $path_fichier_entree" >> ./log
data_pdftk=$(pdftk "${path_fichier_entree}" dump_data 2>&1 | tee -a ./log)
echo "TEXT@@LOAD@@_textview_log@@log"
arg_pass=
glob_pass=false
while [[ "$data_pdftk" =~ "Error:" ]]; do
      if [[ "$data_pdftk" =~ "OWNER PASSWORD REQUIRED" ]]; then
          glob_pass=true
          unset EXIT
          eval $(./glade2script.py -g ./gui_password.glade -r "_entry_owner.get_text")
          echo "Mot De Passe: $_entry_owner_get_text" >> ./log
          if [[ "$EXIT" == "yes" ]]; then
              data_pdftk=$(pdftk "$@" input_pw $_entry_owner_get_text dump_data 2>&1 | tee -a ./log)
              echo "TEXT@@LOAD@@_textview_log@@log"
          else 
               echo "SET@ _fichier_entree.set_filename('$HOME')"
               break
          fi
      else
          break
      fi
done

[[ "$data_pdftk" =~ "Error:" ]] && return
flag=false
while read ligne
do
    if [[ "$ligne" =~ InfoKey ]]; then
       cle=${ligne/InfoKey: /}
    elif [[ "$ligne" =~ InfoValue ]]; then
       value=${ligne/InfoValue: /}
       tree="treeview_metakey"
       flag=true
    else
       cle=${ligne%%: *}
       value=${ligne#*: }
       value=${value/&#0;/}
       tree="treeview_metadata"
       flag=true
    fi
    if $flag; then 
       echo "TREE@@END@@$tree@@$cle|$value" | sed 's/&#0;//g'    
    fi
    flag=false
done <<< "${data_pdftk}"
echo ${path_fichier_entree##*\/}
echo "SET@_entry_nom.set_text('${path_fichier_entree##*\/}')"
echo "SET@_dossier_sortie.set_filename('${path_fichier_entree%\/*}')"
}
## NOTEBOOK page 1 ##
# bouton ajouter et enlever treeview metadata 
btn_ajout_infokey()
{
echo "TREE@@END@@treeview_metakey@@InfoKey|InfoValue"
}
btn_supp_infokey()
{
echo "TREE@@GET@@treeview_metakey"
echo "TREE@@CELL@@treeview_metakey@@@@"
}
## NOTEBOOK page 2 ##
_check_modif_perm()
{
[[ "$1" == "True" ]] && modif_perm=true || modif_perm=true
echo "SET@_vbox_all_check_perm.set_sensitive($1)"
}
_check_TQP()
{
[[ "$1" == "True" ]] && TQP=true || TQP=false
}
_check_LQP()
{
[[ "$1" == "True" ]] && LQP=true || LQP=false
}
_check_modifycontent()
{
[[ "$1" == "True" ]] &&  modifycontent=true || modifycontent=false
}
_check_assembly()
{
[[ "$1" == "True" ]] &&  assembly=true || assembly=false
}
_check_copycontent()
{
[[ "$1" == "True" ]] &&  copycontent=true || copycontent=false
}
_check_screenreaders()
{
[[ "$1" == "True" ]] &&  screenreaders=true || screenreaders=false
}
_check_annotation()
{
[[ "$1" == "True" ]] &&  annotation=true || annotation=false
}
_check_fillin()
{
[[ "$1" == "True" ]] &&  fillin=true || fillin=false
}
_check_allfeatures()
{
if [[ "$1" == "True" ]]; then
    allfeatures=true
    echo "SET@_vbox_check_perm.set_sensitive(False)"
else
    allfeatures=false
    echo "SET@_vbox_check_perm.set_sensitive(True)"
fi
}
_check_MDP_owner()
{
[[ "$1" == "True" ]] && MDP_owner=true || MDP_owner=false
    echo "SET@_entry_MDP_owner.set_sensitive($1)"
}
_check_MDP_user()
{
[[ "$1" == "True" ]] && MDP_user=true || MDP_user=false
    echo "SET@_entry_MDP_user.set_sensitive($1)"
}
## NOTEBOOK page 3 ##
btn_supp_log()
{
echo "TEXT@@CLEAR@@_textview_log"
> ./log
}

###############
## EXECUTION ##
###############
# bouton executer
btn_execute()
{
> /tmp/pdf_meta.txt
# Récup contenue treeview (@hizo)
echo "TREE@@HIZO@@treeview_metakey"
# Nom et dossier du fichier de sortie
echo "GET@_entry_nom.get_text()"
echo "GET@_dossier_sortie.get_filename()"
echo "GET@_entry_MDP_user.get_text()"
echo "GET@_entry_MDP_owner.get_text()"
echo "ITER@@VerifPdf"
}
# treeview InfoKey (éditable)
treeview_metakey()
{
if [[ "$@" =~ hizo@ ]]; then
   var=${@#hizo@}
   while read ligne
     do
         cle=${ligne%|*}
         valeur=${ligne#*|}
         [[ -z "$cle" ]] || [[ -z "$valeur" ]] && continue
         echo -e "InfoKey: $cle\nInfoValue: $valeur" >> /tmp/pdf_meta.txt
     done< <(echo -e "${var//@@/\\n}")
fi
}

#################
# ECRITURE PDF ##
#################
VerifPdf()
{ # si pdf existe, lancer popup
path_fichier_sortie="$_dossier_sortie_get_filename/$_entry_nom_get_text"
if [[ -e "$path_fichier_sortie" ]]; then
   echo "SET@pop_ecras.show()"
else
   EcritPdf "$path_fichier_sortie"
fi
}
EcritPdf()
{
 arg=
 arg_all=
 if $modif_perm; then
     if $allfeatures; then
         arg="AllFeatures "
     else
         if $TQP; then arg="Printing "; fi
         if $LQP; then arg="${arg}DegradedPrinting "; fi
         if $modifycontent; then arg="${arg}ModifyContents "; fi
         if $assembly; then arg="${arg}Assembly "; fi
         if $copycontent; then arg="${arg}CopyContents "; fi
         if $screenreaders; then arg="${arg}ScreenReaders "; fi
         if $annotation; then arg="${arg}ModifyAnnotations "; fi
         if $fillin; then arg="${arg}FillIn "; fi
     fi
     arg_all="allow $arg "
     echo "modif_perm $arg_all"
 fi
 if $MDP_owner; then
     arg_all="${arg_all}owner_pw $_entry_MDP_owner_get_text "
     echo "mdp_owner $arg_all"
 fi
 if $MDP_user; then
     arg_all="${arg_all}user_pw $_entry_MDP_user_get_text "
     echo "mdp_user $arg_all"
 fi
 if $glob_pass; then input_pass=" $_entry_owner_get_text"; echo glob_pass $_entry_owner_get_text; fi
 echo "arg_all $arg_all"
 > "$@"
 pdftk "$path_fichier_entree" input_pw${input_pass} update_info /tmp/pdf_meta.txt output "$@" ${arg_all}verbose 2>&1 >> ./log
 ClearTree
 echo "SET@ _fichier_entree.set_filename('$HOME')"
 echo "TEXT@@LOAD@@_textview_log@@log"
 input_pass=
 glob_pass=false
}
############
## DIVERS ##
############
ClearTree()
{
echo "TREE@@CLEAR@@treeview_metakey"
echo "TREE@@CLEAR@@treeview_metadata"
}
UnsetVariable()
{
modif_perm=false
TQP=false
LQP=false
modifycontent=false
assembly=false
copycontent=false
screenreaders=false
annotation=false
fillin=false
allfeatures=false
MDP_owner=false
MDP_user=false
arg=
arg_all=
input_pass=
}
###################
## POPUP ECRASER ##
###################
# Bouton ecraser enfoncé
btn_ecras()
{
 EcritPdf /tmp/tmppdf.pdf
 mv /tmp/tmppdf.pdf "$path_fichier_sortie" && echo "Move /tmp/tmppdf.pdf to $path_fichier_sortie" >> ./log
 echo "TEXT@@LOAD@@_textview_log@@log"
}


############
## DEPART ##
############
[[ -n "$@" ]] && echo "SET@_fichier_entree.set_filename('$@')"
UnsetVariable
echo "STARTING ... $(date)" >> ./log
echo "TEXT@@LOAD@@_textview_log@@log"
##########################################################################################
while read ligne; do
    if [[ "$ligne" =~ GET@ ]]; then
       eval ${ligne#*@}
       echo "DEBUG => in boucle bash :" ${ligne#*@}
    else
       echo "DEBUG=> in bash NOT GET" $ligne
       $ligne
   fi 
done < <(while true; do
    read entree < $FIFO
    [[ "$entree" == "QuitNow" ]] && break
     echo $entree   
done)
exit
