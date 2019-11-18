### Desc: Takes script `fmr.R` and runs it usign python

import subprocess

subprocess.Popen("Rscript --verbose fmr.R", shell=True).wait()

