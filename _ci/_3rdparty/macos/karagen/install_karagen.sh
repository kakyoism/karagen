#! /bin/sh

set -e 

UseAdminPasswd="You may be asked to type in admin password before moving forward ..."

# install homebrew
Lazy_Install_With_Homebrew() {
    Package="$1"
    brew list "$Package" || brew install "$Package"
    if [ "$?" -ne "0" ]; then
        if [[ ! -f "/usr/local/bin/brew" ]]; then
        	echo "Installing Xcode command-line tools ..."
			echo "$UseAdminPasswd"
			set +e
			sudo xcode-select --install
			set -e
            echo "Installing Homebrew ... check your proxy if you are stuck here for more than 10min."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        	echo "Adding /usr/local/bin to your user PATH ..."
			echo "export PATH=/usr/local/bin:\$PATH" >> ~/.bash_profile
			source ~/.bash_profile
        fi
        echo "installing $Package ... check your proxy if you are stuck here for long."
        brew install "$Package"
    fi
}

pushd . &> /dev/null

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$ScriptDir"


echo "================="
echo "Install karagen"
echo "================="

echo "Assume this script is under the same root folder of all the dependencies:"
ls -l "$ScriptDir"

set +e
echo "Where is Python 3.8?"
which python3.8
if [ "$?" -ne "0" ]; then
	set -e
	echo "Installing python3.8 ..."
	echo "$UseAdminPasswd"
	sudo open "$ScriptDir"/python-3.8.10-macosx10.9.pkg
	source ~/.bash_profile
fi
set -e

set +e
echo "Where is Deezer Spleeter?"
which spleeter
if [ "$?" -ne "0" ]; then
	set -e
	echo "Installing spleeter ..."
	pip3.8 install spleeter	
fi
set -e

Lazy_Install_With_Homebrew ffmpeg
Lazy_Install_With_Homebrew libsndfile

echo "** SUCCEEDED **"
popd &> /dev/null
source ~/.bash_profile
