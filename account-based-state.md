## State
TEN is an account-based L2 decentralised ledger system similar to the L1 Ethereum blockchain, where the state is calculated independently by each node based on the canonical list of transactions and stored as a _Patricia Trie_ in each rollup. Each node processes all prior transactions to establish the current state (full sync), and optimised sync methods (e.g. fast sync) will likely be supported. One significant difference is that the account balances can only be calculated inside the TEEs and are only revealed under certain conditions. The model is not described further in this paper because it is the same as [Ethereum Accounts](https://ethereum.org/en/developers/docs/accounts/).

The transaction and smart contract formats are similar to Ethereum, with a few differences introduced by the confidentiality requirements.

### Smart Contracts and the TEN VM
TEN application developers will write smart contracts in a familiar programming language using familiar blockchain tools and abstractions.
Due to data privacy concerns, existing smart contracts will have to change before deploying them to TEN.

To implement these requirements, TEN supports a runtime largely compatible with the _Ethereum Virtual Machine_ (EVM) and is derived from an existing implementation such as [Geth](https://github.com/ethereum/go-ethereum), the canonical client of the Ethereum protocol.

On a high level, the _TEN Virtual Machine_ (OVM) will be almost identical to the EVM, but there are significant differences behind the scenes between the data structures used by Ethereum and the ones used by TEN. The rollup structure also differs significantly from the Ethereum block structure as it contains encrypted transactions, plaintext withdrawal instructions, plaintext events, references to L1 blocks, and more. The OVM will eventually introduce new abstractions and primitives to reflect the data privacy requirements and implement data isolation where it is needed. One last significant difference from the EVM is the implementation of the TEN cryptography requirements.


### State Confidentiality between Smart contracts
The main goal of TEN is to protect user data. If smart contracts were wholly isolated from each other, it would be easy to define data access rules.

Contract composition introduces significant complexity. DeFi enjoys massive success thanks to the ability of contracts to be combined in serendipitous ways not predicted by the contract creator, and TEN intends to replicate that.

For example, one contract might have been written to reveal information for the caller's eyes only in an encrypted response. But if the caller is another contract, that wrapping contract might turn the response into a public broadcast event, visible to everyone.

This area is still under active research. The first version of TEN will rely on application developers to check programmatically who can call different functions and what data they should receive, and therefore developers should reason about what could happen if their contract is called by a contract that they don't control.

For subsequent versions, TEN explores the following concepts:
* Each contract can declaratively whitelist contracts that can access different functions.
* Automatically propagate access. For example, if _Account.getBalance()_ can be invoked only by the owner, it means that any contract that invokes this has to originate from a message signed by the owner. This solution sounds appealing, but it needs more research to determine if this mechanism prevents useful use cases.

###  Wallets and Transaction Submission
User wallets create transactions encrypted with the _TEN public key_. Only valid TEEs (i.e. Aggregators and Verifiers) in possession of the Master Seed can decrypt, execute, and see the resulting state. Still, end-users who submitted a transaction must be able to receive the result and query the balance.

A traditional wallet connected to a node on a public blockchain can read the balance of any account and display it to the user. For a similar user experience, TEN-enabled wallets need to submit signed requests to L2 nodes and receive responses that they can display to the user. The responses need to be encrypted with the user key and have to be cryptographic proofs linking the balance to a rollup.

Validity verification of such proofs can be done by first checking the TEE signature and then by checking that the rollup is on the canonical chain of both the L2 and the L1 chains.

###  Smart Contract Types
Since all data is temporarily private, and smart contracts are just data, the TEN model supports two types of smart contracts.

 - _Public contracts_, which are equivalent to the Ethereum smart contracts in the sense that the source code will be available online, and anyone can build them and compare the hash of the bytecode against the address they are sending commands to.


 - _Private contracts_, for which the developer has not published the source code. These can be used for custom logic like arbitration where the developer intends to keep the profit making strategy hidden from competitors.