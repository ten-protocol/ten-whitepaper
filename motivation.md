# Motivation
## Introduction
Public blockchain networks have experienced a period of strong growth in 2020-2021, with new use-cases for smart contracts encompassing the finance and art worlds. Decentralised Finance (DeFi) has seen enormous inflows of capital, with the top applications seeing the equivalent of $10 billion (summer 2021) of liquidity added, and this has helped push the overall capitalisation of cryptoassets above $2 trillion (summer 2021). Meanwhile, _Non-Fungible Tokens_ (NFTs) surged in value to $10 billion (autumn 2021).

Public blockchains rely on the entire network seeing all transactions in order to be able to validate them and secure the network. This makes them _transparency engines_. But it also makes them inappropriate for many commercial and personal use-cases, where the confidential nature of interactions and deals should be maintained. It also creates a front-running issue, known as _Maximum Extractable Value_ (MEV), where miners or stakers and block proposers may steal value by observing user transactions and then preempting them. For example, a miner or bot may observe a user's desire to buy an asset at market price with an automated market maker, insert their own purchase ahead in the processing queue by paying a higher transaction fee, cause the price to go up for the user, and then sell their own purchase at a higher price and extract a profit from the user. By some estimates, front-running was valued at $1.4 billion annually in early 2021.

## Differentiators
* Obscuro relies on Ethereum, a public blockchain with the greatest adoption,  legitimacy, security, and liquidity, as a base layer to handle security and data availability and manage the inflow and outflow of value.
* Obscuro keeps all transactions and the internal state of application contracts encrypted and hidden, and so may provide a credible solution to MEV.
* By providing an _Ethereum Virtual Machine_ (EVM) compatible VM, deploying existing contracts to Obscuro with minimal change may be possible.
* Obscuro is trustless and decentralized. It takes processing from the Ethereum Layer-1 (L1) and allows lower transaction costs similar to other Layer-2 (L2) networks.
* Obscuro acknowledges the limitations of hardware-based confidential computing and relies on TEE for privacy but not for integrity.
* Obscuro guarantees quick finality by synchronizing the publishing of rollups to the cadence of the L1 blocks. 
* Obscuro introduces a novel mechanism to allow application developers to balance the need for user data privacy (and MEV prevention) with the need to deter long-term illegal behavior.

## Use Cases
There are many, many use cases for applications deployed to the Obscuro network, but a recurring theme is protecting privacy in order to create fair markets.

### Sealed Bid Auction
In a sealed bid auction, bidders privately submit their one best offer, in writing and in a sealed envelope. The bids are opened privately by the auctioneer and seller who do not reveal the bids to any of the participants.

Keeping the bids private helps ensure that if all bids are too low for any of them to be accepted by the seller, the property will not become stigmatized by having a perceived low value in the marketplace. It also ensures that the auctioneer cannot collude and reveal a competing bid to another bidder privately, or front-run a bidder and out-bid them.

This type of auction requires Obscuro.

### Dark pools and OTC Trading 
A _dark pool_ is a privately organised exchange for trading securities where exposure can be hidden until after execution and reporting. This allows investors to trade without publicly revealing their intentions during the search for a buyer or seller as well as hiding any pricing data which could result in investors receiving poorer prices.

Dark pools on Obscuro would be very different to a typical DEX; it would be direct peer-to-peer trading with a layer of ‘dark’ price discovery added.

Prices for assets can be derived from order flow within the Obscuro enclaves, guaranteeing fair price discovery and leveraging oracles such as Chainlink to ensure prices are within a fair band. The eventual revelation is also important, as trades eventually have to be disseminated to all investors (a consolidated tape).

_Over-the-counter_ (OTC) trading is where bespoke products are tailored to specific client requirements. The most common usage of OTC is in financial derivatives where “OTC” means the opposite of “Exchange-traded”. 

They come in where there's a need for unique idiosyncratic terms for, as an example, an option, such as non-standard length of time, strike price, market conventions, or payoff structure and are negotiated between a buyer and issuer. Obscuro can guarantee privacy in both negotiating and structuring such products.   

Competing products already available, but these are not decentralised, and by definition, it's not possible to have a ‘dark’ pool in a decentralised manner without something like Obscuro.

### Fractional Non-Fungible Tokens (NFTs)
The idea is to allow NFTs to be tokenised to allow fractional ownership. The difficulty with fractional ownership in the NFT space is for the art piece to be valuable, there needs to be the ability bring all the pieces back together to allow the full piece to be sold to a buyer.

To allow this to happen, a reserve price needs to be set, where once hit, all the individual token holders are compensated and the NFT is sold as a whole piece. A few mechanisms are required for this to happen.

Token holders need to submit the reserve price that makes sense to them. This gets weighted by the amount of tokens they hold in relation to the total number. The reserve price is calculated and set. To be most effective, both of these require privacy. A hidden reserve price has the potential to attract larger bids.

Keeping the bids private helps ensure that if all bids are too low for any of them to be accepted by the sellers, the NFT will not become stigmatized by having a perceived low value in the marketplace.

### Retail Activity
Current smart contract activity undertaken by individuals can often be linked to them, either by data mining, or simple association of an Ethereum L1 address with a username registered on the Ethereum Name Service. Pioneers don't care about whether their NFT purchases are publicly visible, but the next wave of mass adoption and use of smart contracts by the wider public (such as a health insurance contract) will require privacy. Obscuro will help here.