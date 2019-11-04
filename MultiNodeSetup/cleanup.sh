FLAG="k8s_deploy"
FLAG=$1
mode=$2

if [ "$FLAG" != "k8s_deploy"  -a "$FLAG" != "all"  -a "$FLAG" != "rm_dirs" ]; then
	echo "Invalid option. Command Usage: "
	echo "Option1: To cleanup k8s artifacts, use command: ./cleanup.sh k8s_deploy [solo|etcdraft]
Option2: To remove crypto material, channel-artifacts and nfs volume dirs, use command: ./cleanup.sh rm_dirs
Option3: To cleanup all the artifacts, use command: ./cleanup.sh all [solo|etcdraft]
	"
	
	exit 1

fi
if [ "$FLAG" == "k8s_deploy"  -o "$FLAG" == "all" ]; then

	
	echo "Deleting Services ..."
	kubectl delete svc peer0 -n org1
	kubectl delete svc peer1 -n org1
	kubectl delete svc peer0 -n org2
	kubectl delete svc peer1 -n org2
	kubectl delete svc orderer -n orgorderer1
	

	
	echo "Deleting Deployments ..."
	kubectl delete deployment orderer-orgorderer1 -n orgorderer1
	kubectl delete deployment peer0-org1 -n org1
	kubectl delete deployment peer1-org1 -n org1
	kubectl delete deployment cli -n org1
	kubectl delete deployment peer0-org2 -n org2
	kubectl delete deployment peer1-org2 -n org2
	kubectl delete deployment cli -n org2
	
	if [ "$mode" == "etcdraft" ]; then
		kubectl delete svc orderer2 -n orgorderer1
		kubectl delete svc orderer3 -n orgorderer1
		kubectl delete svc orderer4 -n orgorderer1
		kubectl delete svc orderer5 -n orgorderer1
		
		kubectl delete deployment orderer2-orgorderer1 -n orgorderer1
		kubectl delete deployment orderer3-orgorderer1 -n orgorderer1
		kubectl delete deployment orderer4-orgorderer1 -n orgorderer1
		kubectl delete deployment orderer5-orgorderer1 -n orgorderer1
	fi
	
	sleep 10
	echo "Deleting Persistent Volume Claims ..."
	kubectl delete pvc --all -n org1
	kubectl delete pvc --all -n org2
	kubectl delete pvc --all -n orgorderer1

	sleep 10
	echo "Deleting Persistent Volumes ..."
	kubectl delete pv --all


	echo "Deleting Namespaces ..."
	kubectl delete namespaces org1 org2 orgorderer1
fi
	
if [ "$FLAG" == "rm_dirs" -o "$FLAG" == "all" ]; then
		echo "Deleting crypto-config directory ..."
		rm -rf ./crypto-config

		echo "Deleting channel-artifacts directory ..."
		rm -rf ./channel-artifacts

		echo "Deleting deploy-yamls directory ..."
		rm -rf ./deploy-yamls

		echo "Deleting NFS volume directory ..."
		rm -rf /opt/share/chaincode
		rm -rf /opt/share/channel-artifacts
		rm -rf /opt/share/crypto-config
fi
	
	
	
	
