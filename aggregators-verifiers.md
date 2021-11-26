### L2 Nodes
There are two categories of nodes in the Obscuro network:

#### Aggregator Nodes
Aggregators are the Obscuro nodes whose TEEs are in possession of the _shared secret_ and can submit rollups to the L1. To gain this privilege, these nodes must pledge a stake.

End users send encrypted transactions to any registered Aggregators who then gossip the transactions. Every round, one of the Aggregators publishes the transaction in a rollup.

Aggregators have the following functions:
* Integrate with an L1 node to monitor published blocks and to submit rollups.
* Gossip with the other aggregators registered in the management contract.
* Interact with the TEE module of the node:
    - Submit user encrypted transactions.
    - Submit signed user balance requests and encrypted responses back to the users.
    - Submit proofs of block inclusion and receive signed rollups.
* Store data encrypted by the TEE and make it available when the TEE requests it. Act as an encrypted database.

Note that logically a node is split into two main sections:
- The section that is controlled by the node operator
- The TEE, which is attested to the Management contract and is in effect controlled by the governance body of Obscuro. 

[comment]: <> (TODO - add diagram )

These are the steps to become an aggregator.
* Register with the L1 Network Management contract and pay a significant stake in the Obscuro token. The stake has multiple roles. The first one is to penalise aggregators who attempt to hack the protocol, and second is for the aggregators to buy into the ecosystem, so that they will make an effort to keep it running smoothly.
* Set up a server with a valid, unaltered and up-to-date TEE and provide an attestation to the management contract.
* On seeing this request to join the network published to the L1, another registered TEE will share the shared secret.
* Once in possession of the secret, the TEE can start processing all the L2 transactions that are stored on the L1 blockchain and build the state.
* Once this is completed, the new aggregator can join the gossip with the other aggregators and participate in the lottery for producing rollups.
* Some end users will send encrypted instructions directly to this server, and it will gossip these with other nodes in the L2 network.
* As aggregators process messages, they maintain the L2 state in the encrypted TEE memory or encrypted in a local database. If they are the winner of the round they can create a valid rollup and publish it to L1.
* All aggregators keep track of the blocks submitted to the management contract to make sure they are up-to-date with the source of truth.
* The first aggregator to register has a special role, as it has to create the _Shared secret_.

Note: Each Aggregator needs an ETH balance on the L1 to pay for the submission of the rollup.

The steps to register as an Aggregator are shown in the following diagram:
![aggregator staking](./images/aggregator-stake.png)

#### Verifier Nodes
Verifiers are nodes in possession of the shared secret that have not pledged the stake and are not part of the aggregator gossip network. To receive the L2 transactions, they monitor the L1 network and calculate the state based on the rollups submitted there.

End users can interact with either aggregators or verifiers to receive events on submitted transactions or query their accounts' balance. Anyone can become a verifier with minimal cost if they have compatible hardware.

Allowing these two categories lowers the bar for participation, thus making the network more robust and decentralised since more independent parties guard the shared secret and can react in the face of an attack. 
