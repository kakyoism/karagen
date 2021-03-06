@echo off
REM CAUTION:
REM - prefer !var! to expand vars defined inside conditionals
REM - or avoid "set var=value" inside conditionals
setlocal EnableExtensions DisableDelayedExpansion
pushd

REM script is at proj_root/_dep/
cd %~dp0

echo install python
set myPythonRoot=C:\python\python38
set myPython=%myPythonRoot%\pythonw.exe
if exist "%myPython%" (
    goto :pypi
)
mkdir %myPythonRoot%
_3rdparty\windows\python-3.8.10-amd64.exe /quiet CompileAll=1 Include_test=0 InstallAllUsers=1 PrependPath=1 TargetDir=%myPythonRoot% 
if NOT %errorlevel% == 0 (
    echo "Failed to install dependencies"
    goto :fail
)

:pypi
set myPythonBin=%myPythonRoot%\Scripts
%myPythonBin%\pip uninstall ffmpeg
%myPythonBin%\pip install ffmpeg-python
if NOT %errorlevel% == 0 (
    echo "Failed to install dependency: ffmpeg"
    goto :fail
)
%myPythonBin%\pip install spleeter
if NOT %errorlevel% == 0 (
    echo "Failed to install dependency: spleeter"
    goto :fail
)

REM lazy install ffmpeg and libsndfile and update PATH
%myPython% _postinstall.py
if NOT %errorlevel% == 0 (
    echo "Failed to install dependencies"
    goto :fail
)

echo ** SUCCEEDED **
popd
goto :EOF

:fail
echo ** FAILED **
popd
