@echo off
REM CAUTION:
REM - prefer !var! to expand vars defined inside conditionals
REM - or avoid "set var=value" inside conditionals
setlocal EnableExtensions DisableDelayedExpansion
pushd

REM script is at proj_root/_ci/
cd %~dp0..

start /wait cmd /c "flutter pub get"
if NOT %errorlevel% == 0 (
    echo "Failed to install GUI dependencies"
    goto :fail
)
start /wait cmd /c "flutter build windows"
if NOT %errorlevel% == 0 (
    echo "Failed to build GUI"
    goto :fail
)
echo ** SUCCEEDED **
popd
goto :EOF

:fail
echo ** FAILED **
popd
