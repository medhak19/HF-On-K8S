from string import Template
#from pathlib import Path
import string
import os

TestDir = './dest/'
PORTSTARTFROM = 30000
GAP = 100  #interval for worker's port

def render(src, dest, **kw):
    t = Template(open(src, 'r').read())
    with open(dest, 'w') as f:
        f.write(t.substitute(**kw))

    ##### For testing ########################
    ##testDest = dest.split("/")[-1]    ##
    ##with open(TestDir+testDest, 'w') as d:##
    ##d.write(t.substitute(**kw))          ##
    ##########################################
def getTemplate(templateName):
    baseDir = os.path.dirname(__file__)
    configTemplate = os.path.join(baseDir, "../templates/" + templateName)
    return configTemplate


# create org/namespace 
def configORGS(name, path,destdir): # name means if of org, path describe where is the namespace yaml to be created.     
    namespaceTemplate = getTemplate("fabric1.4-pod-template-ns-pvc-pv.yaml")
    render(namespaceTemplate, destdir + "/" + name + "-namespace.yaml", org = name,
    pvName = name + "-pv",
    path = path.replace("scripts/../", "/opt/share/")
    )

#######

def generateYaml(member, memberPath, flag):
    if flag == "/peers":
        configPEERS(member, memberPath)
    else:
        configORDERERS(member, memberPath) 
    

# create peer/pod and cli pod
def configPEERS(name, path): # name means peerid.
    ####### pod config yaml for org peer
    configTemplate = getTemplate("fabric1.4-pod-template-peer.yaml")
    mspPathTemplate = 'peers/{}/msp'
    tlsPathTemplate = 'peers/{}/tls'        
        
    nameSplit = name.split(".")
    peerName = nameSplit[0]
    orgName = nameSplit[1]
    render(configTemplate, path + "/" + name + ".yaml", 
        namespace = orgName,
        podName = peerName + "-" + orgName,
        peerID  = peerName,
        localMSPID = orgName.split('-')[0].capitalize()+"MSP",
        mspPath = mspPathTemplate.format(name),
        tlsPath = tlsPathTemplate.format(name),
        pvName = orgName + "-pv"        
        )
        
        ####### pod config yaml for org cli
    cliTemplate = getTemplate("fabric1.4-pod-template-cli.yaml")
        
    if peerName == "peer0":
       render(cliTemplate, path + "/" + orgName + "-cli.yaml", 
       namespace = orgName,
       peerID  = peerName,
       localMSPID = orgName.split('-')[0].capitalize()+"MSP",
       artifactsName = orgName + "-artifacts-pv"
       )
       #######

        

# create orderer/pod
def configORDERERS(name, path): # name means ordererid
        configTemplate = getTemplate("fabric1.4-pod-template-orderer.yaml")
        
        nameSplit = name.split(".")
        ordererName = nameSplit[0]
        orgName = nameSplit[1]
        mspPathTemplate = 'orderers/{}/msp'
        tlsPathTemplate = 'orderers/{}/tls'
        
        render(configTemplate, path + "/" + name + ".yaml", 
        namespace = orgName,
        ordererID = ordererName,
        podName =  ordererName + "-" + orgName,
        localMSPID =  orgName.capitalize() + "MSP",
        mspPath = mspPathTemplate.format(name),
        tlsPath = tlsPathTemplate.format(name),
    pvName = orgName + "-pv"        
        )



#if __name__ == "__main__":
#        #ORG_NUMBER = 3
#        podFile = Path('./fabric_cluster.yaml')
#        if podFile.is_file():
#                os.remove('./fabric_cluster.yaml')

#delete the previous exited file        
#        configPeerORGS(1, 2)
#        configPeerORGS(2, 2)
#        configOrdererORGS()
