## Shared Secret
A CPU manufacturer provisions every TEE with one or multiple keys, the EK. These keys are used for digitally signing messages and identifying a TEE. They are also used for encrypting data that only one hardware TEE can decrypt. To achieve the goals of a collaborative network like Obscuro, all the TEEs have to work on the same set of transactions, which means they must decrypt them.

Obscuro achieves this by implementing a mechanism for attested TEEs to share 256 bits of entropy called the _shared secret_ (SS) or _master seed_.  This master seed is generated inside the first TEE to join a new network, which propagates it to the other attested nodes by encrypting it with specific TEE keys.

The TEEs use the shared secret to generate further asymmetric and symmetric keys used by users to encrypt transactions and by the enclaves themselves to encrypt the content of the rollups.

Note that high available replication of the shared secret is fundamental for the good functioning of Obscuro. There are multiple incentives built into the protocol to ensure this.

Read more about this in the detailed [Cryptography section](#cryptography).