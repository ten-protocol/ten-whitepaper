# Motivation
Public blockchain networks have experienced a period of strong growth in 2020-2021, with new use-cases for smart contracts encompassing the finance and art worlds. Decentralised Finance (DeFi) has seen enormous inflows of capital, with the top applications seeing the equivalent of $10 billion (summer 2021) of liquidity added, and this has helped push the overall capitalisation of cryptoassets above $2 trillion (summer 2021). Meanwhile, _Non-Fungible Tokens_ (NFTs) surged in value to $10 billion (autumn 2021).

Public blockchains rely on the entire network seeing all transactions in order to be able to validate them and secure the network. This makes them _transparency engines_. Unfortunately, this creates a front-running issue, known as _Maximal Extractable Value_ (MEV), where miners or stakers and block proposers may steal value by observing user transactions and then preempting them. For example, a miner or bot may observe a user's desire to buy an asset at market price with an automated market maker, insert their purchase ahead in the processing queue by paying a higher transaction fee, causing the price to go up for the user, and then sell their purchase at a higher price and extract a profit from the user.

By some estimates, front-running was valued at $1.4 billion annually in early 2021. This means users of public blockchain networks are not deriving the full economic benefits of the technology. In addition, the transparent nature of the technology makes them inappropriate for many commercial and personal use-cases, where the confidential nature of interactions and deals should be maintained.

TEN is a decentralised Ethereum Layer 2 Rollup protocol designed to address the above problems, introduce new use-cases, and unlock blockchain technology's full potential and economic advantages.

## Differentiators
* TEN leverages Ethereum, a public blockchain with the greatest adoption,  legitimacy, security, and liquidity, as a base layer to handle security and data availability and manage the inflow and outflow of value.
* TEN keeps all transactions and the internal state of application contracts encrypted and hidden, and so provides a credible solution to MEV.
* By providing an _Ethereum Virtual Machine_ (EVM) compatible VM, deploying existing contracts to TEN with minimal change may be possible.
* TEN is trustless and decentralised. It takes processing from the Ethereum Layer-1 (L1) and allows lower transaction costs similar to other Layer-2 (L2) networks.
* TEN leverages TEEs for privacy but not for integrity and is not affected by the limitations of hardware-based confidential computing.
* TEN guarantees quick finality by synchronising the publishing of rollups to the cadence of the L1 blocks. 
* TEN introduces a novel mechanism to allow application developers to balance the need for user data privacy (and MEV prevention) with the need to deter long-term illegal behaviour.
