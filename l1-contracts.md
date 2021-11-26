## L1 Contracts
On the L1 network, several conventional Ethereum contracts act together to form a Management Contract.

### Network Management
This contract is the gatekeeper for the protocol. Therefore, any node wishing to join Obscuro must interact with this contract and prove it is valid.

* It registers L2 nodes, verifies their TEE attestation, and manages their stakes. (Stakes are required for the aggregators who publish rollups as an incentive to follow the protocol.)
* It manages the TEE attestation requirements. This means that the governance of the contract can decide which enclave code is approved to join.
* It manages the L2 TEEs' shared secret key to be available in case of L2 node failure. The L1 acts as the ultimate high availability storage. Note: This is expanded in the [Cryptography](./cryptography.md) section.
* It keeps a list of IP addresses for all aggregators.

### Rollup Management
This contract interacts with the aggregators.

* It determines whether to accept blocks of transactions submitted by an L2 node. The Rollup contract can only accept a rollup from an aggregator with a stake and valid attestation, and it checks that the signature of the rollup generated in the TEE matches the Obscuro_Public_Key registered by the L2 node.
* It stores the encrypted L2 transactions in an efficient format.

### Bridge Management
This contract is essential for the solution's security since all value deposited by end-users is locked in this bridge.

* It acts as a pool where people can deposit assets, like fungible or non-fungible ERC tokens, made available as wrapped tokens to use on the Obscuro network and can be withdrawn on demand back to an L1.
* In case of conflicting forks in the rollup chain, it must delay withdrawals until one fork expires or enter a procedure to discover which fork is valid. This is covered in more detail in [Withdrawals](./obscuro-ethereum-interaction.md#withdrawals).
* It may be extended to manage liquidity yields.
