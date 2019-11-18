import subprocess

p = subprocess.Popen(["echo", "I'm talkin' to you, bash"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)


stdout, stderr = p.communicate()
stderr
stdout
print(stdout.decode())



p = subprocess.Popen(["ls", "-l"], stdout=subprocess.PIPE)
stdout, stderr = p.communicate()
# print(stdout.decode())


p = subprocess.Popen(["python", "../../Week2/Code/boilerplate.py"], stdout = subprocess.PIPE, stderr = subprocess.PIPE) # A bit silly!

subprocess.os.path.join('directory', 'subdirectory', 'file')

MyPath = subprocess.os.path.join('directory', 'subdirectory', 'file')
MyPath

