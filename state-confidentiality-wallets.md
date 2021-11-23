## State Confidentiality and Transaction Submission

### State Confidentiality
The main goal of Obscuro is to protect user data. If smart contracts were completely isolated it would be fairly easy to define data access rules.

For example, for an individual (non-contract) account, the main rule could be formalised as: *"Only the account owner, or someone empowered by the owner, is allowed to query the balance of an account."*

Contract composition is more complex. DeFi enjoys massive success thanks to the ability of contracts to be combined in serendipitous ways not predicted by the contract creator.

E.g. Consider a flashloan where a user borrows 10 ETH from Aave, swaps them for 100 ABC coins on UniSwap, then swaps them for 500 DEF coins on SushiSwap, and then swaps them for 10.1 ETH on UniSwap, and then pays back the loan and makes a 0.1 ETH profit.

In this case, the flashloan contract needs to be able to query balances or to find out if it can loan a certain amount. It needs to also know the price for the ABC/BCD on a certain exchange. All this information which it needs access to, in order to perform its duties, could in theory be emitted directly or indirectly as an event to the caller of the contract. Or it could be written to the state on accounts controlled by the attacker.

In the absence of additional controls, Obscuro will allow a user to call a normal contract function confidentially, and receive the function response confidentially. If the contract is designed to allow the internal contract state to be returned, then the user will still gain visibility despite the contract state itself being restricted to TEEs. Creators of contracts deployed to Obscuro must be aware of the difference between _confidentiality of state_ and _transparency of state provided through functions_.

Obscuro will explore the following concepts:
* Each contract can whitelist contracts that can access different functions.
* Propagate access. If "Account.getBalance" can be invoked only by the owner, it means that any contract that invokes this has to originate from a message signed by the owner. This solution sounds appealing, but it needs more research to determine if this mechanism prevents important use cases.

Note that more research is needed to define a general purpose mechanism.

### Transaction Submission
Transactions created by the user wallet are encrypted with the shared public key. Only valid TEEs in possession of the private key are able to decrypt them, execute them, and see the resulted state. Still, end users who submitted a transaction must be able to receive the result.

A traditional wallet connected to a node on public blockchain is able to read any balance and display it to the user. To achieve such a similar user experience an Obscuro-enabled wallet needs to be able to submit signed requests to L2 aggregators or verifiers, and receive a response. The response needs to be encrypted with the user key and has to be a cryptographic proof linking the balance to a rollup.

Validity verification of such a proof can be done by first checking the TEE signature, then by checking that the rollup is on the canonical chain of both the L2 and the L1 chains.

The TEE virtual machine will publish events specified in contracts, unencrypted, similar to the EVM.