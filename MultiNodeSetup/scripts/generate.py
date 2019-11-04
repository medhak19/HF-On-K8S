from string import Template
from pathlib import Path
import string
import config as tc
import os
import shutil

BASEDIR = os.path.dirname(__file__)
ORDERER = os.path.join(BASEDIR, "../crypto-config/ordererOrganizations")
PEER = os.path.join(BASEDIR, "../crypto-config/peerOrganizations")
DESTDIR = os.path.join(BASEDIR, "../deploy-yamls");
VOLUMES_DIR = os.path.join(BASEDIR, "..");

#Change this value as per your worker node directory
WORKERNODE_BASE_DIR="/home/admin1/k8s/test/HF-On-K8S/SingleNodeSetup"

#generateNamespacePod generate the yaml file to create the namespace for k8s, and return a set of paths which indicate the location of org files  

def generateNamespacePod(DIR):
    orgs = []
    for org in os.listdir(DIR):
        orgDIR = os.path.join(DIR, org)
        tc.configORGS(org, orgDIR,DESTDIR)	
        orgs.append(orgDIR)
        #orgs.append(orgDIR + "/" + DIR.lower())
    
    print(orgs) 
    return orgs

def createDir(dirName):
    if os.path.exists(dirName) and os.path.isdir(dirName):
       print ("Deleting a directory: " + dirName)
       shutil.rmtree(dirName)

    print ("Creating a directory: " + dirName)
    os.mkdir(dirName)
    

def generateDeploymentPod(orgs):
    for org in orgs:

        if org.find("peer") != -1: #whether it create orderer pod or peer pod 
            suffix = "/peers"
        else:
            suffix = "/orderers"

        members = os.listdir(org + suffix)
        for member in members:
            #print(member)
 #           newVolumeDIR = os.path.join(VOLUMES_DIR +"/volumes", member)
            #print("Creating a volume directory: ")
            #print(newVolumeDIR)
 #           createDir(newVolumeDIR)
            memberDIR = os.path.join(org + suffix, member)
            #print(memberDIR)
            #print(os.listdir(memberDIR))
            #tc.generateYaml(member,memberDIR, suffix,WORKERNODE_BASE_DIR)
            tc.generateYaml(member,DESTDIR, suffix)


#TODO kafa nodes and zookeeper nodes don't have dir to store their certificate, must use anotherway to create pod yaml.

    
def allInOne():
    
    createDir(DESTDIR) 
    peerOrgs = generateNamespacePod(PEER)
    generateDeploymentPod(peerOrgs)

    ordererOrgs = generateNamespacePod(ORDERER)
    generateDeploymentPod(ordererOrgs)


if __name__ == "__main__" :
    allInOne()
    
