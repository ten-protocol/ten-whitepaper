# Challenges

As well as preserving the confidentiality of user data, the other main goals of this protocol are to be fully permissionless, decentralised and a generic smart-contract execution engine compatible to the greatest extent with the EVM.

In this section, we enumerate the key challenges we faced when designing the TEN protocol.

- Relying on hardware-based TEEs for applications where significant value depends on the security of the hardware poses several challenges. A system designed to manage value should not allow an attacker capable of compromising secure hardware to take ownership of the value under any circumstances. In other words, the ledger's integrity should not depend on TEEs being 100% hack-proof or the hardware manufacturer being 100% trustworthy. TEN uses the security of Ethereum combined with game theory to detect and correct eventual TEE hacks.


- A system where everything is encrypted all the time is not usable. There must be a way for users to query their data or prove it to third parties. Additionally, an existing application contract that reveals internal state (such as the balanceOf(address) function of the ERC-20 standard used to look up anyone's holding) need to be considered carefully; since while TEN would prevent the state of the contract from being visible, the functions might not.


- Another critical challenge for this protocol is the prevention of MEV. Because user transactions and execution are not visible to TEN nodes, one might naively assume that this problem is solved. Unfortunately, that is not strictly true since aggregators might gain useful information through side-channels and use that to extract value. For example, an aggregator might own some accounts and submit transactions to them in critical moments and then query for results. TEN addresses this by introducing delays in key moments to prevent aggregators from performing replay-attacks which can generally be used for side-channels.


- A privacy-preserving platform should consider illegal usage and design mechanisms to help application developers avoid and prevent it. An important insight in this direction is that the value of confidentiality decays over time, to the point where transactions may just be of historical interest. For many transactions involving value, it is critical that they are not public when processed and cannot be front-run, but for others, they are price-sensitive for a longer period. TEN uses this insight and implements a flexible policy for delayed transaction revelation. The knowledge that transactions become public in the future is a deterrent for users to engage in criminal behaviour because law-enforcement agencies will eventually catch up. [Alternative](./appendix#alternative-revelation-options) options have been considered.


- One crucial challenge of such a system is ensuring that some catastrophic event cannot leave all the value locked. The mechanism that prevents this is covered in the [Threat-Model analysis](./threat-model).


- High transaction fees are one of the main barriers to entry for Ethereum. TEN addresses this by introducing a novel approach to calculate fees based on the actual costs of the running nodes.
