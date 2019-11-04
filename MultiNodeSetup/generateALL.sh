#!/bin/bash +x

CHANNEL_NAME="mychannel"
#: ${CHANNEL_NAME:="mychannel"}

CONSENSUS_TYPE="solo"

export TOOLS=$PWD/bin
export CONFIG_PATH=$PWD
export FABRIC_CFG_PATH=$PWD


## Generates Org certs
function generateCerts (){
	CRYPTOGEN=$TOOLS/cryptogen
	 if [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
		$CRYPTOGEN generate --config=./crypto-config-etcdraft.yaml	
	 else
		$CRYPTOGEN generate --config=./crypto-config.yaml
	 fi		
	

}

function generateChannelArtifacts() {
	if [ ! -d channel-artifacts ]; then
		mkdir channel-artifacts
	fi


	CONFIGTXGEN=$TOOLS/configtxgen
	 if [ "$CONSENSUS_TYPE" == "etcdraft" ]; then 	
		$CONFIGTXGEN -profile SampleMultiNodeEtcdRaft -outputBlock ./channel-artifacts/genesis.block
	 else	
		$CONFIGTXGEN -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
	 fi	
 	$CONFIGTXGEN -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID $CHANNEL_NAME
	$CONFIGTXGEN -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
 	$CONFIGTXGEN -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
# 	$CONFIGTXGEN -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP
	
	cp ./channel-artifacts/genesis.block ./crypto-config/ordererOrganizations/*

	chmod -R 777 ./channel-artifacts && chmod -R 777 ./crypto-config
    cp -r ./crypto-config /opt/share/ && cp -r ./channel-artifacts /opt/share/	
#	cp -r ./scripts /opt/share/ && cp -r ./chaincode /opt/share/
    cp -r ./chaincode /opt/share/	
}

function generateK8sYaml (){
	python3.5 scripts/generate.py
}

# Print the usage message
function printHelp() {
  echo "Usage: "
  echo "  generateALL.sh [-c <channel name>] [-o <consensus-type>]"
  echo "  where: "
  echo "    -c <channel name> - channel name to use (defaults to \"mychannel\")"
  echo "    -o <consensus-type> - the consensus-type of the ordering service: solo (default), or etcdraft"
}

function clean () {
	rm -rf crypto-config
	rm -rf channel-artifacts
	rm -rf deploy-yamls
}


while getopts "h?o:c:" opt 
do
  case "$opt" in
  h | \?)
    printHelp
    exit 0
    ;;
  o) 
	CONSENSUS_TYPE="$OPTARG" ;;
  c) 
    CHANNEL_NAME="$OPTARG" ;;  
  esac
done

echo "Consensus type: ${CONSENSUS_TYPE}";


## Genrates orderer genesis block, channel configuration transaction and anchor peer upddate transactions
##function generateChannelArtifacts () {
##	CONFIGTXGEN=$TOOLS/configtxgen
	
#}

clean
generateCerts
generateChannelArtifacts
generateK8sYaml
