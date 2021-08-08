#! /bin/sh

set -e

# protect cwd
pushd . &> /dev/null

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"

# script is at proj_root/ci/
cd "$ScriptDir"/..
flutter pub get
flutter build macos

ParDir=build/macos/Build/Products
ReleaseDir="$ParDir"/Release
DupDir="$ParDir"/karagen
if [[ -d "$DupDir" ]]; then
	rm -rf "$DupDir"
fi
mkdir -p "$DupDir"
cp -r "$ReleaseDir"/* "$DupDir"/

pandoc -s -o README.html README.md --metadata title="karagen: User Guide"
poetry run python _ci/_packaging.py

echo "** SUCCEEDED **"
popd &> /dev/null
