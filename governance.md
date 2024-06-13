# Governance
Governance for the TEN protocol, the reference implementation, and the network configuration will be made explicit and visible to all. TEN governance thinking is derived from the experience of Bitcoin and Ethereum.

There are several types of control exercised in a decentralised system:
1. Explicit control exercised by a group of people using direct signing or voting.
2. Implicit control implemented in an immutable protocol.
3. Implicit control implemented in a protocol that itself is represented by an open-source codebase that is mutable.

Note that almost nothing is truly immutable because a codebase or even hardware executing even the most immutable protocol can change its behaviour, or it can be changed. In theory, a truly immutable system could be achieved using various hash constraints within TEEs; however, allowing for upgrades is a more desirable outcome. Ultimately, for all other cases, there is an explicit governance process somewhere.

Bitcoin miners, for example, have some power to determine the rules by choosing which version of the core code to install and to produce blocks with. If there is disagreement, there is a fork, and the user community ultimately decides what value to assign to each fork. This is only a problem if the competing forks have similar mining power, and thus security. For day-to-day upgrades, miners have the de-facto decision power, but in case of disagreements, the users have the ultimate power through free markets.
This is currently the golden standard for decentralised governance, with advantages and disadvantages.

It gets even more complicated on networks like Ethereum with smart contract capabilities. On the one hand, similar to Bitcoin, the end-users decide which miners have chosen the correct version. On the other hand, the applications running on top of Ethereum have their governance requirements. In the early days, _The DAO_ fell into the second category: _Implicit controls implemented in an immutable protocol._, but it was exploited, and in addressing this by forking Ethereum and indirectly creating Ethereum Classic, it became apparent that there was actually a mutable codebase behind the immutable protocol (the Ethereum codebase itself). It also became apparent that users have the ultimate power as they indirectly voted with their wallets on the preferred approach of handling that hack, and Ethereum Classic has much lower adoption than the mutated Ethereum.

After that hard lesson, most Ethereum smart contracts have component contracts that can be upgraded through an explicit governance process since it is unlikely the community will again provide "get out of jail free" cards to application developers. Sometimes the governance is obfuscated, but generally, if the contract is _upgradeable_, it means someone is in charge.

The key difference between the golden standard of Bitcoin, and typical smart contract governance, is that the end-users no longer have any power to choose which "smart contract fork" they prefer. Using the original smart contract and adding some value to it, they are at the mercy of the application governors.

Since the TEN protocol is anchored in Ethereum as a smart contract, it cannot rely on TEN end-users to hold the ultimate power.
The next best thing is to be very explicit about all the system's controls and achieve separation of decision-making (which can be devolved to token-holders and articulated in a governance specification as proposals) from execution (which relies on individuals pushing buttons).

## TEN Controls
Building on the above, the following controls are exercised within TEN.

###  1. The TEE Attestation Constraints.
The _Attestation Constraints_ (AC) control which software is allowed to run inside the TEE and can process the user transactions and create the rollups. A group of independent, reputable, and competent security auditors has to analyse the code and approve it by signing it carefully. The constraints contain the keys of the _approved auditors_.

The parties who have the power to set the AC and thus appoint auditors ultimately control the software.

This concern is not entirely different from the smart contracts security auditors, except that typically users decide which auditors they trust by using or not using those contracts.

###  2. Administration Of Ethereum Management Contracts.
Like most other Ethereum applications, these contracts will have upgradeable parts to cater for bugs and new features. Whatever is upgradeable means that the _administrators_ have full control over those aspects.
1. Bridge logic
2. Rollup logic
3. Attestation logic

In the example above, the auditors are a fixed list. However, that might not be practical, as companies might appear or disappear. The list of approved auditors has to be managed by a proposal and vote process by the community without any requirement for central intervention. Going a level deeper, the code that manages this process might need to be upgradeable, so someone ends up controlling it.

###  3. Creating Rollups
Another power, equivalent to the L1 stakers or miners, is held by TEN Aggregators. They run attested software and hardware and have paid a stake.

They have the power to append to the L2 ledger, but they do not have the power to choose competing software and thus create forks.

###  4. Canonical Rollup Chain.
In a typical L1, the canonical chain is ultimately decided by its users from one of the competing forks because the ledger is ultimately coupled to the value of the coin.

In TEN, the Aggregators have to run attested software, which constraints their free will unless they can hack the TEE technology.

According to the rules implemented, a valid TEE does not sign a rollup building on top of a chain that is not canonical, so any hack is immediately visible.

Additional complexity involves the withdrawal process, which depends on assured finality on the canonical chain.

###  5. Slashing The Stake Of Misbehaving Parties.
Aggregators that hack an enclave and attempt to break the ledger's integrity are discovered by the protocol and are punished by slashing to disincentivise such behaviour further.

Slashing is an implicit process carried out by the Management Contract based on predefined rules. However, ultimately it is itself controlled by the code governance.

###  6. Expected Monthly Operational Cost For Nodes
TEN has a fee structure that delivers a predictable income for node operators and a predictable fee for users. In order to derive a fee that sufficiently compensates nodes, a value that represents the monthly operational cost for each node must be set.
This variable also has the power to increase or decrease demand for running a node helping ensure a balance between decentralisation and end-user cost. 