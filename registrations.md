## Joining the Obscuro Network
Anyone wishing to join the Obsuro network as a Node must first check their hardware is compatible with the latest Attestation Constraints. Next they must download and install the latest software. Then they must perform the steps detailed below.

### Node Registration
The enclaves must encrypt L2 transactions with a secret key shared across the L2 nodes rather than an enclave-specific key which would be lost if an enclave is damaged.
Before obtaining the shared secret, the L2 nodes must attest that they are running a valid version of the contract execution environment on a valid CPU.

An L2 node invokes a method on the Network Management contract to submit their attestation. Another L2 node (which already holds the secret key inside its enclave) responds by confirming the attestation and then updating this record with the shared secret encrypted using the public key of the new node. Whichever existing L2 node replies first, signed by the enclave to guarantee knowledge of the secret, gets a reward. This solves several problems; the Network Management contract provides a well-known central registration point on a decentralised L1 network which is able to store the L2 shared secret in public, and existing L2 nodes are compensated for their infrastructure and L1 gas costs to onboard new nodes.

The sequence for node registration is shown in the following diagram:
![node registration](./images/node-registration.png)

1. Any L2 node must register with the Network Management contract. The node supplies its TEE attestation. It will also pay a fee for the service of receiving the shared secret. If the node wants to be an aggregator it has to pay the required stake. The first L2 node to register will be responsible with setting up a shared secret - which is the entropy from which all further secrets will be derived.
2. The first L2 node generates a secret and encrypts it with its enclave specific public key to store. It then submits these secrets to the management contract which will store this encrypted secret and register the public key of the newly formed network. This is covered further in [Cryptography](detailed-design#cryptography).
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

The user interaction is very simple. The user deposits supported tokens into the well known address of the Network Management contract, and once the transaction is successfully added to a block, the Obscuro-enabled wallet automatically creates a L2 transaction including a proof of the L1 transaction.

Note: There is no need for a _confirmation period_, due to the L2 design based on dependencies between L2 rollups and L1 blocks.
