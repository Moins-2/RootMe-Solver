#!/bin/bash

# help function
function help {
    echo "solver-nuclei.sh - solve challenges using nuclei

"
    echo "Arguments:"
    echo "  -d, --debug: show the nuclei output"
    echo "  -h, --help: show this help message"
    echo "  -n, --name: solve challenges by name"
    echo "  -c, --challenge: solve challenges by number

"
    echo "Usage:"
    echo "  solver-nuclei.sh -n <challenge name>"
    echo "  solver-nuclei.sh -c <challenge number>"
    echo "  solver-nuclei.sh -c <challenge number> -d"
    echo "  solver-nuclei.sh -c <challenge number> --debug"
    echo "  solver-nuclei.sh -h"
    echo "  solver-nuclei.sh --help"
}

###### Parse arguments ######

# default values
debug=false
name=false
challenge_name=""
number=false
challenge_number=0

# parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -d | --debug)
        debug=true
        shift
        ;;
    -h | --help)
        help
        exit 0
        ;;
    -n | --name)
        name=true
        challenge_name="$2"
        shift
        shift
        ;;
    -c | --challenge)
        number=true
        challenge_number="$2"
        shift
        shift
        ;;
    *)
        echo "Error: unknown argument $key"
        help
        exit 1
        ;;
    esac
done

###### Validate arguments ######

# check if there is a challenge number
if [ $challenge_number -eq 0 ] && [ $number = true ]; then
    echo "Error: no challenge number was given"
    help
    exit 1
fi

# check if there is a challenge number
if [ $name = true ] && [ $number = true ]; then
    echo "Error: only one of \"-n\" or \"-c\" can be given"
    help
    exit 1
fi

# check if there is a challenge name
if [ $name = true ] && [ $challenge_name = "" ]; then
    echo "Error: no challenge name was given"
    help
    exit 1
fi

# check if the challenge number is valid
if [[ ! $challenge_number =~ ^[0-9]+$ ]]; then
    echo "Error: invalid challenge number $challenge_number"
    help
    exit 1
fi

###### get the challenge from json ######

# If the challenge name is given, verify it and get the challenge number
if [ $name = true ]; then
    # get the challenge number from the json file
    challenge_number=$(cat challenge.json | jq -r ".[] | select(.name == \"$challenge_name\") | .ch")
    # check if the challenge number is valid
    if [[ ! $challenge_number =~ ^[0-9]+$ ]]; then
        echo "Error: invalid challenge name $challenge_name"
        help
        exit 1
    fi
fi

# If the challenge number is given, verify it and get the challenge name
if [ $number = true ]; then
    # get the challenge name from the json file
    challenge_name=$(cat challenge.json | jq -r ".[] | select(.ch == $challenge_number) | .name")
    # check if the challenge name is valid
    if [[ $challenge_name = "" ]]; then
        echo "Error: invalid challenge number $challenge_number"
        help
        exit 1
    fi
fi

#In challenge_name, remove spaces
challenge_name=$(echo $challenge_name | tr -d ' ')

###### solve the challenge ######

# create the flags string
if [ $debug = true ]; then
    flags="-debug"
else
    flags="-silent"
fi

# create the url string
url="http://challenge01.root-me.org/web-serveur/ch${challenge_number}/"

# run nuclei
nuclei -t ./Web-server -id $challenge_name -u $url $flags
