# diploma thesis 

implementation of exporter/importer processes (supply chain management) using Hyperledger Fabric architecture and MERN stack

Run the project using the following commands:
1. `eup` (to bring up the network). 
2. `docker exec -it exim_cli sh` to be be dropped into an interactive shell (sh) session inside the `exim_cli` container.
3. `cd scripts` inside the exim_cli.
4. `./channel.sh cc` to create the channel.
5. `./chaincode.sh c` to run the chaincode.
6. `npx nodemon app_marketplaceChannel.js` inside `api` folder to run the backend.
7. `npm start` inside `exim-frontend` folder to run the frontend.

In case the network is already up, we run `edown` first to bring down the network, `cl` to stop and remove the containers, and then steps 1 to 7.

Ready to go!
