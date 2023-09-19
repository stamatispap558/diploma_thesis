'use strict';

var { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');

const util = require('util');

const getCCP = async (org) => {
    let ccpPath;
    if(org=="exporter") {
        ccpPath=path.resolve(__dirname, '..', 'config', 'connection-exporter.json');
    } else if (org=="importer") {
        ccpPath=path.resolve(__dirname, '..', 'config', 'connection-importer.json');
    } else if (org=="eximbusiness") {
        ccpPath=path.resolve(__dirname, '..', 'config', 'connection-eximbusiness.json');
    } else
        return null;
    const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
    const ccp = JSON.parse(ccpJSON);
    return ccp;
}

const getCaUrl = async (org, ccp) => {
    let caUrl;
    if(org=="exporter") {
        caUrl=ccp.certificateAuthorities['ca-exporter'].url;
    } else if (org=="importer") {
        caUrl=ccp.certificateAuthorities['ca-importer'].url;
    } else if (org=="eximbusiness") {
        caUrl=ccp.certificateAuthorities['ca-eximbusiness'].url;
    } 
     else
        return null;
    return caUrl;
}

const getWalletPath = async (org) => {
    let walletPath;
    if(org=="exporter") {
        walletPath=path.join(process.cwd(), 'exporter-wallet');
    } else if (org=="importer") {
        walletPath=path.join(process.cwd(), 'importer-wallet');
    } else if (org=="eximbusiness") {
        walletPath=path.join(process.cwd(), 'eximbusiness-wallet');
    }
    else
        return null
    return walletPath;
}

const getRegisteredUser = async (username, userOrg, affiliation) => {
    let ccp = await getCCP(userOrg);
    const caUrl = await getCaUrl(userOrg, ccp);
    const ca = new FabricCAServices(caUrl);

    const walletPath = await getWalletPath(userOrg);
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);


    const userIdentity = await wallet.get(username);
    // console.log(userIdentity);
    if (userIdentity) {
        console.log(`An identity for the user ${username} already exists in the wallet`);
        var response = {
            success: true,
            message: username + ' enrolled Successfully',
        };
        return response
    }

    let adminIdentity = await wallet.get('admin');
    if (!adminIdentity) {
        console.log('An identity for the admin user "admin" does not exist in the wallet');
        await enrollAdmin(userOrg, ccp);
        adminIdentity = await wallet.get('admin');
        console.log("Admin Enrolled Successfully")
    }

    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    // console.log(provider);
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');
    console.log(adminUser);
    let secret;
    try {
        // console.log(affiliation, username, adminUser);
        secret = await ca.register({affiliation : affiliation, enrollmentID: username, role: 'client'}, adminUser);
        console.log(secret);
    } catch (error) {
        return error.message;
    }

    const enrollment = await ca.enroll({enrollmentID: username, enrollmentSecret: secret});
    console.log(enrollment);

    let x509Identity;
    if (userOrg == "exporter") {
        x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'ExporterMSP',
            type: 'X.509',
        };
    } else if (userOrg == "importer") {
        x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'ImporterMSP',
            type: 'X.509',
        };
    } else if (userOrg == "eximbusiness") {
        x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'EximBusinessMSP',
            type: 'X.509',
        };
    }

    await wallet.put(username, x509Identity);

    console.log(`Successfully registered and enrolled admin user ${username} and imported it into the wallet`);

    var response = {
        success: true,
        message: username + ' enrolled Successfully',
    };
    return response
}

const isUserRegistered = async (username, userOrg) => {
    const walletPath = await getWalletPath(userOrg)
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    const userIdentity = await wallet.get(username);
    if (userIdentity) {
        console.log(`An identity for the user ${username} exists in the wallet`);
        return true
    }
    return false
}


const enrollAdmin = async (org, ccp) => {

    console.log('calling enroll Admin method')

    try {

        const caInfo = await getCaInfo(org, ccp);
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        const walletPath = await getWalletPath(org) 
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);


        const identity = await wallet.get('admin');
        if (identity) {
            console.log('An identity for the admin user "admin" already exists in the wallet');
            return;
        }

        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw' });
        let x509Identity;
        if (org == "exporter") {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'ExporterMSP',
                type: 'X.509',
            };
        } else if (org == "importer") {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'ImporterMSP',
                type: 'X.509',
            };
        } else if (org == "eximbusiness") {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'EximBusinessMSP',
                type: 'X.509',
            };
        }

        await wallet.put('admin', x509Identity);
        console.log('Successfully enrolled admin user "admin" and imported it into the wallet');
        return
    } catch (error) {
        console.error(`Failed to enroll admin user "admin": ${error}`);
    }
}

const getCaInfo = async (org, ccp) => {
    let caInfo
    if (org == "exporter") {
        caInfo = ccp.certificateAuthorities['ca-exporter'];
    } else if (org == "importer") {
        caInfo = ccp.certificateAuthorities['ca-importer'];
    } else if (org == "eximbusiness") {
        caInfo = ccp.certificateAuthorities['ca-eximbusiness'];
    }  
    else
        return null

    return caInfo

}


module.exports = {
    getCCP: getCCP,
    getWalletPath: getWalletPath,
    getRegisteredUser: getRegisteredUser,
    isUserRegistered: isUserRegistered
}