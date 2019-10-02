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

