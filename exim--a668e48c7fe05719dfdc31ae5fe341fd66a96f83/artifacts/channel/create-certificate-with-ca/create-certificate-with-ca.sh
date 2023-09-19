createCertificateForExporter(){
    echo
    echo "enrolling exporter Admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/


    fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-exporter --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-exporter.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-exporter.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-exporter.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-7054-ca-exporter.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/config.yaml

    echo
    echo "Register peer0"
    echo
    fabric-ca-client register --caname ca-exporter --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    echo
    echo "Register peer1"
    echo
    fabric-ca-client register --caname ca-exporter --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/peers

    echo
    echo "Register the org admin"
    echo

    fabric-ca-client register --caname ca-exporter --id.name exporterbusiness --id.secret exporterbusinesspw --id.type admin --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem


    # -----------------------------------------------------------------------------------
    #  Peer 0
    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com

    echo
    echo "## Generate the peer0 msp"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-exporter -M ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/msp --csr.hosts peer0.exporter.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer0-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-exporter -M ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls --enrollment.profile tls --csr.hosts peer0.exporter.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/tlsca
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/tlsca/tlsca-exporter-cert.pem

    mkdir ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/ca
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer0.exporter.exim.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/ca/ca-exporter-cert.pem

    # ------------------------------------------------------------------------------------------------

    # Peer1

    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com

    echo
    echo "## Generate the peer1 msp"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-exporter -M ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/msp --csr.hosts peer1.exporter.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer1-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-exporter -M ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls --enrollment.profile tls --csr.hosts peer1.exporter.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/peers/peer1.exporter.exim.com/tls/server.key

    # # --------------------------------------------------------------------------------------------------

    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/users

    mkdir -p ../crypto-config/peerOrganizations/exporter.exim.com/users/Admin@exporter.exim.com

    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://exporterbusiness:exporterbusinesspw@localhost:7054 --caname ca-exporter -M ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/users/Admin@exporter.exim.com/msp --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/exporter.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/exporter.exim.com/users/Admin@exporter.exim.com/msp/config.yaml
}

createCertificateForImporter(){
    echo
    echo "enrolling importer Admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/importer.exim.com/


    fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-importer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-importer.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-importer.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-importer.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-8054-ca-importer.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/config.yaml

    echo
    echo "Register peer0"
    echo
    fabric-ca-client register --caname ca-importer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    echo
    echo "Register peer1"
    echo
    fabric-ca-client register --caname ca-importer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/peers

    echo
    echo "Register the org admin"
    echo

    fabric-ca-client register --caname ca-importer --id.name importer --id.secret importerpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem


    # -----------------------------------------------------------------------------------
    #  Peer 0
    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com

    echo
    echo "## Generate the peer0 msp"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-importer -M ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/msp --csr.hosts peer0.importer.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer0-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-importer -M ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls --enrollment.profile tls --csr.hosts peer0.importer.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/tlsca
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/tlsca/tlsca-importer-cert.pem

    mkdir ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/ca
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer0.importer.exim.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/ca/ca-importer-cert.pem

    # ------------------------------------------------------------------------------------------------

    # Peer1

    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com

    echo
    echo "## Generate the peer1 msp"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-importer -M ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/msp --csr.hosts peer1.importer.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer1-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-importer -M ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls --enrollment.profile tls --csr.hosts peer1.importer.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/peers/peer1.importer.exim.com/tls/server.key

    # # --------------------------------------------------------------------------------------------------

    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/users

    mkdir -p ../crypto-config/peerOrganizations/importer.exim.com/users/Admin@importer.exim.com

    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://importer:importerpw@localhost:8054 --caname ca-importer -M ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/users/Admin@importer.exim.com/msp --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/importer.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/importer.exim.com/users/Admin@importer.exim.com/msp/config.yaml
}

