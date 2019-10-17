FLAG="k8s_deploy"
FLAG=$1

if [ "$FLAG" == "k8s_deploy" ]; then
	echo "Deleting Deployments ..."
	kubectl delete deployment orderer -n orgorderer1
	kubectl delete deployment peer0-org1 -n org1
	kubectl delete deployment peer1-org1 -n org1
	kubectl delete deployment cli -n org1
	kubectl delete deployment peer0-org2 -n org2
	kubectl delete deployment peer1-org2 -n org2
	kubectl delete deployment cli -n org2

	echo "Deleting Services ..."
	kubectl delete svc peer0 -n org1
	kubectl delete svc peer1 -n org1
	kubectl delete svc peer0 -n org2
	kubectl delete svc peer1 -n org2
	kubectl delete svc orderer -n orgorderer1

	echo "Deleting Namespaces ..."
	kubectl delete namespaces org1 org2 orgorderer1
elif [ "$FLAG" == "rm_dirs" ]; then
		echo "Deleting crypto-config directory ..."
		rm -rf ./crypto-config

		echo "Deleting channel-artifacts directory ..."
		rm -rf ./channel-artifacts

		echo "Deleting deploy-yamls directory ..."
		rm -rf ./deploy-yamls

		echo "Deleting deploy-yamls directory ..."
		rm -rf ./volumes
else
	echo "Invalid option"
	exit 1
fi
	
	
	
	
