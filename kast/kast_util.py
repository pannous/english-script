import os

__author__ = 'me'

global folder
# folder="/Users/me/dev/ai/english-script/test/rast/"
# folder="./test/"
folder="/Users/me/dev/ai/english-script/kast/test/"
def findFile(fileName0):
    fileName=fileName0
    # import os.path
    # Check if a file exists and is file
    # os.path.isfile(fname)
    if os.path.exists(fileName): return fileName
    fileName=fileName.replace("../","")
    if os.path.exists(fileName): return fileName
    fileName=fileName.replace(".rb","")
    fileName=fileName.replace(".py","")
    fileName=fileName.replace(".kast","")
    if os.path.exists(fileName+".rb"): return fileName+".rb"
    if os.path.exists(fileName+".py"): return fileName+".py"
    if os.path.exists(fileName+".kast"): return fileName+".kast"
    if os.path.exists(folder+fileName+".rb"): return folder+fileName+".rb"
    if os.path.exists(folder+fileName+".py"): return folder+fileName+".py"
    if os.path.exists(folder+fileName+".kast"): return folder+fileName+".kast"
    raise Exception("File not found "+fileName0)

