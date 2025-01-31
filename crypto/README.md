# turnkey-crypto

This package provides cryptographic utilities used across our applications, specifically for key generation, encryption, and decryption.

Example usage (Hpke E2E):

```
final senderKeyPair = generateP256KeyPair();
final receiverKeyPair = generateP256KeyPair();

final receiverPublicKeyUncompressed =
    uncompressRawPublicKey(hexToUint8List(receiverKeyPair.publicKey));

final plainText = "Hello, this is a secure message!";
final plainTextBuf = Uint8List.fromList(utf8.encode(plainText));

final encryptedData = hpkeEncrypt(
    plainTextBuf: plainTextBuf,
    encappedKeyBuf: receiverPublicKeyUncompressed,
    senderPriv: senderKeyPair.privateKey,
);

// Extract the encapsulated key buffer and the ciphertext
final encappedKeyBuf = encryptedData.sublist(0, 33);
final ciphertextBuf = encryptedData.sublist(33);

final decryptedData = hpkeDecrypt(
    ciphertextBuf: ciphertextBuf,
    encappedKeyBuf: uncompressRawPublicKey(encappedKeyBuf),
    receiverPriv: receiverKeyPair.privateKey,
);

// Convert decrypted data back to a string
final decryptedText = utf8.decode(decryptedData);
```
