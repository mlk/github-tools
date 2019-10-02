#!/bin/bash

function getTeam() {
  hub api /orgs/$1/teams | jq ".[] | select(.name==\"$2\") | .id"
}

function who_am_i() {
   hub api user | jq -r '.login'
}

function has_command() {
  if ! which $1 > /dev/null 2>&1; then
    echo "$1 is required'. $2"
    show_help
    exit 1
  fi
}

function has_value() {
  if [[ -z "$1" ]]; then
    echo "$2"
    show_help
    exit 1
  fi
}


function for_each_repo() {
  ORG_NAME=$1

  PAGE=1

  while : ; do
    DATA=$(hub api orgs/${ORG_NAME}/repos\?page=$PAGE  | jq -r '.[] | select( .disabled == false) | .name')
    array=($DATA)
    for I in "${array[@]}"; do
      repo_action $I
    done

    [[ ! -z "$DATA" ]] || break
    let PAGE=PAGE+1
  done
}

