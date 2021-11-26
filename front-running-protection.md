## Front-Running Protection
A TEE that emits events and responds to balance enquires becomes vulnerable to front-running attacks. An Aggregator could in theory execute a transaction from an account they control, then execute a user transaction, then execute another transaction from a controlled account, and be able to learn something.

This is much more complicated and expensive than traditional public front-running and MEV, but it does not solve the problem completely.

A slight delay is introduced to make this attack impractical for the Aggregators, but preserve the same user experience.  The TEE will emit events and respond to balance requests only when it received proof that a rollup was included in the L1 rollup contract. That proof is easy to obtain, and it will prevent an Aggregator from probing while creating a rollup.

An Aggregator wishing to attack this scheme would have to quickly publish valid Ethereum blocks while executing user transactions, which is highly impractical.