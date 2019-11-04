import os
import shutil

BASEDIR = os.path.dirname(__file__)
VOLUMES_DIR = os.path.join(BASEDIR, "volumes")

if os.path.exists(VOLUMES_DIR) and os.path.isdir(VOLUMES_DIR):
    print ("Deleting volume directory: " + VOLUMES_DIR)
    shutil.rmtree(VOLUMES_DIR)

print ("Creating volume directory")
os.mkdir(VOLUMES_DIR)
