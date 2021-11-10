## Obscuro VM
Developers should be able to write smart contracts in a familiar smart contract language using familiar blockchain abstractions, or deploy existing smart contracts to Obscuro.
Obscuro supports a runtime largely compatible with the EVM.

The Obscuro VM has the following requirements:
* Obscuro wishes to use [Conclave](https://conclave.net/), which is a JVM-based SDK, so the ObscuroVM should run on top of the JVM.
* There are differences between the data structures used by Ethereum and the ones used by Obscuro, but these are not directly visible to contract creators.
* Implement data protection.
* Introduce new abstractions or primitives to reflect the data privacy requirements.
* Metering.

Note: Designing the Obscuro VM coupled with contract composability is difficult, so the first phase will implement hardcoded smart contracts.