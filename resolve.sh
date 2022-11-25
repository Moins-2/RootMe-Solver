## bash script that executes 
# nuclei -u "http://challenge01.root-me.org/web-serveur/ch"+nb -t ./Web-server/
# for each nb in a list of numbers

#!/bin/bash

# if no argument is given, use the default list
# list of numbers [1, 2, 52, 68]
nums=(1 2 5 7 14 21 52 68)
# if one argument is given, verify that it is a number, and use it as the list
if [ $# -eq 1 ]; then
    if [[ $1 =~ ^[0-9]+$ ]]; then
        # if its in the list, use it
        # else, print an error message and exit
        if [[ " ${nums[@]} " =~ " $1 " ]]; then
            nums=($1)
        else
            echo "Error: challenge $1 is not implemented yet"
            exit 1
        fi

    else
        echo "Argument must be a number"
        exit 1
    fi
else if [ $# -gt 1 ]; then
    echo "Too many arguments"
    exit 1
fi
fi



for nb in ${nums[@]}; do
    # print the challenge number stylized with colors in boxes 
    # ================
    # =  CHALLENGE 1 =
    # ================
    #  in orange color 
    echo -e "\e[1;33m================\e[0m"
    echo -e "\e[1;33m= CHALLENGE $nb =\e[0m"
    echo -e "\e[1;33m================\e[0m"

    # execute nuclei command

    if [ $nb -eq 21 ]; then
        nuclei -u "http://challenge01.root-me.org/web-serveur/ch${nb}/" -t Web-server/ -silent
    else
        nuclei -u "http://challenge01.root-me.org/web-serveur/ch${nb}/" -t Web-server/ -eid "File_upload-Type_MIME" -silent
    fi
done

# print a stylized message to show that the script has finished with the number of challenges resolved
total=${#nums[@]}
echo -e "\e[1;32m==========================\e[0m"
echo -e "\e[1;32m= $total challenges resolved =\e[0m"
echo -e "\e[1;32m==========================\e[0m"
