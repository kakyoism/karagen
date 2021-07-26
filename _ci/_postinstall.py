import copy
import datetime
import getpass
import glob
import os
import platform
import shlex
import shutil
import string
import subprocess
import sys
from os.path import abspath, basename, dirname, isdir, join, normpath, splitext, exists, isfile

_basename = splitext(basename(__file__))[0]
_script_dir = abspath(dirname(__file__))
_root_dir = join(_script_dir, os.pardir)
_tmp_dir = join(_root_dir, 'temp')


def main():
    plat = Platform.create_platform()
    plat.install_ffmpeg()
    plat.install_libsndfile()


class Platform:
    def __init__(self, *args, **kwargs):
        pass
    @staicmethod
    def create_platform(self):
        src_dir = _script_dir
        if platform.system() == 'Windows':
            return Windows(src_dir)
        else:
            return Mac(src_dir)

    def install_ffmpeg(self):
        raise NotImplementedError('subclass this')

    def install_libsndfile(self):
        raise NotImplementedError('subclass this')


class Windows:
    def __init__(self, srcdir, **kwargs):
        super().__init__(self, srcdir, **kwargs)
        self.srcDir = srcdir
        self.destParDir = srcdir

    def install_ffmpeg(self):
        src = join(self.srcDir, '_3rdparty', 'ffmpeg-win64-lgpl.zip')
        dest_dir = join(self.destParDir, 'ffmpeg')
        if isfile(join(dest_dir, 'bin', 'ffmpeg.exe')):
            return
        self._unzip(src, dest_dir)
        append_to_os_paths(join(dest_dir, 'bin'))

    def install_libsndfile(self):
        src = join(self.srcDir, '_3rdparty', 'libsndfile-win64.zip')
        dest_dir = join(self.destParDir, 'libsndfile')
        if isfile(join(dest_dir, 'bin', 'sndfile.dll')):
            return
        self._unzip(src, dest_dir)
        append_to_os_paths(join(dest_dir, 'bin'))


class Mac:
    def __init__(self, *args, **kwargs):
        super().__init__(self, *args, **kwargs)

    def install_ffmpeg(self):
        raise NotImplementedError('imp this')

    def install_libsndfile(self):
        raise NotImplementedError('imp this')


def append_to_os_paths(bindir):
    """
    On macOS, PATH update will only take effect after calling `source ~/.bash_profile` directly in shell. It won't work
    """
    if platform.system() == 'Windows':
        import winreg
        with winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER) as reg:
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r'Environment', 0, winreg.KEY_ALL_ACCESS) as key:
                user_paths, _ = winreg.QueryValueEx(key, 'Path')
                if bindir not in user_paths:
                    if user_paths[-1] != ';':
                        user_paths += ';'
                    user_paths += f'{bindir}'
                    winreg.SetValueEx(key, 'Path', 0, winreg.REG_EXPAND_SZ, user_paths)
    else:
        cfg_file = os.path.expanduser('~/.bash_profile') if platform.system() == 'Darwin' else os.path.expanduser('~/.bashrc')
        if bindir in os.environ['PATH']:
            return
        with open(cfg_file, 'a') as fp:
            fp.write(f'\nexport PATH="$PATH:{bindir}"\n\n')
    os.environ['PATH'] += os.pathsep + bindir


def _unzip(self, src, dest):
    os.makedirs(dest, exist_ok=True)
    cmd = ['tar', '-xf', src, '-C', dest]
    _run_cmd(cmd, self.setupRoot)


def _run_cmd(cmd, cwd):
    subprocess.run(cmd, check=True, shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)


if __name__ == '__main__':
    main()
