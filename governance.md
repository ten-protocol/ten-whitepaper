# Governance
There are two types of powers for a decentralised network:
* Explicit powers exercised by a group of people using direct signing or voting.
* Powers implemented in the protocol, but this is open-source and so these are also explicit.

Ideally, most powers should be implemented in the protocol.

Bitcoin miners, for example, have some power to determine the rules, by choosing which version of the core code to install and to produce blocks with. In case there are disagreements there will be a fork and the user community will ultimately decide what value to assign to each fork. This is only a problem if the competing forks have similar mining power, and thus security. For day to day upgrades, miners have the de-facto decision power, but in case of disagreements, it is the users who have the ultimate power through free markets. This is currently the golden standard for decentralised governance, with advantages and disadvantages.

Obscuro aims for as much decentralisation as practically possible.

This is a list of Obscuro powers:

1. The TEE attestation requirements. These control which software is able to process the user transactions and create the rollups. A group of competent auditors have to carefully analyze the code that will run inside the TEE, and approve it by signing it. The list of _approved auditors_ has to be configured by someone.

This is not very different from the smart contracts security auditors, with the exception that in a public blockchain users can decide themselves which auditors they trust by using or not using those contracts. With TEE solutions, these auditors have to be declared in the Management contract, and users will use the L2 network controlled by that contract if they trust that group of auditors. Based on the declared auditors, the smart contract will approve a proposed software version.

The auditors have to be independent and reputable parties.

2. Administration of the different management contracts. These contracts will have upgradeable parts, to cater for bugs and features. Whatever is upgradeable means that the _administrators_ have full powers over those aspects.
   1. Bridge logic
   2. Rollup logic
   3. Attestation logic

In the example above, the auditors is a fixed list. But that might not be practical, as companies might appear or disappear. The list of approved auditors has to be managed by a proposal and vote process by the community without any requirement for human intervention. Going a level deeper, the code that manages this process might need to be upgradeable, so there is someone controlling it.

3. Creating rollups. Aggregators with attested software and hardware who have paid a stake.

4. Canonical rollup chain. The canonical chain is not decided by the users, as with L1 solutions. It is decided by the Rollup contract, based on the repartition of rollups.

This is the main difference between the L1 and Obscuro mechanism. While Obscuro have multiple possible rollup chains, it's not the users directly who choose them, but the aggregators.

5. Slashing the stake of misbehaving parties. The only current slashing event is for publishing invalid blocks that try to break the integrity of the ledger. The L1 Management contract can't verify the actual validity, so slashing has to be controlled by a group who have executed the rollup and is certain it is deceptive. Alternatively, a heuristic will punish by slashing any aggregator which publishes on a fork that is more than N rollups deep and which eventually dies out.