# Governance
There are several types of power exercised in a decentralized system:
1. Explicit powers exercised by a group of people using direct signing or voting.
2. Implicit powers implemented in an immutable protocol.
3. Implicit powers implemented in a protocol that itself is represented by an open-source codebase that is mutable.

Note that almost nothing is truly immutable because a codebase or even hardware executes even the most immutable protocol and can change its behavior. In theory, a truly immutable system could be achieved using various hash constraints within TEEs, however, allowing for upgrades is a more desirable outcome.
Ultimately, for all other cases, there is an explicit governance process somewhere. It is turtles all the way down.

Bitcoin miners, for example, have some power to determine the rules by choosing which version of the core code to install and to produce blocks with. If there are disagreements, there will be a fork, and the user community will ultimately decide what value to assign to each fork. This is only a problem if the competing forks have similar mining power, and thus security. For day-to-day upgrades, miners have the de-facto decision power, but in case of disagreements, the users have the ultimate power through free markets.
This is currently the golden standard for decentralized governance, with advantages and disadvantages.

It gets even more complicated on networks like Ethereum with smart contract capabilities. On the one hand, similar to Bitcoin, the end-users decide which miners have chosen the correct version. On the other hand, the applications running on top of Ethereum have their governance requirements. In the early days, _The DAO_ was falling into the second category: _Implicit powers implemented in an immutable protocol._, but it was hacked, and in forking Ethereum and indirectly creating Ethereum Classic, it became apparent that there was actually a mutable codebase behind the immutable protocol (the Ethereum codebase itself). It also became apparent that users have the ultimate power as they indirectly voted with their wallets on the preferred approach of handling that hack, and Ethereum Classic has much lower adoption that the mutated Ethereum.

After that hard lesson, the majority of Ethereum smart contracts have component contracts that can be upgraded through an explicit governance process since it is unlikely the community will again provide "get out of jail free" cards to application developers. Sometimes the governance is obfuscated, but generally, if the contract is _upgradeable_, it means someone is in charge.

The key difference between the golden standard of Bitcoin, and typical smart contract governance, is that the end-users no longer have any power to choose which "smart contract fork" they prefer. Using the original smart contract and adding some value to it, they are at the mercy of the application governors.

Since the Obscuro protocol is anchored in Ethereum as a smart contract, it cannot rely on the end-users to hold the ultimate power.
The next best thing is to be very explicit about all the system's powers and achieve separation of powers.

## Obscuro powers
Building on the above, the following powers that are exercised within Obscuro.

###  1. The TEE Attestation Constraints.
The _Attestation Constraints_ (AC) control which software is allowed to run inside the TEE and can process the user transactions and create the rollups. A group of independent, reputable, and competent security auditors has to analyze the code and approve it by signing it carefully. The constraints will contain the keys of the _approved auditors_.

The parties who have the power to set the AC and thus appoint auditors ultimately control the software.

This concern is not completely different from the smart contracts security auditors, except that typically users decide which auditors they trust by using or not using those contracts.


###  2. Administration Of Ethereum Management Contracts.
Like all the other Ethereum applications, these contracts will have upgradeable parts to cater to bugs and new features. Whatever is upgradeable means that the _administrators_ have full powers over those aspects.
1. Bridge logic
2. Rollup logic
3. Attestation logic

In the example above, the auditors are a fixed list. However, that might not be practical, as companies might appear or disappear. The list of approved auditors has to be managed by a proposal and vote process by the community without any requirement for human intervention. Going a level deeper, the code that manages this process might need to be upgradeable, so someone ends up controlling it.

###  3. Creating Rollups
Another power, equivalent to the L1 stakers or miners, is held by Obscuro Aggregators. They run attested software and hardware and have paid a stake.

They have the power to append to the L2 ledger, but they do not have the power to choose competing software and thus create forks.

###  4. Canonical Rollup Chain.
In a typical L1, the canonical chain is ultimately decided by its users from one of the competing forks because the ledger is ultimately coupled to the value of the coin.

In Obscuro, the aggregators have to run attested software, which constraints their free will unless they can hack the TEE technology.

According to the rules implemented, a valid TEE will not sign a rollup building on top of a chain that is not canonical, so any hack will be immediately visible.

Additional complexity involves the withdrawal process, which depends on assured finality on the canonical chain.

###  5. Slashing the Stake of Misbehaving Parties.
Aggregators that hack an enclave and attempt to break the ledger's integrity are discovered by the protocol and will be punished by slashing to disincentivise such disruptive behavior further.

Slashing is an implicit process carried out by the management contract based on predefined rules. Ultimately it is itself controlled by the code governance.