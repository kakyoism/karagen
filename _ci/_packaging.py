import copy
import glob
import os
import os.path as osp
import platform
import shlex
import shutil
import string
import subprocess
import sys

import kkpyutil as util
from _postinstall import run_cmd

_basename = osp.splitext(osp.basename(__file__))[0]
_script_dir = osp.abspath(osp.dirname(__file__))
_root_dir = osp.abspath(osp.join(_script_dir, os.pardir))
_tmp_dir = osp.join(_root_dir, 'temp')
_logger = util.build_default_logger(_tmp_dir, name=_basename, verbose=False)


def main():
    plat = Platform.get_platform()
    plat.main()


class Platform:
    def __init__(self, *args, **kwargs):
        self.paths = {
            'root': _root_dir,
            'ci': osp.join(_root_dir, '_ci')
        }

    @staticmethod
    def get_platform():
        return Windows() if platform.system() == 'Windows' else Mac()

    def main(self):
        raise NotImplementedError('subclass me')


class Windows(Platform):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def main(self):
        # copy template
        src = osp.join(self.paths['ci'], '_installer.iss.template')
        dest = osp.join(self.paths['ci'], '_installer.iss')
        shutil.copy(src, dest)
        # replace root path
        str_map = {
            'var_rootdir': self.paths['root']
        }
        util.substitute_keywords_in_file(dest, str_map)
        # build installer
        cmd = ['iscc', osp.join(self.paths['ci'], '_installer.iss')]
        _logger.info(' '.join(cmd))
        run_cmd(cmd, self.paths['root'])
        out_dir = osp.join(self.paths['root'], 'build', 'windows')
        _logger.info(f'Instaler generated under: {out_dir}')


class Mac(Platform):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def main(self):
        pass


if __name__ == '__main__':
    main()