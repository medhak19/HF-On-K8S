import os
import time

BASEDIR = os.path.dirname(__file__)
ORDERER = os.path.join(BASEDIR, "../crypto-config/ordererOrganizations") # it must point to the ordererOrgnaizations dir
PEER = os.path.join(BASEDIR, "../crypto-config/peerOrganizations") # it must point to the peerOrgnaizations dir
DESTDIR = os.path.join(BASEDIR, "../deploy-yamls");
### order of run ###

#### orderer
##### namespace(org)
###### single orderer

#### peer
##### namespace(org)
###### ca
####### single peer

def runOrderers(path):
	orgs = os.listdir(path)
	
	for org in orgs:
		#print ("Organization : " + org);
		if "orderer" in org:
			ordererYaml = os.path.join(path, org ) #orgYaml namespace.yaml
			print ("Orderer YAML: " + ordererYaml);
			checkAndRun(ordererYaml)
			time.sleep(5);

def runPeers(path):
	orgs = os.listdir(path)
	print ("Get peer YAMLs..........") ;
	for org in orgs:
		if "peer" in org:
			peerYaml = os.path.join(path, org )
			print ("Peer YAML: " + peerYaml);
			checkAndRun(peerYaml)
			time.sleep(5);
	
	print ("Get cli YAMLs..........") ;	
	for org in orgs:
		if "cli" in org: 
			cliYaml = os.path.join(path, org )
			print ("cli YAML: " + cliYaml);
			checkAndRun(cliYaml)
			time.sleep(5);

def checkAndRun(f):
	if os.path.isfile(f):
		os.system("kubectl create -f " + f)

	else:
		print("file %s no exited"%(f))
if __name__ == "__main__":
	print ("Run orderers.........") ;
	runOrderers(DESTDIR)
	
	print ("Run peers..........") ;
	runPeers(DESTDIR)
