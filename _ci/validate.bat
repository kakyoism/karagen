@echo off
REM CAUTION:
REM - prefer !var! to expand vars defined inside conditionals
REM - or avoid "set var=value" inside conditionals
setlocal EnableExtensions DisableDelayedExpansion
pushd

REM script is at proj_root/_ci/
cd %~dp0..

where python
where spleeter
where ffmpeg
where sndfile-play

echo press any key to continue
@pause

