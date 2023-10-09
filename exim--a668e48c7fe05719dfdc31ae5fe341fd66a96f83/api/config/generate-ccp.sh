function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${MSP}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json
}

ORG=exporter
MSP=ExporterMSP
P0PORT=7051
CAPORT=7054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/exporter.exim.com/tlsca/tlsca-exporter-cert.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/exporter.exim.com/ca/ca-exporter-cert.pem

echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-exporter.json
echo "Successfully generated connection-exporter.json"

ORG=importer
MSP=ImporterMSP
P0PORT=8051
CAPORT=8054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/importer.exim.com/tlsca/tlsca-importer-cert.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/importer.exim.com/ca/ca-importer-cert.pem

echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-importer.json

ORG=eximbusiness
MSP=EximBusinessMSP
P0PORT=9051
CAPORT=9054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/eximbusiness.exim.com/tlsca/tlsca-eximbusiness-cert.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/eximbusiness.exim.com/ca/ca-eximbusiness-cert.pem

echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-eximbusiness.json

# ORG=regulator
# MSP=RgulatorMSP
# P0PORT=10051
# CAPORT=11054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/regulator.exim.com/tlsca/tlsca-regulator-cert.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/regulator.exim.com/ca/ca-regulator-cert.pem

# echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-regulator.json