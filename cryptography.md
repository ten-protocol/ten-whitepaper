## Cryptography

The first enclave (or a special key generation enclave), generates a 256bit master seed inside the encrypted memory space. It encrypts this seed with the EK and sends it to the management contract to be stored there.
Subsequent enclaves, after proving their attestation will receive that secret encrypted with their key. The medium over which they receive the key is the management contract, to ensure maximum data availability.

This master entropy will be used by each enclave to deterministically generate additional keys:

1. A private/public key pair which will be used as the identity of the network. The public key will be published to L1 and used by clients to encrypt the signed transactions. This will be referred as: _Obscuro_Public_Key_
2. A set of symmetric key used by the enclaves to encrypt the transactions that will be stored on the L1 blockchain.

When submitting a rollup, each enclave will sign it with the key found in their attestation (the AK).

### Symmetric Key Revealing
One of the explicit design goals is to help application developers achieve their privacy requirements, while giving them the tooling to dis-incentivise users from using the application for illegal behaviour such as money-laundering.

When deploying a contract to Obscuro, the developer has to choose one of the predefined revealing options.

For example:
* XS - 12 seconds ( 1 rollup)
* S - 1 hour (3600/12 rollups)
* M - 1 day (24 * 3600 /12 rollups)
* L - 1 month
* XL - 1 year

One of these options will be chosen by default for applications that don't explicitly specify one.

Each predefined period will have to reveal transactions in a different cycle. The protocol will deterministically derive a symmetric encryption key from the master seed, the id of the reveal option, and the running counter for that option. All enclaves in possession of the master secret will be able to calculate the same encryption key.

Each interval for each reveal option will thus have a dedicated key _EncryptionKey(Reveal_option, Interval)_.

Signed user transactions are submitted to the network encrypted with the _Obscuro_Public_Key_. Inside the TEE, they are decrypted with the private key, and executed. When the rollup is generated, all transactions corresponding to a single option are bundled together, compressed, and encrypted with the symmetric _EncryptionKey(Reveal_option, Interval)_.

The transaction blob is formed by concatenating all the intervals without any delimiter.
Separately from the blob, a data structure is created containing the position of each individual option. This map is encrypted with a special key which is not revealed.

After enough rollups have been added, any node operator can request from the TEE the encryption key and the position of the transactions they are entitled to view.

## Shared Secret
A CPU manufacturer provisions every TEE with one or multiple keys, the EK. These keys are used for digitally signing messages and identifying a TEE. They are also used for encrypting data that only one hardware TEE can decrypt. To achieve the goals of a collaborative network like Obscuro, all the TEEs have to work on the same set of transactions, which means they must decrypt them.

Obscuro achieves this by implementing a mechanism for attested TEEs to share 256 bits of entropy called the _shared secret_ (SS) or _master seed_.  This master seed is generated inside the Genesis enclave. The Genesis enclave propagates the master seed to the other attested nodes by encrypting it with specific TEE keys.

The TEEs use the shared secret to generate further asymmetric and symmetric keys used by users to encrypt transactions and by the enclaves themselves to encrypt the content of the rollups.

Note that high available replication of the shared secret is fundamental for the good functioning of Obscuro. There are multiple incentives built into the protocol to ensure this.


[comment]: <> ([TODO - add more details and some diagrams.])

[comment]: <> ([TODO - diagram1: Interaction diagram ])

[comment]: <> ([TODO - diagram2: Structure of a block ])