createCertificateForEximbusiness(){
    echo
    echo "enrolling eximbusiness Admin"
    echo
    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/


    fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-eximbusiness --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-eximbusiness.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-eximbusiness.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-eximbusiness.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-9054-ca-eximbusiness.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/config.yaml

    echo
    echo "Register peer0"
    echo
    fabric-ca-client register --caname ca-eximbusiness --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    echo
    echo "Register peer1"
    echo
    fabric-ca-client register --caname ca-eximbusiness --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/peers

    echo
    echo "Register the org admin"
    echo

    fabric-ca-client register --caname ca-eximbusiness --id.name eximbusiness --id.secret eximbusinesspw --id.type admin --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem


    # -----------------------------------------------------------------------------------
    #  Peer 0
    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com

    echo
    echo "## Generate the peer0 msp"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-eximbusiness -M ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/msp --csr.hosts peer0.eximbusiness.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer0-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-eximbusiness -M ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls --enrollment.profile tls --csr.hosts peer0.eximbusiness.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/tlsca
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/tlsca/tlsca-eximbusiness-cert.pem

    mkdir ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/ca
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer0.eximbusiness.exim.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/ca/ca-eximbusiness-cert.pem

    # ------------------------------------------------------------------------------------------------

    # Peer1

    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com

    echo
    echo "## Generate the peer1 msp"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca-eximbusiness -M ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/msp --csr.hosts peer1.eximbusiness.exim.com --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/msp/config.yaml

    echo
    echo "## Generate the peer1-tls certificates"
    echo
    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca-eximbusiness -M ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls --enrollment.profile tls --csr.hosts peer1.eximbusiness.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/peers/peer1.eximbusiness.exim.com/tls/server.key

    # # --------------------------------------------------------------------------------------------------

    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/users

    mkdir -p ../crypto-config/peerOrganizations/eximbusiness.exim.com/users/Admin@eximbusiness.exim.com

    echo
    echo "## Generate the org admin msp"
    echo
    fabric-ca-client enroll -u https://eximbusiness:eximbusinesspw@localhost:9054 --caname ca-eximbusiness -M ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/users/Admin@eximbusiness.exim.com/msp --tls.certfiles ${PWD}/fabric-ca/peerOrganizations/eximbusiness.exim.com/tls-cert.pem

    cp ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/eximbusiness.exim.com/users/Admin@eximbusiness.exim.com/msp/config.yaml
}

createCretificateForEximOrderer() {
    echo
    echo "Enroll the CA admin"
    echo
    mkdir -p ../crypto-config/ordererOrganizations/exim.com

    export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/exim.com


    fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    echo 'NodeOUs:
    Enable: true
    ClientOUIdentifier:
        Certificate: cacerts/localhost-10054-ca-orderer.pem
        OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
        Certificate: cacerts/localhost-10054-ca-orderer.pem
        OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
        Certificate: cacerts/localhost-10054-ca-orderer.pem
        OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
        Certificate: cacerts/localhost-10054-ca-orderer.pem
        OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/config.yaml

    echo
    echo "Register orderer1"
    echo

    fabric-ca-client register --caname ca-orderer --id.name orderer1 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    echo
    echo "Register orderer2"
    echo

    fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    echo
    echo "Register orderer3"
    echo

    fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    echo
    echo "Register the orderer admin"
    echo

    fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    mkdir -p ../crypto-config/ordererOrganizations/exim.com/orderers
    # mkdir -p ../crypto-config/ordererOrganizations/exim.com/orderers/exim.com

    # ---------------------------------------------------------------------------
    #  Orderer 1

    mkdir -p ../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com

    echo
    echo "## Generate the orderer msp"
    echo

    fabric-ca-client enroll -u https://orderer1:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp --csr.hosts orderer1.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp/config.yaml

    echo
    echo "## Generate the orderer-tls certificates"
    echo

    fabric-ca-client enroll -u https://orderer1:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls --enrollment.profile tls --csr.hosts orderer1.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer1.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    # -----------------------------------------------------------------------
    #  Orderer 2

    mkdir -p ../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com

    echo
    echo "## Generate the orderer msp"
    echo

    fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/msp --csr.hosts orderer2.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/msp/config.yaml

    echo
    echo "## Generate the orderer-tls certificates"
    echo

    fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls --enrollment.profile tls --csr.hosts orderer2.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    # mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts
    # cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer2.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    # ---------------------------------------------------------------------------
    #  Orderer 3
    mkdir -p ../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com

    echo
    echo "## Generate the orderer msp"
    echo

    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/msp --csr.hosts orderer3.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/msp/config.yaml

    echo
    echo "## Generate the orderer-tls certificates"
    echo

    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls --enrollment.profile tls --csr.hosts orderer3.exim.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/ca.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/server.crt
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/server.key

    mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/msp/tlscacerts
    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    # mkdir ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts
    # cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/orderers/orderer3.exim.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/tlscacerts/tlsca.exim.com-cert.pem

    # ---------------------------------------------------------------------------

    mkdir -p ../crypto-config/ordererOrganizations/exim.com/users
    mkdir -p ../crypto-config/ordererOrganizations/exim.com/users/Admin@exim.com

    echo
    echo "## Generate the admin msp"
    echo

    fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/exim.com/users/Admin@exim.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrganizations/orderer.exim.com/tls-cert.pem


    cp ${PWD}/../crypto-config/ordererOrganizations/exim.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/exim.com/users/Admin@exim.com/msp/config.yaml

}

createCertificateForExporter
createCertificateForImporter
createCertificateForEximbusiness
createCretificateForEximOrderer