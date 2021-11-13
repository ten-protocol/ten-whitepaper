## Threat Model

[TODO] - this section needs reviewing

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


### Sybil attacks
[TODO - this is from an email , and needs to be rewritten]

I think the reasoning around it is quite different from typical public blockchains.

Why would someone perform a Sybil attack on Obscuro?
They want to steal the funds locked in the L1 Bridge. (This is not a problem in typical L1 chains as there are no side effects there, but it is in L2s).
They’re mean and want to mess about with the L2 ledger. Basically to reorder a transaction – a double spend.

How would a Sybil attack look like?
Someone just sets up N CPUs with TEE, and pays the stake for each of them.
Someone hacks the TEE and is able to impersonate as many TEEs as they can pay stake for.

There’s a couple of factors that are not properly explained in the WP.
An unhacked TEE will not generate a rollup on top of a different rollup from everyone else. Which means that as long as there is a single unhacked enclave the “real canonical chain” will continue to grow.
Publishing a rollup to the main chain costs Ethereum gas. The attacker has to keep publishing rollups, otherwise the attack fails eventually. The virtuous TEEs will just keep doing their job and publish rollups knowing that they will get the rewards (probably the reward has to grow the longer the attack lasts, because they will have to pay the gas from their pocket).
As long as there are forks in the rollup-chain, withdrawals are suspended on all forks.


Now putting this all together:

If the attacker is not able to hack the TEE, they’re not able to deviate from the canonical chain (double spends) or to insert illegal transactions, as the software won’t let them. Happy days.

The attacker is able to hack the TEE. So they setup a large number of aggregators (limited only by the stake).
And the motivation is that they want to steal the funds from the bridge – the ultimate prise.

The attack is as follows:
Using a script they handcraft invalid rollups, and publish them (by paying gas). On the L1 this would show as 2 forks. One maintained by the attacker, one maintained by the rest who just ignore the invalid rollups and keep doing their job.
Withdrawals are stopped until one fork wins.
Realistically what will happen is that the governance of Obscuro will quickly come together, analyze what happened, and let Intel know about the obvious hack on the TEE. Based on those replies, and the attacker continuing to attack, there’s a couple of options:
Intel or the Obscuro team pull a fix out of the hat, and the Attestation Constraints are updated. Which means the attack will stop as the attacker will have to upgrade to an unhackable version. Happy days. The evil branch will die out and withdraws will be resumed.
The network enters the nuclear option. It is manually frozen on the right fork (by the governance board), the keys are revealed, and everyone can claim back their amounts on the L1 based on the proof generated in L2.

They go through all this trouble for a double spend.
The attack is as follows:
Using a script they handcraft valid rollups with a low nonce. That’s all great and they get the reward. To actually pull a double spend they need to be able to replace a rollup already published in a previous block. Which is impossible to do unless they pull a sybil attack on Ethereum itself.
Basically this security aspect is handled by the L1, which is good.
 

----
One idea to address this is to increase the stake requirements the more people join. If you think about it, it’s not that different from pow, where the more people start mining, the higher the difficulty, so to stay competitive you need a higher investment.
The question is how to increase it? Increase it only for new joiners? Ask existing aggregators to top up as well?
Intuitively (without doing any math), this should create the right dynamic. If someone is trying to take over by adding lots of sybils, the capital required for staking will increase and make it impractical. Back of the envelope, if the stake increases by 2% for every new aggregator, then the 100th will pay 7 times more. The 200th will pay 50 times more.
This is a double edge sword though, as it could also increase centralisation, as you price out someone who might want to be an aggregator..

Point ii) is super interesting as well.
My first thought was that it’s fine, since the rule we have in place now is that the reward is only paid out to an aggregator if the rollup is included in one of the next 2 blocks (full reward in the first block, only gas costs in the second block, nothing afterwards). But it might not be that easy.



Let’s say there was a malicious dominant player (controlling 2/3 of the aggregators) with the intent to stall the network. (That wouldn’t be the most rational thing to do, since they paid the stake in the Obscuro token, so they’re invested in the ecosystem, but who knows.)

This is how it would work with the current rules:
every 2 out of 3 rounds they would get the lowest nonce, so the other aggregators would not publish the rollup they produced.
But the winner wouldn’t publish either. So there would be no rollup in the next block.
Once that empty block is out, the other aggregators will rebuild a new rollup on top of the last published one including all new transactions since then and then seal it with a new nonce using the empty block.
Then they gossip, and if they have the lowest nonce from this batch they publish. According to rule 4 from above, they know they will receive the full reward because their rollup was created using a more recent l1 block. The bad actor could have a sybil with a lower nonce, and if they don’t gossip or publish it, it doesn’t exist. If they publish without gossiping they will just get 80% of the reward, so not very smart (rule 3).
