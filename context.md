# Context
As well as preserving the confidentiality of user data, the other main goals of this protocol are to be fully permissionless, decentralized and a generic smart-contract execution engine compatible to the greatest extent with the EVM.

A permissionless and decentralised layer 2 network needs a consensus protocol designed for the requirements of such an environment. In this section we enumerate the key such requirements and how Conclave meets them.

## Challenges
Relying on hardware-based TEEs for applications where significant value depends on the security of the hardware poses several challenges. A system designed to manage value should not allow an attacker capable of compromising secure hardware to take ownership of the value under any circumstances. In other words, the ledger's integrity should not depend on TEEs being 100% hack-proof. Obscuro uses the security of Ethereum combined with game theory to detect and correct eventual TEE hacks.

A system where everything is encrypted all the time is not usable. There must be a way for users to query their data or prove it to third parties. Additionally, an existing application contract which reveals internal state (such as the balanceOf(address) function of the ERC-20 standard used to look up anyone's holding) need to be considered carefully; since while Obscuro would prevent the state of the contract being visible, the functions might not.

Another critical challenge for this protocol is the prevention of MEV. Because user transactions and execution are not visible to Obscuro nodes, one might naively assume that this problem is solved. Unfortunately, that is not strictly true since aggregators might gain useful information through side-channels and use that to extract value. For example, an aggregator might own some accounts and submit transactions to them in key moments and then query for results. Obscuro introduces some novel techniques to prevent aggregators from performing replay-attacks which can generally be used for side-channels.

A privacy-preserving platform should consider illegal usage and design to prevent it. An important insight is that the value of confidentiality decays over time, to the point where transactions may just be of historical interest. For many transactions involving value, it is critical that they are not public when processed and cannot be front-run, but for others, they are price-sensitive for a longer period. Obscuro uses this insight and implements a policy for delayed transaction revelation. The knowledge that transactions will become public in the future is a deterrent for users to engage in criminal behavior because law-enforcement agencies will eventually catch up. [Alternative](./appendix.md#alternative-revelation-options) options have been considered.

One important challenge of such a system is making sure that some catastrophic event cannot leave all the value locked.

High transaction fees is one of the main barriers of entry for Ethereum. Obscuro addresses this using a novel approach to calculate fees based on the actual costs of running nodes.