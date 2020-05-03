#!/usr/bin/env bash

if [[ ! -f ../release ]]; then
  /usr/bin/git branch | grep \* | awk '{print "{ \"output\":","\"" $NF "\" }" }'
else
  revision=$(cat ../release)
  echo "{ \"output\": \"${revision}\" }"
fi
