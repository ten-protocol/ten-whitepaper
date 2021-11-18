# Obscuro
**Confidential Smart Contracts for Ethereum**

> /obˈskuː.roː/
> 1. (Latin) To conceal, hide;
> 2. A spell used to conjure a blindfold over the eyes of the target.

V0.4, November 2021 
_Note: This document is under development, so please check for updates._

James Carlyle, Tudor Malene, Cais Manai, Roger Willis; with significant additional [contributors](./appendix#contributors).
# Abstract
We present Obscuro, a decentralized Ethereum Layer 2 Rollup protocol designed to achieve data confidentiality and prevent [Maximal extractable value (MEV)](https://ethereum.org/en/developers/docs/mev/) by leveraging hardware-based [_Trusted Execution Environments_ (TEE)](https://en.wikipedia.org/wiki/Trusted_execution_environment).

The design focuses on preserving privacy for the limited period when it matters most, which removes the need for a privacy technique that is robust against all adversaries in perpetuity.
A significant aspect of the design is that the protocol falls back to the behavior of a public blockchain that preserves the ledger's integrity even if the TEE technology is compromised, thus not relying on the hardware manufacturer as a single root of trust.

Existing [rollup-based L2 offerings](https://ethereum.org/en/developers/docs/scaling/layer-2-rollups/) fall into two categories:
- 'Optimistic' rollups, designed for architectural simplicity and to be general-purpose platforms, rely on economic incentives to eliminate fraud, but at the cost of long lock-up periods and the risk of extraction of value by aggregators and others with the ability to front-run (MEV).
- 'Zero-Knowledge' rollups utilize advanced cryptography to eliminate the risk of fraud and the long lock-up periods, but at the cost of additional complexity, high computation costs, and not offering general-purpose smart contracts.

Obscuro sits in what we believe will be a sweet spot between them. The use of [Confidential Computing techniques](https://www.intel.co.uk/content/www/uk/en/security/confidential-computing.html) coupled with economic incentives allows Obscuro to retain the performance and programming model simplicity of Optimistic rollups, and on top of that attain confidentiality, short lock-up periods, and remove MEV.

Although they have many advantages, the security guarantees of TEEs are conceptually weaker than the mathematics behind zero-knowledge proofs. On the other hand, TEE security is a well-researched and understood question, whereas ZK cryptography is a highly complex and specialized area that is yet to be understood entirely. Obscuro's design assumes that a sufficiently determined and resourced actor can break TEE technology and thus implements a mechanism conceptually similar to Optimistic Rollups to preserve integrity at the cost of losing confidentiality.

Optimistic L2s feature a challenge mechanism that resolves with the execution of the L2 transactions on the Layer 1 blockchain (L1). Validity proving is an area of research, with solutions like [Arbitrum](https://developer.offchainlabs.com/docs/inside_arbitrum) proposing more efficient mechanisms.

L1s, on the other hand, do not have this problem because valid miners or stakers ignore invalid blocks and only build the blockchain on top of the most recent correct block.
Obscuro applies the same principle to L2 and introduces a new decentralized consensus protocol which forms the basis for an incentive scheme that removes the need for a specialized challenge mechanism.
As long as at least a single Obscuro node with an uncompromised TEE is active, the valid fork will continue to grow and include user transactions, thus being a de-facto challenge.
A brief summary is that Ethereum smart contract backing the rollups will detect forks in the rollup-chain and will pause withdrawals or any other side-effects until there is a single active fork.
_Note that short-living forks might not represent malicious behaviors as they can also originate from honest delays in the protocol._
An attacker who spent resources to compromise the TEE cannot reap any benefits until she can execute a withdrawal to a controlled wallet, and withdrawals cannot happen as long as valid TEEs keep publishing rollups. Even more, the attacker has to continuously spend Ethereum gas to publish many rollups without any immediate or potential benefit. The only effect of this attack is a denial of service on the withdrawal functionality, but the L2 ledger will continue to evolve. The high cost and the impossibility to withdraw any stolen funds acts as a potent deterrent.

The only possible outcome of such an extreme scenario is a software or hardware upgrade to fix the hack, which will result in the immediate halt of the attack, and resuming withdrawals. If such a fix is not immediately available, the valid TEEs will reveal the encryption keys and the network will degrade to a typical L2. 