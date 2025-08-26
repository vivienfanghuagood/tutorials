import warnings
from IPython import get_ipython


def _fake_system_command(cmd):
    warnings.warn(f"[ignored] shell command pip install is unnecessary : {cmd}", RuntimeWarning)
    return 0

ip = get_ipython()
if ip:
    ip.system = _fake_system_command
    ip.getoutput = lambda *args, **kwargs: []

