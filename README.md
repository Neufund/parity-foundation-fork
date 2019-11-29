# Parity with ethminer on foundation fork

This is parity mines on a foundation fork, with low difficulty so single cpu miner is enough. The networkID is **72**. Peer protocol is disabled so node does not sync.

**use it only for development purposes. this node is not secured, a lot of accounts are unlocked, there are standard authcodes, ALSO YOUR MAINNET WALLETS WORK HERE SO MIND WHERE ARE YOU MAKING TRANSACTIONS**

## Getting Started

### Installing

Clone repository and build docker container
```
make run
```
or
```
docker-compose -p eth_parity_foundation_fork -f docker-compose.yml up --build -d
```

This node requires that parity database create by fully sync foundation node is available in `/var/lib/docker/volumes/backend_parity_data/_data/chains/ethereum`.
You can change this location in docker-compose. Please note that if you sync parity with warp enabled you will have access to past events, therefore we do not advise it.
Use --no-warp when syncing. Still properly configuring the fork requires to provide "bombDefuseTransition": in foundation-fork.json to the last synced mainnet block. This will prevent miner in the container from stopping producing blocks.

### Using compiled parity version
You can build custom parity by modifying `Dockerfile.rust` and using `make run-rust`. Currently we use it to build a version with custom JSON-RPC command `getLogDetails`.

### Obtaining Ether

Just wait for ethminer to create DAG (long) and then `0x8a194c13308326173423119f8dcb785ce14c732b` will start receiving block rewards

### Recreating fork

Here is the procedure to create foundation fork we used.

1. sync mainnet node with --no-warp. this is crucial to preserve log events!
2. stop parity
3. copy foundation.json from https://raw.githubusercontent.com/paritytech/parity/a7887fa9f11bbbc05b48f06f75a85383a86a5f2a/ethcore/res/ethereum/foundation.json , rename to foundation-fork.json
4. change storage location in chainspec ("dataDir": "foundation-fork",)
and change the networkId ("networkID" : "0x19",) this is super important to prevent syncing to mainnet and mixing up transactions. Note that single byte code < 127 is preferable. (Nano Ledger libraries will not sign higher chaincodes).
5. now lower the difficulty and disable ice age (provide next last block to head in snapshot)
```
  "minimumDifficulty": "0x01",
  "difficultyBoundDivisor": "1",
  "difficultyIncrementDivisor": "0x4",
  "durationLimit": "0x0d",
  "bombDefuseTransition": "5462881" <-- here put last block you have got from mainnet,
```
https://wiki.parity.io/Pluggable-Consensus.html
https://wiki.parity.io/Chain-specification.html

8. install and run ethhash
https://steemit.com/ethereum/@virtualcoin/how-to-mine-ethereum-using-the-cpu-for-linux
https://wiki.parity.io/Mining

`ethminer -C`
9. run parity (see `supervisord.conf`)

and you should have block quite irregularly but with median of 4 seconds

### Parity version

We use `parity 1.9.7` from parity website

## Connecting to node

To connect to web interface of the node

```
http://127.0.0.1:8180/
```

If used remotely
1. we setup authcodes, you can use those to login remotely
2. ports 8180 and 8546 (websocket) must be accessible to use UI remotely

**it's really only meant for dev**

## Backuping and restoring tip of the chain

Easiest way is to just store original chain and copy it over to "reset" the node. However chain is huge. We'll provide more info once procedures of copying just last few snapshots are established.
