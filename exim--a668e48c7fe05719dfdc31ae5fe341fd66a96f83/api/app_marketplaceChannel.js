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
const cors = require('cors');


const host = process.env.HOST || constants.host;
const port = process.env.PORT || constants.port;

const channelName = 'marketplacechannel';
const chaincodeName = 'marketplace';
const ExporterOrgUserID = 'admin';

app.use(bodyParser.json());
app.use(cors());



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
        const contract = network.getContract(chaincodeName);

        app.get('/', async function (req, res) {
            res.send('Welcome to Exim Network');
        });
        
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


        app.get('/readUser/:userID', async function (req, res) {
            try {
              const userID = req.params.userID; // Retrieve "userID" from route parameters
          
              // Assuming "contract" is your logic for fetching user data
              let result = await contract.evaluateTransaction('readUser', userID);
          
              // Handle the result and send it in the response
              if (result) {
                res.send(result.toString());
              } else {
                res.status(404).send('User not found');
              }
            } catch (error) {
              res.status(500).send(error.toString());
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
                const { productID, productType, productQuantity, price, productionDate, exporterID,  intendedBusinessID} = req.body;
                const exporterExists = await checkUserExists(exporterID);
                const importerExists = await checkUserExists(intendedBusinessID);
        
                if (!exporterExists || !importerExists) {
                    res.status(400).send('Exporter or intended business does not exist.');
                    return;
                }
                let result = await contract.evaluateTransaction('CreateProduct', productID, productType, productQuantity, price, productionDate, exporterID, intendedBusinessID);
                await contract.submitTransaction('CreateProduct', productID, productType, productQuantity, price, productionDate, exporterID, intendedBusinessID);
                res.send(result.toString());
            }catch(error){
                res.status(400).send(error.toString());
            }
        });

        async function checkUserExists(userID) {
            try {
                let result = await contract.evaluateTransaction('readUser', userID);
                return result && result.length > 0;
            } catch (error) {
                console.error('Error checking if user exists:', error);
                return false;
            }
        }

        app.post('/changeProductStatus', async function (req, res) {
            //change product status
            try {
                console.log('data ',  req);

                const { productID, status, NewNumberOfPackages, ProductQuantity} = req.body;
                console.log(productID, status, NewNumberOfPackages, ProductQuantity)
                await contract.evaluateTransaction('changeProductStatus', productID, status, NewNumberOfPackages, ProductQuantity);
                let result = await contract.submitTransaction('changeProductStatus', productID, status, NewNumberOfPackages, ProductQuantity);
                console.log(result)
                res.send(result.toString());
            }catch(error){
                console.log('error', error);
                console.log("Error occurred:", error.message); 
                //res.status(400).send(error.toString());
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

        // app.get('/readProduct', async function (req, res) {
        //     //read product
        //     try {
        //         const { productID } = req.body;
        //         let result = await contract.evaluateTransaction('readProduct', productID);
        //         res.send(result.toString());
        //     }catch(error){
        //         res.status(400).send(error.toString());
        //     }
        // });


        app.get('/readProduct/:productID', async function (req, res) {
            try {
              const productID = req.params.productID; // Retrieve "productID" from route parameters
          
              // Assuming "contract" is your logic for fetching product data
              let result = await contract.evaluateTransaction('readProduct', productID);
          
              // Handle the result and send it in the response
              if (result) {
                res.send(result.toString());
              } else {
                res.status(404).send('Product not found');
              }
            } catch (error) {
              res.status(500).send(error.toString());
            }
          });
          

        app.post('/createdelivery', async function (req, res) {
            //create delivery
            try {
                const { deliveryID, productID, exporterID, importerID } = req.body;
                let result = await contract.evaluateTransaction('CreateDeliveryDetails', deliveryID, productID, exporterID, importerID);
                await contract.submitTransaction('CreateDeliveryDetails', deliveryID, productID, exporterID, importerID);
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

        app.get('/readDelivery/:deliveryID', async function (req, res) {
            try {
              const deliveryID = req.params.deliveryID; // Retrieve "deliveryID" from route parameters
          
              // Assuming "contract" is your logic for fetching delivery data
              let result = await contract.evaluateTransaction('readDelivery', deliveryID);
          
              // Handle the result and send it in the response
              if (result) {
                res.send(result.toString());
              } else {
                res.status(404).send('Delivery not found');
              }
            } catch (error) {
              res.status(500).send(error.toString());
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

       
        app.post('/fillNumberOfPackages', async function (req, res) {
            try {
                const { numberOfPackages, productID } = req.body;
        
                // Retrieve the current state of the ledger for the specific product
                const productAsBytes = await contract.evaluateTransaction('readProduct', productID);
                console.log(productAsBytes)
                if (!productAsBytes || productAsBytes.length === 0) {
                return res.status(404).json({
                    error: `Product with ID ${productID} does not exist`,
                });
                }
            
                // Parse the product details from the response
                const product = JSON.parse(productAsBytes.toString());
                console.log(product)
                // Access the product quantity
                const currentQuantity = parseInt(product.ProductQuantity, 10);
                console.log(currentQuantity, numberOfPackages, productID)
                // Check if the operation was successful
                if (currentQuantity < parseInt(numberOfPackages, 10)) {
                // Set status to "Understock" and include remaining stock information
                return res.status(200).json({
                    status: 'Understock',
                    message: "There is understock! Produce more packages.",
                    remainingStock: 0, // Or calculate the correct remaining stock value
                });
                } else {
                // If the operation was successful and there's no understock, respond with success
                await contract.submitTransaction('FillNumberOfPackages', productID, numberOfPackages);
            
                return res.status(200).json({
                    status: 'Success',
                    message: "Number of Packages Filled Successfully!",
                    remainingStock: currentQuantity - numberOfPackages,
                });
                }
            } catch (error) {
                // Handle other errors
                console.error('Error in fillNumberOfPackages route:', error);
                return res.status(500).json({
                status: 'Error',
                error: 'Internal Server Error',
                });
            }
            });

          app.get('/checkStockAndNotify/:productID', async function (req, res) {
            try {
                const { productID } = req.params;
        
                // Evaluate the smart contract transaction
                const resultBuffer = await contract.evaluateTransaction('CheckStockAndNotify', productID);
                const result = JSON.parse(resultBuffer.toString());
        
                // Extract properties from the smart contract result
                const { stockStatus, message, remainingStock } = result;
        
                // Customize the API response based on stock status
                if (stockStatus === 'Overstock') {
                    res.status(200).json({ status: 'success', stockStatus, message, remainingStock });
                } else if (stockStatus === 'Understock') {
                    res.status(200).json({ status: 'warning', stockStatus, message, remainingStock });
                } else {
                    res.status(200).json({ status: 'info', stockStatus, message, remainingStock });
                }
            } catch (error) {
                console.error('Error in checkStockAndNotify route:', error);
                res.status(500).json({ status: 'error', error: 'Internal Server Error' });
            }
        });
        

        

    } catch(error) {
        console.log(error);
    }
}

main();
