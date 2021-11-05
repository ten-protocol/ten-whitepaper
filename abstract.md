# Obscuro
**Confidential Smart Contracts for Ethereum**

> /obˈskuː.roː/
> 1. (Latin) To conceal, hide;
> 2. A spell used to conjure a blindfold over the eyes of the target.

V0.3, October 2021 _Note: This document is under development, so please check for updates._

James Carlyle, Tudor Malene, Cais Manai, Roger Willis; with significant additional [contributors](./appendix#contributors).

# Abstract
We present Obscuro, a decentralized Ethereum Layer 2 Rollup protocol designed to achieve data confidentiality and prevent MEV by leveraging hardware-based _Trusted Execution Environment_ (TEE).

The design focuses on preserving privacy for the limited period when it matters most, which removes the need for a privacy technique that is robust against all adversaries in perpetuity.
A significant aspect of the design is that the protocol falls back to the behavior of a public blockchain that preserves the ledger's integrity even when the TEE technology is compromised.
As a result, the limitations of standard TEE technologies can be accommodated.

Conceptually, Obscuro sits between Optimistic and ZK-rollups. Only rollups signed by an attested TEE are added to the ledger. The signature is the conceptual equivalent to a zero-knowledge proof, as it indicates that the rollup originated from the right environment.

Although they have many advantages, the security guarantees of TEEs are weaker than the mathematics behind zero-knowledge proofs. Obscuro addresses this limitation by using a blockchain-like data structure for storing rollups which allows multiple competing forks. This data structure was pioneered by Bitcoin and used later by Ethereum. The significant advantage of this approach is that it allows honest nodes to ignore eventual malicious rollups created by a compromised enclave, which is the exact mechanism by which Layer 1 protocols handle malicious behavior, coupled with the right incentives. As long as at least a single node with an uncompromised TEE is active, the valid fork will continue to grow and include user transactions.

The Ethereum smart contract backing the rollups will detect forks in the rollup-chain and will pause withdrawals until there is a single active fork. Note that short-living forks might not represent malicious behaviors as they can also originate from honest delays in the protocol. A potential attacker who spent resources to compromise the TEE cannot reap any benefits until she can execute a withdrawal to a controlled wallet. Withdrawals cannot happen as long as valid TEEs keep publishing rollups that will get rewarded eventually, which means the attacker has to continuously spend Ethereum gas to publish many rollups without any benefit. The only effect of this attack is a denial of service on the withdrawal functionality, but the L2 ledger will continue to evolve. The high cost and the impossibility to withdraw any stolen funds acts as a potent deterrent against this type of attack.

```diff
# Several ideas in this paper are novel and have been submitted in a defensive, provisional patent application only to establish prior art. Obscuro will be fully open-source, as befits decentralised and permissionless networks in particular.
```