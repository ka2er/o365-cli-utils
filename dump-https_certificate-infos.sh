#!/bin/bash

show_help() {
  echo "Dump CA chain name of an https ressources.
  
Usage:

    $0 [-v] [-h] <https://myresource>

  Options:

    -v
      Verbose output.

    -h
      Show this help.

Examples:

    $0 https://www.google.fr

" >&2
}

## arguments parsing #########

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
endpoints=""
verbose=0

while getopts "h?v" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

#######################################

endpoints="$*"

[[ $endpoints == "" ]] && show_help && exit 1

for endpoint in $endpoints; do

  echo "CA infos for $endpoint"
  curl -m2 --insecure -L -v "$endpoint" 2>&1 | grep -e "^* Server certificate:" -e "^* Issue another request to this URL" -e "*  subject:" -e "*  issuer:"
  echo "----------------------------"
done

# Server certificate:
#  subject: C=US; ST=California; L=Mountain View; O=Google LLC; CN=*.google.com
#  start date: Apr 24 10:34:31 2018 GMT
#  expire date: Jul 17 09:27:00 2018 GMT
#  issuer: C=US; O=Google Trust Services; CN=Google Internet Authority G3
#  SSL certificate verify ok.
