## Account-based State
Obscuro is an account based L2 decentralised ledger system similar to the L1 Ethereum blockchain, where state is calculated independently by each node based on the canonical list of transactions. One major difference is that the account balances can only be calculated inside the TEEs and are only revealed under certain conditions.
The model is not described further in this paper because it is the same as [Ethereum Accounts](https://ethereum.org/en/developers/docs/accounts/).

The transaction and smart contract formats are very similar to Ethereum.
Confidentiality introduces a few more low level differences around the mechanics.