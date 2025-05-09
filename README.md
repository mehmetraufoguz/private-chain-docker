# Private Ethereum Chain (Geth v1.12) with Dual Network Architecture

This repository provides a Docker Compose setup to deploy a private Ethereum blockchain using Geth v1.12. The architecture features two isolated network layers—private and public—interconnected through a bridge node. The private network

## Architecture

The system is structured into two separate network layers:

- **Private Network**:
  - **Bootnode**: Facilitates peer discovery for miner and bridge nodes.
  - **3 Miner Nodes**: Responsible for block production and maintaining the private chain.
  - **Bridge Node**: Connects to both private and public networks.

- **Public Network**:
  - **3 Full Nodes**: Sync with the blockchain through the bridge node.
  - **Bridge Node**: Shared with the private network to relay peer and block data.

```
         [Bootnode] (Private)
             |
    -----------------------
    |         |          |
[Miner1]  [Miner2]   [Miner3] (Private)

         [Bridge Node]
     (Connected to both networks)
            / | \
           /  |  \
 [FullNode1] [FullNode2] [FullNode3] (Public)
```

## Prerequisites

Before starting, make sure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/): Required to run containerized nodes.
- [Docker Compose](https://docs.docker.com/compose/install/): Used to orchestrate multi-container setups.
- [Git](https://git-scm.com/) (optional): For cloning the repository.

### Environment Configuration Files

- The repository includes several environment configuration files located in the `env/` folder:
  - `bridge-node.env`
  - `miner.env`
  - `miner1.env.example` (copy and customize for each miner)
  - `node.env`

  You will need to configure these files before proceeding to set up the nodes.

## Setup Steps

Follow these steps to initialize and run the private Ethereum network.

### 1. Compose Up Private Bootnode

- Start the private bootnode using Docker Compose:

  ```bash
  docker-compose up -d private-bootnode
  ```

- Once the bootnode is running, get the `enode` URL from the logs:

  ```bash
  docker-compose logs -f private-bootnode
  ```

- Copy the `enode` URL and update the `ENODE` field in the following files:
  - **`bridge-node.env`**: Set the `ENODE` to the bootnode `enode` URL.
  - **`miner.env`**: Update the `ENODE` in the miner configuration files with the bootnode `enode` URL.

### 2. Compose Up Bridge Node

- Now, start the bridge node using Docker Compose:

  ```bash
  docker-compose up -d bridge-node
  ```

- The bridge node should now be running and connected to the private network through the bootnode.

### 3. Update Node Env with Bridge Node Enode

- After the bridge node is running, get its `enode` URL by checking the logs:

  ```bash
  docker-compose logs -f bridge-node
  ```

- Update the **`node.env`** file to set the `ENODE` value to the bridge node's `enode` URL.

### 4. Compose Up Full Nodes

- Start the full nodes connected to the bridge node:

  ```bash
  docker-compose up -d public-node1 public-node2 public-node3
  ```

- The full nodes should now sync with the private network via the bridge node.

### 5. Create Required Folders

- Create the necessary directories for miner data and keystores:

  ```bash
  mkdir -p volumes/miner1/keystore
  mkdir -p volumes/miner2/keystore
  mkdir -p volumes/miner3/keystore
  ```

### 6. Create `node.pwd` File

- Create a `node.pwd` file and copy it to each of the `keystore` folders for the miners:

  ```bash
  echo "your_wallet_password" > volumes/miner1/keystore/node.pwd
  echo "your_wallet_password" > volumes/miner2/keystore/node.pwd
  echo "your_wallet_password" > volumes/miner3/keystore/node.pwd
  ```

- Make sure to replace `"your_wallet_password"` with the actual password for your wallet.

### 7. Copy Wallet Keystores to Keystore Folders

- Copy the Ethereum wallet keystore files to the appropriate `keystore` directories for each miner. For example:

  - Copy **miner1's** wallet keystore to `volumes/miner1/keystore`.
  - Copy **miner2's** wallet keystore to `volumes/miner2/keystore`.
  - Copy **miner3's** wallet keystore to `volumes/miner3/keystore`.

### 8. Create Miner Env Files

- Copy the **`miner1.env.example`** file and create individual `.env` files for each miner (`miner1.env`, `miner2.env`, `miner3.env`).
  
  For each file, update the following:
  - **`ADDRESS`**: Set the Ethereum address corresponding to each miner's keystore.
  - **`ETH_STAT_MACHINE_ID`**: Unique ID for each miner.
  - **`ETH_STAT_MACHINE_IP`**: IP address of the miner's machine.

### 9. Update Miner Env with Keystore Addresses

- In each miner's `.env` file (e.g., `miner1.env`, `miner2.env`, `miner3.env`), make sure the `ADDRESS` field matches the Ethereum address found in the respective keystore file.

### 10. Compose Up Miners

- Once all `.env` files are configured, start the miner nodes:

  ```bash
  docker-compose up -d miner1 miner2 miner3
  ```

- The miner nodes should now start mining on the private Ethereum network.

## Notes

- All nodes use **Geth v1.12** for Ethereum client functionality.
- The **bridge node** is the only node connected to both private and public networks, enabling limited cross-network communication.
- **Miner nodes** operate solely in the private network and produce blocks.
- **Public full nodes** do not mine; they rely on the bridge node to sync with the chain.
- Logs for any container can be viewed using:

```bash
docker-compose logs -f <service-name>
```

- Ensure port conflicts are avoided, particularly for:
  - `30303` (P2P communication)
  - `8545` (HTTP-RPC)
  - `8546` (WebSocket, if enabled)
- You may customize Geth flags (e.g., network ID, RPC settings) in the Docker Compose or entrypoint scripts as needed.

### Environment Configuration Files

- The `.env` files in the `env/` folder need to be configured correctly before starting the network:
  - **`bridge-node.env`**: Set the `ENODE` of the private bootnode, and provide a unique `ETH_STAT_MACHINE_ID` and `ETH_STAT_MACHINE_IP` for the bridge node.
  - **`miner.env`**: Modify settings like the `ENODE`, `MINER_GASLIMIT`, and `NETWORK_ID` for the miners.
  - **`miner1.env.example`**: Create a unique file for each miner (e.g., `miner2.env`, `miner3.env`) and set the `ADDRESS`, `ETH_STAT_MACHINE_ID`, and `ETH_STAT_MACHINE_IP`.
  - **`node.env`**: Update for full nodes and bridge node, connecting to the bridge node's `ENODE` and providing machine-specific identifiers.
