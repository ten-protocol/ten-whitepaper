## L1 Contracts
On the L1 network there are several conventional Ethereum contracts which act together as a management contract.

### Network Management
This contract is the gatekeeper for the protocol. Any node wishing to join Obscuro will have to interact with this contract and prove it is valid.

* It registers L2 nodes, verifies their TEE attestation, and manages their stakes. (Stakes are required for the aggregators who publish rollups, as an incentive to follow the protocol.)
* It manages the TEE attestation requirements. This means that the governance of the contract can decide which enclave code is approved to join.
* It manages the L2 TEEs' shared secret key so that it is available in case of L2 node failure. The L1 acts as the ultimate high availability storage. Note: This is expanded in the [Cryptography](#cryptography) section.
* It keeps a list of IP addresses for all aggregators.

### Rollup Management
This contract interacts with the aggregators.

* It determines whether to accept blocks of transactions submitted by a L2 node. E.g. the Rollup contract will not accept a rollup from an aggregator that has no stake or a valid attestation.
* It stores the encrypted L2 transactions in an efficient format.

### Bridge Management
This contract is important for the security of the solution since all value deposited by end users will be locked in this bridge.

* It acts as a pool where people can deposit assets, like fungible or non-fungible ERC tokens, which will be made available as wrapped tokens to use on the Obscuro network, and which they can withdraw later.
* In case of conflicting forks in the rollup chain, it must delay withdrawals until one fork expires, or enter a procedure to discover which fork is the valid one. This is covered in more detail in [Withdrawals](#withdrawals).
* It may be extended to manage liquidity yields.

### Explicit Governance Mechanism
The management contract is the root of trust for the L2 network. The implemented governance mechanism will control:
* The attestation requirements.
* Various parameters like the frequency of key rotation and disclosure.
* Whether to declare that there was a massive security breach and to take the appropriate measures.
* One possible measure is to command all valid enclaves to disclose the encryption keys, to allow independent verification of transactions.
* In case of a severe breach, the governance will have to select the valid ledger and freeze it such that everyone has the chance to withdraw using balance proofs.

Since Obscuro follows the rollup pattern, the L1 is the source of truth for the L2 network. Any L2 node with a valid TEE in possession of the shared secret is able to download all the rollups from the L1, calculate the entire state inside its encrypted memory, and at the same time validate all transactions.

Governance

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
   Aggregators with attested software and hardware who have paid a stake


3. Canonical chain
   The canonical chain is not decided by the users, as with layer 1 solutions.
   It is decided by the management contract, based on the repartition of rollups.

Todo: this is the main difference between the l1 and obscuro mechanism. While we also have multiple possible chains, it's not the users directly who choose them, but the aggregators.


4. Slashing the stake of misbehaving parties
   For now, the only slashing event is for publishing invalid blocks that try to break the integrity of the ledger.
   The L1 management contract can't verify the actual validity, so slashing has to be controlled by a group who have executed the rollup and knows for sure it's fake.
   Or we can come up with some heuristic saying that everyone who publishes on a fork that is more than N rollups deep, which eventually dies out will get punished by slashing.



Ideally we would achieve a credible separation of powers.


### Node Registration
The enclaves must encrypt L2 transactions with a secret key shared across the L2 nodes rather than an enclave-specific key which would be lost if an enclave is damaged.
Before obtaining the shared secret, the L2 nodes must attest that they are running a valid version of the contract execution environment on a valid CPU.

An L2 node invokes a method on the Network Management contract to submit their attestation. Another L2 node (which already holds the secret key inside its enclave) responds by confirming the attestation and then updating this record with the shared secret encrypted using the public key of the new node. Whichever existing L2 node replies first, signed by the enclave to guarantee knowledge of the secret, gets a reward. This solves several problems; the Network Management contract provides a well-known central registration point on a decentralised L1 network which is able to store the L2 shared secret in public, and existing L2 nodes are compensated for their infrastructure and L1 gas costs to onboard new nodes.

The sequence for node registration is shown in the following diagram:
![node registration](./images/node-registration.png)

1. Any L2 node must register with the Network Management contract. The node supplies its TEE attestation. It will also pay a fee for the service of receiving the shared secret. If the node wants to be an aggregator it has to pay the required stake. The first L2 node to register will be responsible with setting up a shared secret - which is the entropy from which all further secrets will be derived.
2. The first L2 node generates a secret and encrypts it with its enclave specific public key to store. It then submits these secrets to the management contract which will store this encrypted secret and register the public key of the newly formed network. This is covered further in [Cryptography](#cryptography).
3. A new party wishing to become an L2 node uses the Network Management contract to submit the remote attestation object, which signals to the network that it wants to know the shared secret. The Network Management contract will check the attestation against the current attestation rules. Existing nodes will be incentivised to respond with the encrypted secret. Any node with a valid TEE able to pass the attestation should be able to receive the key from another node.
4. The new node begins executing all the transactions already published to the Rollup Management contract, in order to synchronise its internally cached state with the other nodes. This includes user deposits and withdrawals into the Bridge contract, as well as confirmed user transactions.

If all L2 nodes go offline, smart contract execution is delayed, and will be resumed when the first node goes online.

If all L2 nodes are destroyed along with their enclave-derived key pairs, the shared secret key will be lost, and the confidential contract state can never again be processed. As long as one L2 node remains bootable and can recreate its enclave-derived key, it may decrypt the shared secret and share it with other nodes. The incentives must ensure that there is enough geographical distribution to make this scenario impossible.

### Attestation Verification
The solution described above assumes that attestation verification can be implemented efficiently as part of the Network Management contract. This is the ideal solution since it makes the contract the root of trust for the L2 network. The governance mechanism of the management contract will control the attestation requirements, like the hash of the program.

### Aggregator Registration
An Aggregator is a special type of L2 node which has the power to be a sequencer in some rounds and submit rollups.

In addition to node registration, there is an additional step of pledging a stake.

The sequence for node registration is shown in the following diagram:
![aggregator staking](./images/aggregator-stake.png)

These are the steps to become an aggregator.
* Register with the L1 Network Management contract and pay a significant stake in the Obscuro token. The stake has multiple roles. The first one is to penalize aggregators who attempt to hack the protocol, and second is for the aggregators to buy into the ecosystem, so that they will make an effort to keep it running smoothly.
* Set up a server with a valid, unaltered, up-to-date and secured TEE and provide an attestation from the hardware manufacturer or a delegate to the management contract.
* On seeing this request to join the network published to the L1, another registered TEE will share the shared secret, used to encrypt and decrypt user transactions.
* Once in possession of the secret, the TEE can start processing all the L2 transactions that are stored on the L1 blockchain and build the state.
* Once this is completed, the new aggregator can join the gossip with the other aggregators and participate in the lottery for producing rollups.
* Some end users will send encrypted instructions directly to this server, and it will gossip these with other nodes in the L2 network, encrypted with the shared secret.
* As aggregators process messages, they maintain the L2 state in the encrypted TEE memory or encrypted in a local database. If they are the winner of the lottery, when the time comes they will create a valid rollup and publish it to L1.
* All aggregators keep track of the blocks submitted to the management contract to make sure they are up-to-date with the source of truth.
* The first aggregator to register has a special role, as it has to create the shared secret.

Note: Each aggregator needs an ETH balance on the L1 to pay for the submission of the rollup.

### User Registration
The Network Management contract is also one of the possible gateways for users to use the L2 network. The sequence is shown in the following diagram:
![user registration](./images/user-registration.png)

The user interaction is very simple. The user deposits supported tokens into the well known address of the Network Management contract, and once the transaction is successfully added to a block, the Obscuro wallet automatically creates a L2 transaction including a proof of the L1 transaction.

Note: There is no need for a _confirmation period_, due to the L2 design based on dependencies between L2 rollups and L1 blocks.