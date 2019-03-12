#!/bin/bash

function show_help {
  echo $0
  echo "Gives the team permission to every GitHub repository."
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


if [[ -z "${ORG_NAME}" ]]; then
   echo "Org name is reqired."
   show_help
   exit 1
fi

if [[ -z "${TEAM_NAME}" ]]; then
   echo "Team name is reqired."
   show_help
   exit 1
fi

if ! which hub > /dev/null 2>&1; then
   echo "Hub is required'. https://hub.github.com"
   show_help
   exit 1
fi

if ! which jq > /dev/null 2>&1; then
   echo "JQ is required'. https://stedolan.github.io/jq/"
   show_help
   exit 1
fi


TEAM_ID=$(hub api /orgs/${ORG_NAME}/teams | jq ".[] | select(.name==\"${TEAM_NAME}\") | .id")

if [[ -z "${TEAM_ID}" ]]; then
   echo "No team found with that name."
   show_help
   exit 1
fi

PAGE=1

while : ; do
    DATA=$(hub api --flat orgs/${ORG_NAME}/repos\?page=$PAGE  | grep '\]\.name' | cut -f 2)
    array=($DATA)
    for I in "${array[@]}"; do
      echo "> $I"
      echo hub api -X PUT -f permission=$PERMISSION /teams/${TEAM_ID}/repos/${ORG_NAME}/$I
    done
   
    [[ ! -z "$DATA" ]] || break
    let PAGE=PAGE+1
done


