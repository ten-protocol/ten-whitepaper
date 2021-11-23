## Obscuro VM

Obscuro application developers will write smart contracts in a familiar programming language using familiar blockchain tools and abstractions. Due to data privacy concerns, existing smart contracts will have to change before deploying them to Obscuro.
To implement these requirements, Obscuro supports a runtime largely compatible with the EVM.

The Obscuro VM is based on [Geth](https://github.com/ethereum/go-ethereum), the canonical implementation of the Ethereum protocol.

There are significant differences between the data structures used by Ethereum and the ones used by Obscuro, but these are not directly visible to contract creators. The rollup structure differs significantly from the Ethereum block structure as it contains encrypted transactions, plaintext withdrawal instructions, plaintext events, and many more. The OVM also introduces new abstractions and primitives to reflect the data privacy requirements and implements data isolation where it is needed. One last significant difference from the EVM is the implementation of the Obscuro cryptography requirements.
