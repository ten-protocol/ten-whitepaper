## L1 Contracts
On the L1 network there are several conventional Ethereum contracts which act together as a management contract.

### Network Management
This contract is the gatekeeper for the protocol. Any node wishing to join Obscuro will have to interact with this contract and prove it is valid.

* It registers L2 nodes, verifies their TEE attestation, and manages their stakes. (Stakes are required for the aggregators who publish rollups, as an incentive to follow the protocol.)
* It manages the TEE attestation requirements. This means that the governance of the contract can decide which enclave code is approved to join.
* It manages the L2 TEEs' shared secret key so that it is available in case of L2 node failure. The L1 acts as the ultimate high availability storage. Note: This is expanded in the [Cryptography](detailed-design#cryptography) section.
* It keeps a list of IP addresses for all aggregators.

### Rollup Management
This contract interacts with the aggregators.

* It determines whether to accept blocks of transactions submitted by a L2 node. E.g. the Rollup contract will not accept a rollup from an aggregator that has no stake or a valid attestation.
* It stores the encrypted L2 transactions in an efficient format.

### Bridge Management
This contract is important for the security of the solution since all value deposited by end users will be locked in this bridge.

* It acts as a pool where people can deposit assets, like fungible or non-fungible ERC tokens, which will be made available as wrapped tokens to use on the Obscuro network, and which they can withdraw later.
* In case of conflicting forks in the rollup chain, it must delay withdrawals until one fork expires, or enter a procedure to discover which fork is the valid one. This is covered in more detail in [Withdrawals](detailed-design#withdrawals).
* It may be extended to manage liquidity yields.

### Explicit Governance Mechanism
The management contract is the root of trust for the L2 network. The implemented governance mechanism will control:
* The attestation requirements.
* Various parameters like the frequency of key rotation and disclosure.
* Whether to declare that there was a massive security breach and to take the appropriate measures.
* One possible measure is to command all valid enclaves to disclose the encryption keys, to allow independent verification of transactions.
* In case of a severe breach, the governance will have to select the valid ledger and freeze it such that everyone has the chance to withdraw using balance proofs.

Since Obscuro follows the rollup pattern, the L1 is the source of truth for the L2 network. Any L2 node with a valid TEE in possession of the shared secret is able to download all the rollups from the L1, calculate the entire state inside its encrypted memory, and at the same time validate all transactions.

#### Governance
There are two types of powers for a decentralised network
- Explicit powers exercised by a group of people using direct signing or voting.
- Powers implicit in the protocol.

Ideally, most powers should be implicit.

Bitcoin miners, for example, have some power to determine the rules, by choosing which version of the core code to install and to produce blocks with. In case there are disagreements there will be a fork and the user community will ultimately decide what value to assign to each fork. This is only a problem if the competing forks have similar mining power, and thus security.
For day to day upgrades, miners have the de-facto decision power, but in case of disagreements, it is the users who have the ultimate power through free markets.
This is currently the golden standard for decentralised governance, with advantages and disadvantages.

Obscuro aims for as much decentralisation as practically possible.

This is a list of Obscuro powers

1. The TEE attestation requirements
   This controls which software is able to process the user transactions and create the rollups.

A group of competent auditors have to carefully analyze the code that will run inside the TEE, and approve it by signing it.
The list of "approved auditors" has to be configured by someone.

This is not very different from the smart contracts security auditors, with the exception that in a public blockchain users can decide themselves which auditors they trust by using or not using those contracts.

With TEE solutions, these auditors have to be declared in the management contract, and users will use the l2 network controlled by that contract if they trust that group of auditors.
Based on the declared auditors, the smart contract will approve a proposed software.

The auditors have to be independent and reputable parties.

2. Admin of the different management contract modules
   These modules will have upgradeable parts, to cater for bugs and features.
   Whatever is upgradeable means that the "admins" have full powers over those aspects.
   a. Bridge logic
   b. Rollup logic
   c. Attestation logic

In the example above, the auditors is a fixed list. But that might not be practical, as companies might appear or disappear. The list of approved auditors has to be managed by someone who will have an even higher power.

Ideally this list should be managed through a proposal and vote process by the community without any requirement for human intervention.

Going a level deeper, the code that manages this process might need to be upgradeable, so there is someone controlling it.

3. Creating rollups
   Aggregators with attested software and hardware who have paid a stake.

4. Canonical chain
   The canonical chain is not decided by the users, as with layer 1 solutions.
   It is decided by the management contract, based on the repartition of rollups.

This is the main difference between the l1 and Obscuro mechanism. While Obscuro also has multiple possible chains, it's not the users directly who choose them, but the aggregators.


5. Slashing the stake of misbehaving parties.
   For now, the only slashing event is for publishing invalid blocks that try to break the integrity of the ledger. The L1 Rollup contract can't verify the actual validity, so slashing has to be controlled by a group which has executed the rollup and can confirm that it is incorrect. An alternative is a heuristic that everyone who publishes on a fork that is more than N rollups deep which eventually dies out will get punished by slashing.

Obscuro aims to achieve a credible separation of powers.
