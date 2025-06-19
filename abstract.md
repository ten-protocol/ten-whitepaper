# TEN
**Confidential Smart Contracts for Ethereum**

> /TENː/
> 1. 天 (Japanese) Heaven; sky; the celestial;
> 2. **T**he **E**ncrypted **N**etwork.

V0.10.0, November 2021 
_Note: This document is under development, so please check for updates. Some diagrams will refer to the former name_

James Carlyle, Tudor Malene, Cais Manai, Neal Shah, Gavin Thomas, Roger Willis; with significant additional [contributors](./appendix#contributors).

# Abstract
We present TEN, a decentralised Ethereum Layer 2 Rollup protocol designed to achieve data confidentiality, computational privacy and prevent [Maximal Extractable Value (MEV)](https://ethereum.org/en/developers/docs/mev/) by leveraging hardware-based [Trusted Execution Environments (TEE)](https://en.wikipedia.org/wiki/Trusted_execution_environment).

The design of TEN ensures that hardware manufacturers do not have to be trusted for the safety of the ledger. If one manufacturer turns malicious or there is a breach in the TEE technology, the protocol falls back to the behaviour of a public blockchain that preserves the ledger's integrity but makes the transactions public.

The design also focuses on preserving privacy for the limited period when it matters most, which removes the need for a privacy technique that is robust against all adversaries in perpetuity.

TEN sits in what we believe is a sweet spot between the existing [rollup-based L2 offerings](https://ethereum.org/en/developers/docs/scaling/layer-2-rollups/) Optimistic and ZK Rollups. The use of [confidential computing techniques](https://www.intel.co.uk/content/www/uk/en/security/confidential-computing.html) coupled with economic incentives allows TEN to retain the performance and programming model simplicity of Optimistic rollups, and on top of that attain confidentiality, short withdrawal periods, and address MEV.
