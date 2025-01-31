import 'package:test/test.dart';
import 'package:turnkey_crypto/src/turnkey.dart';

void main() {
  group('decryptCredentialBundle Tests', () {
    const mockSenderPrivateKey =
        "67ee05fc3bdf4161bc70701c221d8d77180294cefcfcea64ba83c4d4c732fcb9";
    const mockPrivateKey =
        "20fa65df11f24833790ae283fc9a0c215eecbbc589549767977994dc69d05a56";
    const mockCredentialBundle =
        "w99a5xV6A75TfoAUkZn869fVyDYvgVsKrawMALZXmrauZd8hEv66EkPU1Z42CUaHESQjcA5bqd8dynTGBMLWB9ewtXWPEVbZvocB4Tw2K1vQVp7uwjf";

    test('decryptCredentialBundle successfully decrypts a valid bundle', () {

      final decryptedData = decryptCredentialBundle(
        credentialBundle: mockCredentialBundle,
        embeddedKey: mockPrivateKey,
      );

      expect(decryptedData, mockSenderPrivateKey);
    });

    test('decryptCredentialBundle throws an error for invalid bundle', () {
      const invalidBundle = "invalidBase58CheckData";

      expect(
        () => decryptCredentialBundle(
          credentialBundle: invalidBundle,
          embeddedKey: mockPrivateKey,
        ),
        throwsException,
      );
    });

    test('decryptCredentialBundle throws an error for incorrect private key',
        () {
      const incorrectPrivateKey =
          "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

      expect(
        () => decryptCredentialBundle(
          credentialBundle: mockCredentialBundle,
          embeddedKey: incorrectPrivateKey,
        ),
        throwsException,
      );
    });
  });

  group('decryptExportBundle Tests', () {
    test('decryptExportBundle successfully decrypts a valid bundle - mnemonic ',
        () async {
      const exportBundle = '''
      {
        "version": "v1.0.0",
        "data": "7b22656e6361707065645075626c6963223a2230343434313065633837653566653266666461313561313866613337376132316133633431633334373666383631333362343238306164373631303266343064356462326463353362343730303763636139336166666330613535316464353134333937643039373931636664393233306663613330343862313731663364363738222c2263697068657274657874223a22656662303538626633666634626534653232323330326266326636303738363062343237346232623031616339343536643362613638646135613235363236303030613839383262313465306261663061306465323966353434353461333739613362653664633364386339343938376131353638633764393566396663346239316265663232316165356562383432333361323833323131346431373962646664636631643066376164656231353766343131613439383430222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437227d",
        "dataSignature": "304502203a7dc258590a637e76f6be6ed1a2080eed5614175060b9073f5e36592bdaf610022100ab9955b603df6cf45408067f652da48551652451b91967bf37dd094d13a7bdd4",
        "enclaveQuorumPublic": "04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"
      }
    ''';
      const privateKey =
          'ffc6090f14bcf260e5dfe63f45412e60a477bb905956d7cc90195b71c2a544b3';

      const expectedMnemonic =
          'leaf lady until indicate praise final route toast cake minimum insect unknown';

      final result = await decryptExportBundle(
        exportBundle: exportBundle,
        embeddedKey: privateKey,
        organizationId: 'f9a31c64-d604-42e4-9bef-a773096afad7',
        keyFormat: 'HEXADECIMAL',
        returnMnemonic: true,
      );

      expect(result, expectedMnemonic);
    });
  });

  test(
      'decryptExportBundle successfully decrypts a valid bundle - non-mnemonic',
      () async {
    const exportBundle = '''
      {
        "version": "v1.0.0",
        "data": "7b22656e6361707065645075626c6963223a2230343434313065633837653566653266666461313561313866613337376132316133633431633334373666383631333362343238306164373631303266343064356462326463353362343730303763636139336166666330613535316464353134333937643039373931636664393233306663613330343862313731663364363738222c2263697068657274657874223a22656662303538626633666634626534653232323330326266326636303738363062343237346232623031616339343536643362613638646135613235363236303030613839383262313465306261663061306465323966353434353461333739613362653664633364386339343938376131353638633764393566396663346239316265663232316165356562383432333361323833323131346431373962646664636631643066376164656231353766343131613439383430222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437227d",
        "dataSignature": "304502203a7dc258590a637e76f6be6ed1a2080eed5614175060b9073f5e36592bdaf610022100ab9955b603df6cf45408067f652da48551652451b91967bf37dd094d13a7bdd4",
        "enclaveQuorumPublic": "04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"
      }
    ''';
    const privateKey =
        'ffc6090f14bcf260e5dfe63f45412e60a477bb905956d7cc90195b71c2a544b3';

    const expectedNonMnemonic =
        '6c656166206c61647920756e74696c20696e646963617465207072616973652066696e616c20726f75746520746f6173742063616b65206d696e696d756d20696e7365637420756e6b6e6f776e';

    final result = await decryptExportBundle(
      exportBundle: exportBundle,
      embeddedKey: privateKey,
      organizationId: 'f9a31c64-d604-42e4-9bef-a773096afad7',
      keyFormat: 'HEXADECIMAL',
      returnMnemonic: false,
    );

    expect(result, expectedNonMnemonic);
  });

  group('encryptWalletToBundle Tests', () {
    test('encryptWalletToBundle successfully encrypts a mnemonic wallet bundle',
        () async {
      const mnemonic =
          'leaf lady until indicate praise final route toast cake minimum insect unknown';
      const importBundle = '''
        {
          "version":"v1.0.0",
          "data":"7b227461726765745075626c6963223a2230343937363965366266636162333235303534356666633537353361396138393061663431653833366432613933333633353461303165623737346135616265616563393465656430663734396665303366393966646566663839643033386630643534366538636539323164383732373562376437396161383730656133393061222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437222c22757365724964223a2237643461383835642d343636382d343063342d386633352d333333303165313165376435227d",
          "dataSignature":"3045022100fefc56c6bf4142ff54ce085b8103e79c7ac571dad16a145e9c99ec6d081b97ff0220203bd0d0f6048cd139aa3eb79ccace5425c2f1347401b2c18c66b728f540f17e",
          "enclaveQuorumPublic":"04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"
        }
      ''';
      const userId = '7d4a885d-4668-40c4-8f35-33301e11e7d5';
      const organizationId = 'f9a31c64-d604-42e4-9bef-a773096afad7';

      await encryptWalletToBundle(
        mnemonic: mnemonic,
        importBundle: importBundle,
        userId: userId,
        organizationId: organizationId,
      );

      // Since the encryption is non-deterministic, we can't compare the result directly
      // To verify we would need to use the apiClient to import the wallet
    });
  });

  group('encryptPrivateKeyToBundle Tests', () {
    test('encryptPrivateKeyToBundle successfully encrypts a private key bundle',
        () async {
      const privateKey =
          '6fd4d81de4820d2f8f7b2df8aa63ebb4b042af5854313e1f3abae6b55eb1cf83';
      const importBundle = '''
      {"version":"v1.0.0","data":"7b227461726765745075626c6963223a2230343133613663626239646434643763653561303562363031313631643437643565353861303732386237353162613063363838333364356335383164623931616339303061633431626433616530383830636636306233353636306261353839373066356663393162353263373135636438313734386364633431333363656263222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437222c22757365724964223a2237643461383835642d343636382d343063342d386633352d333333303165313165376435227d","dataSignature":"30440220424e74b9b75ee7e0ea83ff71c5c33dfa113c6321447fb65322bfe154b06f97f6022030d98ab126ece21eb60bd19d4dd6670a802d5cc84e626949746a797b4ee23163","enclaveQuorumPublic":"04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"}
    ''';
      const userId = '7d4a885d-4668-40c4-8f35-33301e11e7d5';
      const organizationId = 'f9a31c64-d604-42e4-9bef-a773096afad7';

      await encryptPrivateKeyToBundle(
        privateKey: privateKey,
        keyFormat: 'HEXADECIMAL',
        importBundle: importBundle,
        userId: userId,
        organizationId: organizationId,
      );

      // Since the encryption is non-deterministic, we can't compare the result directly
      // To verify we would need to use the apiClient to import the wallet
    });
  });
}
