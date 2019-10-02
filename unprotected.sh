#!/bin/bash

export SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT}/common.sh"

function show_help {
  echo $0
  echo "Returns all the repositories in an organisation where the given branch is unprotected."
  echo "Example: $0 -o myorg "
  echo " "
  echo "-h Show help"
  echo "-o <org name>         The organisation to update; required"
  echo "-b <branch name>      The branch to check; defaults to master"
}

BRANCH=master

while getopts "h?o:b:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    o)  ORG_NAME=$OPTARG
        ;;
    b)  BRANCH=$OPTARG
       ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

has_value "${ORG_NAME}" "Org name is reqired."

function repo_action() {
  REPO=$1
  RESULT=$(hub api "/repos/${ORG_NAME}/${REPO}/branches/${BRANCH}" | jq -r '.protected')

  if [[ "${RESULT}" == "false" ]]; then
    echo $REPO
  fi
}

for_each_repo "${ORG_NAME}"



