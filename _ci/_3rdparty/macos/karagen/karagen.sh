#! /bin/sh

set -e

pushd . &> /dev/null

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$ScriptDir"

echo "Preparing environment ..."
export PATH="/usr/local/bin:/Library/Frameworks/Python.framework/Versions/3.8/bin:$ScriptDir:$PATH"

echo "karagen starts working ..."
InputSong="$1"
OutDir=~/Desktop/karagen
mkdir -p "$OutDir" &> /dev/null
echo "Input Song: $InputSong"
echo "Output Folder: $OutDir"
spleeter separate -p spleeter:2stems -b 320k -o "$OutDir" "$InputSong"
open "$OutDir"

echo "** SUCCEEDED **"
popd &> /dev/null
