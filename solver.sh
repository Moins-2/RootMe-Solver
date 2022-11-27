# solver.sh - solve challenges from root-me.org

# Usage: solver.sh [OPTIONS] [CHALLENGE_NUMBER]
# Arguments:
#   -d, --debug: show additional information
#   -h, --help: show this help message
#   -n, --name: solve challenges by name
#   -a, --all: solve all challenges
#   -t, --tools: solve challenges using tools     !!!! IN DEVELOPMENT !!!!
#   -et, --exclude-tools: exclude challenges using tools

#!/bin/bash

# help function
function help {
    echo "solver.sh - solve challenges from root-me.org

"
    echo "Usage: solver.sh [OPTIONS] [CHALLENGE_NUMBER]
Arguments:
  -d, --debug: show additional information
  -h, --help: show this help message
  -n, --name: solve challenges by name
  -a, --all: solve all challenges
"

    echo "Usage:"
    echo "  solver.sh <challenge number>"
    echo "  solver.sh -n <challenge name>"
    echo "  solver.sh <challenge number> -d"
    echo "  solver.sh <challenge number> --debug"
    echo "  solver.sh -h"
    echo "  solver.sh --help"
    echo "  solver.sh -a"
    echo "  solver.sh <challenge number> -t <tool> -t <tool>"
    echo "  solver.sh <challenge number> -et <tool> "
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

###### Get challenges solver from json ######

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

# Get the challenge solver from the json file
function get_challenge_solver {
    # get the challenge solver from the json file
    challenge_solver=$(cat challenge.json | jq -r ".[] | select(.ch == $1) | .script")
    # check if the challenge solver is valid
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

# Use the challenge solver to solve the challenge
function solve_challenge {
    # get the challenge solver and execute it
    get_challenge_solver $1
    if [ $debug = true ]; then
        echo "Executing $challenge_solver $1"
    fi
    # Stylized announcement with the challenge name and number
    # in rectangle
    echo "╔════════════════════════════════════════════╗"
    echo "║  Resolving challenge $1: $challenge_name"
    echo "╚════════════════════════════════════════════╝"

    "./$challenge_solver" -c $1 $flags
}

# solve all challenges
if [ $all = true ]; then
    # get all the challenges
    challenges=$(cat challenge.json | jq -r ".[].ch")
else
    challenges=$challenge_number
fi
set_flags

# solve each challenge
for challenge in $challenges; do
    get_challenge_name $challenge
    solve_challenge $challenge
done

# Print the number of challenges (length of "challenges") solved in a stylized way
echo "╔════════════════════════════════════════════╗"
echo "║  solved $(($(echo $challenges | wc -w))) challenges"
echo "╚════════════════════════════════════════════╝"

exit 0