import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestT.Rout 2> ../Results/Results.TestR_errFile.Rout", shell = True).wait()

subprocess.Popen("Rscript --verbose NonExistScript.R > ../Results/outputFile.Rout 2> ../Results/errorFile.Rout", shell=True).wait()


