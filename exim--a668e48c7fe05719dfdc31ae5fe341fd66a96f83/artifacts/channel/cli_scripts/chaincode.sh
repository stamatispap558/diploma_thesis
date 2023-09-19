CHANNEL_NAME=$CHANNEL_NAME
CC_RUNTIME_LANGUAGE="node"
VERSION="1"

export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem
# export FABRIC_CFG_PATH=$PWD/../../../../fabric-samples/config/

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute Chaincode Installation Scenario ==========="
    echo
    exit 1
  fi
}

exporterorg_PORT=7051
importerorg_PORT=8051
eximbusinessorg_PORT=9051

setOrganization() {
  if [[ $# -lt 1 ]]
  then
    echo "Run: setOrganizations <org> [<user>]"
    exit 1
  fi
  ORG=$1
  USER=Admin
  PEER=peer0
  if [[ $# -eq 2 ]]
  then
    USER=$2
  fi
  MSP=
  if [[ "$ORG" == "exporter" ]]
  then
    MSP=ExporterMSP
    PORT=$exporterorg_PORT
  elif [[ "$ORG" == "importer" ]]
  then
    MSP=ImporterMSP
    PORT=$importerorg_PORT
  elif [[ "$ORG" == "eximbusiness" ]]
  then
    MSP=EximBusinessMSP
    PORT=$eximbusinessorg_PORT
  else
    echo "Unknown Org: "$ORG
    exit 1
  fi


  CORE_PEER_TLS_ENABLED=true
  CORE_PEER_LOCALMSPID=$MSP
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$ORG.exim.com/peers/$PEER.$ORG.exim.com/tls/ca.crt
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$ORG.exim.com/users/Admin@$ORG.exim.com/msp
  CORE_PEER_ADDRESS=$PEER.$ORG.exim.com:$PORT
  CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$ORG.exim.com/peers/$PEER.$ORG.exim.com/tls/server.crt
  CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/$ORG.exim.com/peers/$PEER.$ORG.exim.com/tls/server.key

}


packageChaincode() {
  rm -rf $CC_NAME.tar.gz
  setOrganization exporter

  set -x
  peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${VERSION}
  res=$?
  set +x
}

installChaincode() {
  if [ $CHANNEL_NAME == "marketplacechannel" ]
  then
    setOrganization exporter
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.exporter ===================== "
    setOrganization importer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.importer ===================== "
    setOrganization eximbusiness
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.eximbusiness ===================== "
  fi
}

queryInstalled() {
  setOrganization exporter
  peer lifecycle chaincode queryinstalled >&log.txt
  cat log.txt
  PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
  echo PackageID is ${PACKAGE_ID}
  set +x
  echo "===================== Query installed successful on peer0.exporter ===================== "
}

approveForExporterOrg() {
  setOrganization exporter
  set -x
  peer lifecycle chaincode approveformyorg \
  --ordererTLSHostnameOverride orderer1.exim.com \
  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
  --channelID $CHANNEL_NAME --name ${CC_NAME} \
  --version ${VERSION} \
  --package-id ${PACKAGE_ID} --sequence ${VERSION}
  set +x
  echo "===================== Chaincode is approved for install on peer0.exporter ===================== "
}

approveForImporterOrg() {
  setOrganization importer
  set -x
  peer lifecycle chaincode approveformyorg --ordererTLSHostnameOverride orderer1.exim.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} --package-id ${PACKAGE_ID} --sequence ${VERSION}
  res=$?
  set +x
  verifyResult $res "Chaincode installation on peer0.importer has Failed"
  echo "===================== Chaincode is approved for install on peer0.importer ===================== "
}

approveForEximbusinessOrg() {
  setOrganization eximbusiness
  set -x
  peer lifecycle chaincode approveformyorg --ordererTLSHostnameOverride orderer1.exim.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} --package-id ${PACKAGE_ID} --sequence ${VERSION}
  res=$?
  set +x
  # verifyResult $res "Chaincode installation on peer0.eximbusiness has Failed"
  echo "===================== Chaincode is approved for install on peer0.eximbusiness ===================== "
}

checkCommitReadiness() {
  setOrganization exporter
  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json
  cat log.txt
  # checkResult $res "Chaincode definition approved but not yet committed"
  echo "===================== Check commit readiness successful on peer0.exporter ===================== "
}

commitChaincodeDefinition() {

    setOrganization exporter


    peer lifecycle chaincode commit \
    --ordererTLSHostnameOverride orderer1.exim.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses peer0.exporter.exim.com:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
    --peerAddresses peer0.importer.exim.com:8051 --tlsRootCertFiles $Importer_CORE_PEER_TLS_CERT \
    --peerAddresses peer0.eximbusiness.exim.com:9051 --tlsRootCertFiles $Eximbusiness_CORE_PEER_TLS_CERT \
    --version ${VERSION} --sequence ${VERSION}

    res=$?
    set +x
    verifyResult $res "Chaincode definition commit failed on peer0.exporter"
    echo "===================== Chaincode definition committed on peer0.exporter ===================== "
}

queryCommitted() {
  setOrganization exporter
  peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

chaincodeInvokeInit() {
  setOrganization exporter
  set -x
  peer chaincode invoke \
  --ordererTLSHostnameOverride orderer1.exim.com \
  --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
  -C $CHANNEL_NAME -n ${CC_NAME} \
  --peerAddresses peer0.exporter.exim.com:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE \
  --peerAddresses peer0.importer.exim.com:8051 --tlsRootCertFiles $Importer_CORE_PEER_TLS_CERT \
  --peerAddresses peer0.eximbusiness.exim.com:9051 --tlsRootCertFiles $Eximbusiness_CORE_PEER_TLS_CERT \
  -c '{"function":"initLedger","Args":[]}'
  set +x
}

if [ "$1" == "c" ]
then
  CHANNEL_NAME="marketplacechannel"
  CC_SRC_PATH="../../../chaincode/marketplace/"
  CC_NAME="marketplace"
  Importer_CORE_PEER_TLS_CERT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/ca.crt
  Eximbusiness_CORE_PEER_TLS_CERT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/ca.crt
  

  # packageChaincode

  installChaincode
  queryInstalled

  approveForExporterOrg
  checkCommitReadiness
  approveForImporterOrg
  checkCommitReadiness
  approveForEximbusinessOrg
  checkCommitReadiness
  sleep 5
  commitChaincodeDefinition
  sleep 5
  queryCommitted
fi