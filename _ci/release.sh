#! /bin/sh

Version=0.2.3

set -e

# protect cwd
pushd . &> /dev/null

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"

# script is at proj_root/ci/
cd "$ScriptDir"/..

Icon=_assets/parrot.icns
Background=_assets/dmg.png
Guide_en=README.html
License=LICENSE
AppBundle="$Icon"
Installer=build/macos/install_karagen-"$Version".dmg
AppMasterDir=_ci/_3rdparty/macos/karagen

if [ -f "$Installer" ]; then
	rm "$Installer" &> /dev/null
fi

pandoc -s -o "${Guide_en}" README.md --metadata title="karagen: User Guide"
cp "${Guide_en}" "$License" "$AppMasterDir"
Models=pretrained_models
cp -Rv _ci/"$Models" "$AppMasterDir"
appdmg _ci/release.json "$Installer"
if [[ -d "$AppMasterDir"/$Models ]]; then
	rm -rf "$AppMasterDir"/$Models
fi

echo "** SUCCEEDED **"
popd &> /dev/null
