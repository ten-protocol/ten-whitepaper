## L1 Contracts
On the L1 network there are several conventional Ethereum contracts which act together as a management contract.

### Network Management
This contract is the gatekeeper for the protocol. Any node wishing to join Obscuro will have to interact with this contract and prove it is valid.

* It registers L2 nodes, verifies their TEE attestation, and manages their stakes. (Stakes are required for the aggregators who publish rollups, as an incentive to follow the protocol.)
* It manages the TEE attestation requirements. This means that the governance of the contract can decide which enclave code is approved to join.
* It manages the L2 TEEs' shared secret key so that it is available in case of L2 node failure. The L1 acts as the ultimate high availability storage. Note: This is expanded in the [Cryptography](./cryptography.md) section.
* It keeps a list of IP addresses for all aggregators.

### Rollup Management
This contract interacts with the aggregators.

* It determines whether to accept blocks of transactions submitted by a L2 node. The Rollup contract will not accept a rollup from an aggregator that has no stake or a valid attestation, and it will check the signature of the rollup generated in the TEE matches the Obscuro_Public_Key registered by the L2 node.
* It stores the encrypted L2 transactions in an efficient format.

### Bridge Management
This contract is important for the security of the solution since all value deposited by end users will be locked in this bridge.

* It acts as a pool where people can deposit assets, like fungible or non-fungible ERC tokens, which will be made available as wrapped tokens to use on the Obscuro network, and which they can withdraw later.
* In case of conflicting forks in the rollup chain, it must delay withdrawals until one fork expires, or enter a procedure to discover which fork is the valid one. This is covered in more detail in [Withdrawals](./obscuro-ethereum-interaction.md#withdrawals).
* It may be extended to manage liquidity yields.
