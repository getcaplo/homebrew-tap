import hashlib
import io
import os
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest

INSTALLER = Path(__file__).resolve().parents[1] / 'install.sh'

class InstallerTest(unittest.TestCase):
    def run_install(self, os_name='Linux', arch='x86_64', mode='', version='v0.1.0'):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            mocks = root / 'mocks'
            mocks.mkdir()
            target = root / 'target with spaces'
            target.mkdir()
            (target / 'caplo').write_text('previous binary')
            payload = b'#!/bin/sh\necho caplo 0.1.0\n'
            with tarfile.open(root / 'archive', 'w:gz') as tar:
                info = tarfile.TarInfo('caplo')
                info.size = len(payload)
                info.mode = 0o755
                tar.addfile(info, io.BytesIO(payload))
            digest = hashlib.sha256((root / 'archive').read_bytes()).hexdigest()
            (mocks / 'uname').write_text('#!/bin/sh\ncase "$1" in -s) echo "$TEST_OS";; -m) echo "$TEST_ARCH";; esac\n')
            (mocks / 'curl').write_text('''#!/usr/bin/env python3
import os, pathlib, sys
args=sys.argv[1:]
url=next(a for a in args if a.startswith('https://'))
root=pathlib.Path(os.environ['TEST_ROOT'])
with (root/'requests').open('a') as f: f.write(url+'\\n')
if os.environ['TEST_MODE']=='download-failure': sys.exit(22)
if url.endswith('/latest'):
 print('https://github.com/getcaplo/homebrew-tap/releases/tag/v0.1.0',end='')
 sys.exit(0)
assert '/releases/download/v0.1.0/' in url, url
out=pathlib.Path(args[args.index('-o')+1])
if url.endswith('checksums.txt'):
 archive=(root/'asset').read_text()
 digest=os.environ['TEST_DIGEST']
 mode=os.environ['TEST_MODE']
 if mode=='corrupt': digest='0'*64
 if mode=='missing': archive='other.tar.gz'
 text=digest+'  '+archive+'\\n'
 if mode=='duplicate': text+=text
 out.write_text(text)
else:
 (root/'asset').write_text(url.rsplit('/',1)[1])
 out.write_bytes((root/'archive').read_bytes())
''')
            for p in mocks.iterdir():
                p.chmod(0o755)
            env = {**os.environ, 'PATH': str(mocks)+':'+os.environ['PATH'],
                   'CAPLO_INSTALL_DIR': str(target), 'CAPLO_VERSION': version,
                   'TEST_ROOT': str(root), 'TEST_MODE': mode, 'TEST_DIGEST': digest,
                   'TEST_OS': os_name, 'TEST_ARCH': arch}
            result = subprocess.run(['sh', str(INSTALLER)], env=env, capture_output=True, text=True)
            return result, (target/'caplo').read_bytes(), (root/'requests').read_text() if (root/'requests').exists() else '', list(target.glob('.caplo-*'))

    def test_platforms_and_latest_resolution(self):
        for name, arch, suffix in [('Darwin','arm64','darwin_arm64'), ('Darwin','x86_64','darwin_amd64'), ('Linux','aarch64','linux_arm64'), ('Linux','x86_64','linux_amd64')]:
            with self.subTest(platform=suffix):
                result, binary, requests, leftover = self.run_install(name, arch, version='latest')
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn(b'echo caplo 0.1.0', binary)
                self.assertIn('caplo_0.1.0_'+suffix+'.tar.gz', requests)
                self.assertEqual(requests.count('/latest'), 1)
                self.assertEqual(leftover, [])

    def test_refusal_preserves_existing_install(self):
        for mode in ['corrupt','missing','duplicate','download-failure']:
            with self.subTest(mode=mode):
                result, binary, _, leftover = self.run_install(mode=mode)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(binary, b'previous binary')
                self.assertEqual(leftover, [])

    def test_unsupported_platform_and_invalid_version(self):
        for args in [dict(os_name='FreeBSD'), dict(arch='i686'), dict(version='v0.1.0/../../bad')]:
            result, binary, requests, _ = self.run_install(**args)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(binary, b'previous binary')
            self.assertEqual(requests, '')
