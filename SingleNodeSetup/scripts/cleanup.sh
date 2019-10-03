kubectl delete deployment orderer -n orgorderer1
kubectl delete deployment peer0-org1 -n org1
kubectl delete deployment peer1-org1 -n org1
kubectl delete deployment cli -n org1
kubectl delete deployment peer0-org2 -n org2
kubectl delete deployment peer1-org2 -n org2
kubectl delete deployment cli -n org2
kubectl delete svc peer0 -n org1
kubectl delete svc peer1 -n org1
kubectl delete svc peer0 -n org2
kubectl delete svc peer1 -n org2
kubectl delete svc orderer -n orgorderer1

kubectl delete namespaces org1 org2 orgorderer1
