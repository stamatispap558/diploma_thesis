# generating crypto materials
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

#  System channel
SYS_CHANNEL="exim-sys-channel"
export FABRIC_CFG_PATH=$HOME/exim/artifacts/channel

# Generate System Genesis block
configtxgen -profile EximMultiNodeEtcdRaft -configPath . -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block

#### Marketplace Channel #####

configtxgen -profile ThreeOrgsMarketplaceChannel  -outputCreateChannelTx ./channel-artifacts/marketplacechannel/channel.tx -channelID marketplacechannel

configtxgen -profile ThreeOrgsMarketplaceChannel -configPath . -outputAnchorPeersUpdate ./channel-artifacts/marketplacechannel/ExporterOrgMSPanchors.tx -channelID marketplacechannel -asOrg Exporter

configtxgen -profile ThreeOrgsMarketplaceChannel -configPath . -outputAnchorPeersUpdate ./channel-artifacts/marketplacechannel/ImporterOrgMSPanchors.tx -channelID marketplacechannel -asOrg Importer

configtxgen -profile ThreeOrgsMarketplaceChannel -configPath . -outputAnchorPeersUpdate ./channel-artifacts/marketplacechannel/EximBusinessOrgMSPanchors.tx -channelID marketplacechannel -asOrg EximBusiness

configtxgen -profile ThreeOrgsMarketplaceChannel -configPath . -outputAnchorPeersUpdate ./channel-artifacts/marketplacechannel/RegulatorOrgMSPanchors.tx -channelID marketplacechannel -asOrg Regulator
