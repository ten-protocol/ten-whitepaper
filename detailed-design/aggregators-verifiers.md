## Aggregators and Verifiers
There are two categories of nodes in the Obscuro network:

### Aggregator Nodes
Aggregators are the nodes in possession of the _shared secret_ who can submit rollups to the L1. To gain this privilege, these nodes must pledge a stake.

End users will send encrypted transactions to any registered aggregators who will then gossip the transactions. Every round, one of the aggregators will publish the transaction in a rollup.

Aggregators have the following functions:
* Integrate with a L1 node to monitor published blocks and to submit rollups.
* Gossip with the other aggregators registered in the management contract.
* Interact with the TEE:
    - Submit user encrypted transactions.
    - Submit signed user balance requests and encrypted responses back to the users.
    - Submit proofs of block inclusion and receive signed rollups.
* Store data encrypted by the TEE and make it available when the TEE requests it. Act as an encrypted database.

### Verifier Nodes
Verifiers are nodes in possession of the shared secret that have not pledged the stake and are not part of the aggregator gossip network. To receive the L2 transactions, they monitor the L1 network and calculate the state based on the rollups submitted there.

End users can interact with either aggregators or verifiers to receive events on submitted transactions or query their accounts' balance. Any end-user can become a verifier with minimal cost if they have compatible hardware.

Allowing these two categories lowers the bar for participation, thus making the network more robust and decentralised since more independent parties guard the shared secret. In a typical system, the more parties are given access to a secret, the more vulnerable it becomes. In the case of Obscuro, the secret is only available inside the TEE, and as long as that is secure, it cannot be obtained by anyone.
