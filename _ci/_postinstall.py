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
_root_dir = abspath(join(_script_dir, os.pardir))
_tmp_dir = join(_root_dir, 'temp')


def main():
    plat = Platform.create_platform()
    plat.install_ffmpeg()
    plat.install_libsndfile()


class Platform:
    def __init__(self, *args):
        pass
    @staticmethod
    def create_platform():
        src_dir = _script_dir
        if platform.system() == 'Windows':
            return Windows(src_dir)
        else:
            return Mac(src_dir)

    def install_ffmpeg(self):
        raise NotImplementedError('subclass this')

    def install_libsndfile(self):
        raise NotImplementedError('subclass this')


class Windows(Platform):
    def __init__(self, srcdir):
        super().__init__(srcdir)
        self.srcDir = srcdir
        self.destParDir = srcdir

    def install_ffmpeg(self):
        dest_dir = self.destParDir
        append_to_os_paths(join(dest_dir, 'ffmpeg', 'bin'))

    def install_libsndfile(self):
        dest_dir = self.destParDir
        append_to_os_paths(join(dest_dir, 'libsndfile', 'bin'))

    def _unzip(self, src, dest):
        os.makedirs(dest, exist_ok=True)
        cmd = ['tar', '-xf', src, '-C', dest]
        run_cmd(cmd, self.srcDir)


class Mac(Platform):
    def __init__(self, *args):
        super().__init__(*args)

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


def run_cmd(cmd, cwd):
    subprocess.run(cmd, check=True, shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)


if __name__ == '__main__':
    main()
