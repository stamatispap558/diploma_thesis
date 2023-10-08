CHANNEL_NAME=$CHANNEL_NAME
# NUM_ORGS_IN_CHANNEL=$NUM_ORGS_IN_CHANNEL
NEW_PEER=$PEER
NEW_PEER_ORG=$ORG
DELAY=3
COUNTER=1
MAX_RETRY=5
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem


verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute Channel Create and Join Scenario ==========="
    echo
    exit 1
  fi
}

exporterorg_PORT=7051
importerorg_PORT=8051
eximbusinessorg_PORT=9051
regulatororg_PORT=10051

setEnvironment(){
  if [[ $# -lt 1 ]]
  then
    echo "Run: setEnvironments <org> [<peer>]"
    exit 1
  fi
  ORG=$1
  PEER=peer0
  if [[ $# -eq 2 ]]
  then
    PEER=$2
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
  elif [[  "$ORG" == "eximbusiness" ]]
  then
    MSP=EximBusinessMSP
    PORT=$eximbusinessorg_PORT
  elif [[  "$ORG" == "regulator" ]]
  then
    MSP=RegulatorMSP
    PORT=$regulatororg_PORT
  else
    echo "Unknown org: $ORG"
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

createChannel(){
    setEnvironment ${ORG1}
    #echo all the environment variables
    # env | grep CORE

    set -x
    peer channel create -o orderer1.exim.com:7050 -c $CHANNEL_NAME -f ../channel-artifacts/${CHANNEL_NAME}/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --connTimeout 320s >&log.txt
    res=$?
    set +x

    cat log.txt
    verifyResult $res "Channel creation failed"
    echo "===================== Channel '$CHANNEL_NAME' created ===================== "
    echo
}

joinChannel(){
  setEnvironment ${ORG1}
  peer channel join -b ./${CHANNEL_NAME}.block

  sleep $DELAY

  setEnvironment ${ORG2}
  peer channel join -b ./${CHANNEL_NAME}.block

  sleep $DELAY

  setEnvironment ${ORG3}
  peer channel join -b ./${CHANNEL_NAME}.block

  sleep $DELAY

  setEnvironment ${ORG4}
  peer channel join -b ./${CHANNEL_NAME}.block
  
}

updateAnchorPeers(){
  setEnvironment ${ORG1}
  peer channel update -o orderer1.exim.com:7050 -c ${CHANNEL_NAME} -f ../channel-artifacts/${CHANNEL_NAME}/${ORG1_MSP_ANCHORS} --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --connTimeout 320s
  setEnvironment ${ORG2}
  peer channel update -o orderer1.exim.com:7050 -c ${CHANNEL_NAME} -f ../channel-artifacts/${CHANNEL_NAME}/${ORG2_MSP_ANCHORS} --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --connTimeout 320s
  setEnvironment ${ORG3}
  peer channel update -o orderer1.exim.com:7050 -c ${CHANNEL_NAME} -f ../channel-artifacts/${CHANNEL_NAME}/${ORG3_MSP_ANCHORS} --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --connTimeout 320s
  setEnvironment ${ORG4}
  peer channel update -o orderer1.exim.com:7050 -c ${CHANNEL_NAME} -f ../channel-artifacts/${CHANNEL_NAME}/${ORG4_MSP_ANCHORS} --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --connTimeout 320s
}


# updateAnchorPeersPaymentChannel

if [ "$1" == "cc" ]
then
  ## Create channel
  CHANNEL_NAME=marketplacechannel
  ORG1=exporter
  ORG2=importer
  ORG3=eximbusiness
  ORG4=regulator

  ORG1_MSP_ANCHORS=ExporterOrgMSPanchors.tx
  ORG2_MSP_ANCHORS=ImporterOrgMSPanchors.tx
  ORG3_MSP_ANCHORS=EximBusinessOrgMSPanchors.tx
  ORG4_MSP_ANCHORS=RegulatorOrgMSPanchors.tx

  

  echo "Creating marketplace channel..."
  createChannel
  sleep 5
  echo "========= Channel creation completed =========== "

  echo "Joining marketplace channel..."
  joinChannel
  sleep 5
  echo "========= Channel joined =========== "

  echo "Updating anchor peers for marketplace channel..."
  updateAnchorPeers
  sleep 5
  echo "========= Anchor peers updated =========== "
fi

echo

exit 0