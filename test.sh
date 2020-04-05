#!/bin/bash

if [[ $# -ne 1 ]] ; then
    echo "please provide root url"
    exit 1
fi

root_url=$1
echo "*** get all"
curl -XPOST -d '{}' ${root_url}/get; echo

echo "\n*** get prince"
curl -XPOST -d '{ "artist": "prince" }' ${root_url}/get ; echo

echo "\n*** add tears for fears"
curl -XPOST -d '{ "artist": "tears for fears", "song": "shout" }' ${root_url}/put ; echo
curl -XPOST -d '{ "artist": "tears for fears" }' ${root_url}/get ; echo

echo "\n*** remove tears for fears"
curl -XPOST -d '{ "artist": "tears for fears", "song": "shout" }' ${root_url}/delete ; echo
curl -XPOST -d '{ "artist": "tears for fears" }' ${root_url}/get ; echo
