# resolver.sh - Resolve challenges from root-me.org

# Usage: resolver.sh [OPTIONS] [CHALLENGE_NUMBER]
# Arguments:
#   -d, --debug: show additional information
#   -h, --help: show this help message
#   -n, --name: resolve challenges by name
#   -a, --all: resolve all challenges
#   -t, --tools: resolve challenges using tools     !!!! IN DEVELOPMENT !!!!
#   -et, --exclude-tools: exclude challenges using tools

#!/bin/bash

# help function
function help {
    echo "resolver.sh - Resolve challenges from root-me.org

"
    echo "Usage: resolver.sh [OPTIONS] [CHALLENGE_NUMBER]
Arguments:
  -d, --debug: show additional information
  -h, --help: show this help message
  -n, --name: resolve challenges by name
  -a, --all: resolve all challenges
"

    echo "Usage:"
    echo "  resolver.sh <challenge number>"
    echo "  resolver.sh -n <challenge name>"
    echo "  resolver.sh <challenge number> -d"
    echo "  resolver.sh <challenge number> --debug"
    echo "  resolver.sh -h"
    echo "  resolver.sh --help"
    echo "  resolver.sh -a"
    echo "  resolver.sh <challenge number> -t <tool> -t <tool>"
    echo "  resolver.sh <challenge number> -et <tool> "
}

###### Parse arguments ######

# default values
debug=false
name=false
challenge_name=""
all=false
number=false
challenge_number=0
tools=""
exclude_tools=""

# parse arguments for each one
for arg in "$@"; do
    case $arg in
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
    -a | --all)
        all=true
        shift
        ;;
    -t | --tools)
        # add the tool to the list of tools
        tools="$tools $2"
        shift
        shift
        ;;
    -et | --exclude-tools)
        exclude_tools="$exclude_tools $2"
        shift
        shift
        ;;

    *)
        if [[ $arg =~ ^[0-9]+$ ]]; then
            number=true
            challenge_number="$arg"
            shift
        else
            echo "Error: unknown argument $arg"
            help
            exit 1
        fi
        ;;
    esac
done

# check if both name and number are true
if [ $name = true ] && [ $number = true ]; then
    echo "Error: both challenge name and number are set"
    help
    exit 1
fi

# check if neither name nor number are true
if [ $name = false ] && [ $number = false ] && [ $all = false ]; then
    echo "Error: no challenge name or number is set"
    help
    exit 1
fi

# check if all is true
if [ $all = true ]; then
    if [ $name = true ]; then
        echo "Error: -a and -n are exclusive"
        help
        exit 1
    fi

    if [ $number = true ]; then
        echo "Error: -a and -c are exclusive"
        help
        exit 1
    fi
fi

# check if a tool is in "exclude_tools" and "tools"
for tool in $tools; do
    for exclude_tool in $exclude_tools; do
        if [ $tool = $exclude_tool ]; then
            echo "Error: $tool is in both -t and -et"
            help
            exit 1
        fi
    done
done

###### Get challenges resolver from json ######

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

# Get the challenge name from the json file given the challenge number
function get_challenge_name {
    challenge_name=$(cat challenge.json | jq -r ".[] | select(.ch == $1) | .name")
    # check if the challenge name is valid
    if [[ $challenge_name = "" ]]; then
        echo "Error: invalid challenge number $challenge_number"
        help
        exit 1
    fi
}

# Get the challenge number from the json file given the challenge name
function get_challenge_number {
    challenge_number=$(cat challenge.json | jq -r ".[] | select(.name == $1) | .ch")
}

# Get the challenge resolver from the json file
function get_challenge_resolver {
    # get the challenge resolver from the json file
    challenge_resolver=$(cat challenge.json | jq -r ".[] | select(.ch == $1) | .script")
    # check if the challenge resolver is valid
    if [[ $1 = "" ]]; then
        echo "Error: invalid challenge number $1"
        help
        exit 1
    fi
}
function set_flags {
    # set the flags
    if [ $debug = true ]; then
        flags="-d"
    fi
}

# Use the challenge resolver to resolve the challenge
function resolve_challenge {
    # get the challenge resolver and execute it
    get_challenge_resolver $1
    if [ $debug = true ]; then
        echo "Executing $challenge_resolver $1"
    fi
    # Stylized announcement with the challenge name and number
    # in rectangle
    echo "╔════════════════════════════════════════════╗"
    echo "║  Resolving challenge $1: $challenge_name"
    echo "╚════════════════════════════════════════════╝"

    "./$challenge_resolver" -c $1 $flags
}

# Resolve all challenges
if [ $all = true ]; then
    # get all the challenges
    challenges=$(cat challenge.json | jq -r ".[].ch")
else
    challenges=$challenge_number
fi
set_flags

# resolve each challenge
for challenge in $challenges; do
    get_challenge_name $challenge
    resolve_challenge $challenge
done

# Print the number of challenges (length of "challenges") resolved in a stylized way
echo "╔════════════════════════════════════════════╗"
echo "║  Resolved $(($(echo $challenges | wc -w))) challenges"
echo "╚════════════════════════════════════════════╝"

exit 0
