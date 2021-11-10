## Threat Model
Obscuro is different from traditional blockchains because data is stored and processed privately in trusted execution environments, which brings a new set of threats.

The main threat to any ledger technology is data corruption. It could take the form of stealing assets, double spending assets, or, more generally, adding illegal entries.
Leading blockchains solve this problem by implementing a _Byzantine Fault Tolerant_ (BFT) consensus between independent parties and creating incentives to ensure that anyone who breaks the rules will not be rewarded or will be penalized. The most extreme attack is a 51% attack, where the attacker somehow gains the majority and can rewrite the history. This attack manifests as replacing an existing valid transaction with a valid competing transaction. If the attacker tried to _physically_ corrupt the ledger, everyone would ignore the invalid block. All that this powerful attacker can do is _logical_ corruption. The best defense against this attack is to ensure that multiple independent powerful actors have no incentive to collude.

POBI delegates this threat to the underlying L1 blockchain - Ethereum.

TEE technology, coupled with the goals of preserving privacy and preventing MEV, adds additional threats to Obscuro. The protocol is considers possible hacks on the TEE technology and reverts to the behavior of a typical blockchain if they happen. Also, the protocol ensures that an attacker has nothing to gain and is slashed if they attempt to corrupt the ledger.
This deterrent, combined with the technical difficulty and the high cost of attacking hardware security, will ensure the correct functioning of the protocol.

### Threats to TEE Technology
It is assumed that attackers can run an aggregator on a computer with a CPU they control, and then receive the secret key and the entire ledger, and then run any possible attack on it, including those on the physical CPU.

Assuming that such attacks are successful, the attacker can limit themselves to read-level access or try to corrupt the ledger using a write-level attack.

### Read Level Attacks
There is a spectrum of severity. The least severe is a side-channel where the attacker can find some information about a specific transaction. The most severe is when the attacker can extract the encryption key and can read all transactions.

If this attacker is discrete, the information leak can continue until a software patch is published or until new hardware that removes this attack is released.

This threat is specific to Obscuro. If the attack is successful, the protocol reverts to the behavior of a typical public blockchain where all transactions are public, and MEV is possible.

### Write Level Attacks
There are a few variants of this attack.

The most severe is when the attacker impersonates a TEE and signs a rollup containing illegal transactions. If there is no withdrawal attempt in the rollup, this attack is equivalent to an L1 node publishing an invalid block. All the honest TEEs will ignore it. Even in this case, the protocol reverts to the behavior of a typical blockchain.

There is one case that needs special consideration. When the attacker impersonating an enclave attempts to withdraw funds from the Bridge contract based on invalid transactions. This is where the L1 protocol meets the L2 protocol, and the Bridge contract has to decide the validity of the request. The solution is described in detail in the POBI protocol.

### Colluding Write Level Attacks
This is an extreme attack on this protocol, where aggregators find a way to break the TEE and are colluding to steal all funds.

The defense is to have a reasonable number of active verifiers. These will detect if there is a malicious head rollup and no other valid fork is being aggregated.

Any one of them will be able to become an aggregator if the security of the L1 is uncompromised.  They will have to pay the stake, and publish a correct block. This valid fork will disable withdraws, and will trigger a governance event which will determine the truth.

### Invalid Rollup Attacks
Sequencers may publish invalid or empty rollups, but the management contract will only accept aggregators that can prove their TEE attestation, and only rollups signed by the TEE key of valid aggregator. Unless the TEE itself is corrupted, it is impossible to publish invalid rollups.

A sequencer can publish empty rollups, but that would not do much harm if there are multiple aggregators. It will just slow down the network.