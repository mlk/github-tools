#!/bin/bash

export SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT}/common.sh"

function show_help {
  echo $0
  echo "Gives the team permission to every GitHub repository in an organisation."
  echo "Example: $0 -o myorg -t \"Team Leads\""
  echo " " 
  echo "-h Show help"
  echo "-o <org name>         The organisation to update; required"
  echo "-t <team name>        The team in the organisation to give permissions too; required"
  echo "-p [read|write|admin] The permission to give to the team; defaults to admin"
}

PERMISSION=admin

while getopts "h?o:t:p:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    o)  ORG_NAME=$OPTARG
        ;;
    t)  TEAM_NAME=$OPTARG
	;;
    p) PERMISSION=$OPTARG
       ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

has_value "${ORG_NAME}" "Org name is reqired."
has_value "${TEAM_NAME}" "Team name is reqired."

has_command hub "https://hub.github.com"
has_command jq "https://stedolan.github.io/jq/"

TEAM_ID=$(getTeam "${ORG_NAME}" "${TEAM_NAME}")

has_value "${TEAM_ID}" "No team found with that name."


function repo_action() {
  I=$1
  echo -n "> $I"
  RESULT=$(hub api -X PUT -f permission=$PERMISSION /teams/${TEAM_ID}/repos/${ORG_NAME}/$I)
  if [ $? != 0 ]; then
    echo -n " ❌ "
    echo $RESULT | jq -r '.message'
  else
    echo " ✅"
  fi
}

for_each_repo "${ORG_NAME}"

