#!/bin/bash

export SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT}/common.sh"

function show_help {
  echo $0
  echo "Shows all PRs currently assigned to you."
  echo "Example: $0"
  echo " "
  echo "-h Show help"
}

while getopts "h?" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

has_command hub "https://hub.github.com"
has_command jq "https://stedolan.github.io/jq/"
has_command in2csv "https://github.com/wireservice/csvkit"

USER=$(who_am_i)

DATA=$(hub  api "search/issues?q=is:open%20is:pr%20review-requested:${USER}%20archived:false" | jq -r '.items[] | [{"Title": .title, "URL": .html_url}]')

if [ -z "$DATA" ]; then
  echo "No PRs 🎉"
else
  echo $DATA | in2csv -f json | csvlook
fi


