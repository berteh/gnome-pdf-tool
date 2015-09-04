#!/bin/bash
PID=$$
FIFO=/tmp/FIFO${PID}
mkfifo $FIFO
#############################################################################################
button1()
{
echo "EXIT@SAVE"
}
button2()
{
echo "EXIT@"
}
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
