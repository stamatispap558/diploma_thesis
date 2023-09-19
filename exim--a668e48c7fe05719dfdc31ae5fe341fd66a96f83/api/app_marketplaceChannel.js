'use strict';

const {Gateway, Wallets} = require('fabric-network');
// const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const { getCCP, getCaUrl, getWalletPath, getAffiliation, getRegisteredUser, isUserRegistered } = require('./app/helper');
// const { Console } = require('console');
const { json } = require('body-parser');
// const Client = require('fabric-client');
const http = require('http');
const express = require('express');
const app = express();
const constants = require('./config/constants.json');
const log4js = require('log4js');
const logger = log4js.getLogger('EximNetwork');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const { log } = require('console');

const host = process.env.HOST || constants.host;
const port = process.env.PORT || constants.port;

const channelName = 'marketplacechannel';
const chaincodeName = 'marketplace';
const ExporterOrgUserID = 'admin';

app.use(bodyParser.json());


var server = http.createServer(app).listen(port, function () { console.log(`Server started on ${port}`) });
logger.info('****************** SERVER STARTED ************************');
logger.info('***************  http://%s:%s  ******************', host, port);
server.timeout = 240000;

async function main() {
    const walletPath = await getWalletPath('exporter');
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    

    const ccp = await getCCP('exporter');
    // console.log(ccp);

    const gateway = new Gateway();

    try{
        await gateway.connect(ccp, {
            wallet,
            identity: ExporterOrgUserID,
            discovery: { enabled: true, asLocalhost: true } 
        });

        const network = await gateway.getNetwork(channelName);
        const contract = await network.getContract(chaincodeName);
        
        app.post('/createUser', async function (req, res) {
            //create user
            try {
                const { userID, userName, userEmail, userRole, userOrg, password } = req.body;

                //bcrypt password
                const salt = await bcrypt.genSalt(10);
                const hashedPassword = await bcrypt.hash(password, salt);

                // // console.log(req.body);
                let result = await contract.evaluateTransaction('CreateUser', userID, userName, userEmail, userRole, userOrg, hashedPassword);
                await contract.submitTransaction('CreateUser', userID, userName, userEmail, userRole, userOrg, hashedPassword); 
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });


        app.get('/readUser', async function (req, res) {
            //read user
            try {
                const { userID } = req.body;
                let result = await contract.evaluateTransaction('readUser', userID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/changeUserStatus', async function (req, res) {
            //change user status
            try {
                const { userID, userStatus } = req.body;
                let result = await contract.evaluateTransaction('ChangeUserStatus', userID, userStatus);
                await contract.submitTransaction('ChangeUserStatus', userID, userStatus);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/createProduct', async function (req, res) {
            //create product
            try {
                const { productID, productType, productQuantity, price, productionDate, exporterID } = req.body;
                let result = await contract.evaluateTransaction('CreateProduct', productID, productType, productQuantity, price, productionDate, exporterID);
                await contract.submitTransaction('CreateProduct', productID, productType, productQuantity, price, productionDate, exporterID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/changeProductStatus', async function (req, res) {
            //change product status
            try {
                const { productID, status } = req.body;
                let result = await contract.evaluateTransaction('changeProductStatus', productID, status);
                await contract.submitTransaction('changeProductStatus', productID, status);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateProductImporter', async function (req, res) {
            //update product importer
            try {
                const { productID, importerID } = req.body;
                let result = await contract.evaluateTransaction('UpdateProductImporterID', productID, importerID);
                await contract.submitTransaction('UpdateProductImporterID', productID, importerID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.get('/readProduct', async function (req, res) {
            //read product
            try {
                const { productID } = req.body;
                let result = await contract.evaluateTransaction('readProduct', productID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/createdelivery', async function (req, res) {
            //create delivery
            try {
                const { deliveryID, productID } = req.body;
                let result = await contract.evaluateTransaction('CreateDeliveryDetails', deliveryID, productID);
                await contract.submitTransaction('CreateDeliveryDetails', deliveryID, productID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/changeDeliveryStatus', async function (req, res) {
            //change delivery status
            try {
                const { deliveryID, status } = req.body;
                let result = await contract.evaluateTransaction('ChangeDeliveryStatus', deliveryID, status);
                await contract.submitTransaction('ChangeDeliveryStatus', deliveryID, status);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateTransportation', async function (req, res) {
            //update transportation
            try {
                const { deliveryID, transportationMode } = req.body;
                let result = await contract.evaluateTransaction('UpdateTransportationMode', deliveryID, transportationMode);
                await contract.submitTransaction('UpdateTransportationMode', deliveryID, transportationMode);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateShipmentDate', async function (req, res) {
            //update shipment date
            try {
                const { deliveryID, shipmentDate } = req.body;
                let result = await contract.evaluateTransaction('UpdateShipmentDate', deliveryID, shipmentDate);
                await contract.submitTransaction('UpdateShipmentDate', deliveryID, shipmentDate);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateDeliveryDate', async function (req, res) {
            //update delivery date
            try {
                const { deliveryID, deliveryDate } = req.body;
                let result = await contract.evaluateTransaction('UpdateDeliveryDate', deliveryID, deliveryDate);
                await contract.submitTransaction('UpdateDeliveryDate', deliveryID, deliveryDate);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateCurrentLocation', async function (req, res) {
            //update current location
            try {
                const { deliveryID, currentLocation } = req.body;
                let result = await contract.evaluateTransaction('UpdateCurrentLocation', deliveryID, currentLocation);
                await contract.submitTransaction('UpdateCurrentLocation', deliveryID, currentLocation);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/createCertificate', async function (req, res) {
            //create certificate
            try {
                const { certificateID, ownerName, plotRegNo, inspectionReportNumber, dateOfInspection, verification_of_spray_records } = req.body;
                let result = await contract.evaluateTransaction('CreateCertificate', certificateID, ownerName, plotRegNo, inspectionReportNumber, dateOfInspection, verification_of_spray_records);
                await contract.submitTransaction('CreateCertificate', certificateID, ownerName, plotRegNo, inspectionReportNumber, dateOfInspection, verification_of_spray_records);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.get('/ifCertificateExists', async function (req, res) {
            try {
                const { certificateID } = req.body;
                let result = await contract.evaluateTransaction('IfCertificateExist', certificateID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.get('/readDelivery', async function (req, res) {
            //read delivery
            try {
                const { deliveryID } = req.body;
                let result = await contract.evaluateTransaction('readDelivery', deliveryID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.get('/readCertificate', async function (req, res) {
            //read certificate
            try {
                const { certificateID } = req.body;
                let result = await contract.evaluateTransaction('readCertificate', certificateID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        app.post('/updateCertStatus', async function (req, res) {
            //update certificate status
            try {
                const { certificateID, status } = req.body;
                let result = await contract.evaluateTransaction('UpdateCertificateStatus', certificateID, status);
                await contract.submitTransaction('UpdateCertificateStatus', certificateID, status);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

    } catch(error) {
        console.log(error);
    }
}

main();