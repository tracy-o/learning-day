#!/bin/sh

foo=$((1 + 1))

function get_var() {
  if [ "${foo}" = 2 ] ; then
    e=$?        # return code from if
    if [ "${e}" -eq "1" ]; then
      echo "Foo returned exit code 1"
    elif [ "${e}" -gt "1" ]; then
      echo "Foo returned BAD exit code ${e}"
    else
      echo "Unexpected with exit code ${e}"
    fi
  fi
  
  if [ $# -gt "0" ]; then echo "Args found: $#"; fi
}

x=$(get_var)
echo $x