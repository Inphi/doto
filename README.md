# Defense of The Outputs

Join the battle against illegitimate disputes by defending proposed outputs on Optimism Goerli. This repository is your gateway to an effortless participation in the Fault Dispute Game (FDG).

## Prequisites

Make sure you have the following installed on your system:
- docker (with docker compose)
- [foundry](https://book.getfoundry.sh/getting-started/installation)
- At least 30 GB of disk

## Configuration:

Create a .env file with the following envars set:
- OP_CHALLENGER_L1_ETH_RPC - A Goerli Goerli ETH-RPC endpoint 
- OP_CHALLENGER_CANNON_L2 - A Optimism Goerli ETH-RPC endpoint
- OP_CHALLENGER_PRIVATE_KEY - Your Goerli account private key

## Running the Defender

The Defender is a [op-challenger](https://github.com/ethereum-optimism/optimism/tree/develop/op-challenger) preconfigured to participate in Fault Dispute Games 
created by the Fault Dispute Game Factory contract on Goerli.
Once the above configs are set, simply run `bash defend.sh` to begin. The defend script will run the op-challenger on a single random fault dispute game.
If you'd like to participate in multiple games then you should join the frontlines.

## Fronline Defense

If you have sufficient disk (and CPU), you can participate in defending outputs from the frontline by participating in _all_ disputes games.
Simply run `docker compose up` to join the frontline.
