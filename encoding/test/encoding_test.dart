import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:turnkey_encoding/src/encoding.dart';

void main() {
  group("uint8ArrayToHexString", () {
    test("Convert Uint8List to Hex String", () {
      final uint8Array = Uint8List.fromList([
        82,
        52,
        208,
        143,
        250,
        44,
        129,
        95,
        48,
        151,
        184,
        186,
        132,
        138,
        40,
        23,
        46,
        133,
        190,
        199,
        136,
        134,
        232,
        226,
        1,
        175,
        204,
        177,
        102,
        252,
        84,
        193
      ]);
      const expectedHexString =
          "5234d08ffa2c815f3097b8ba848a28172e85bec78886e8e201afccb166fc54c1";
      expect(uint8ArrayToHexString(uint8Array), equals(expectedHexString));
    });
  });

  group("uint8ArrayFromHexString", () {
    test("Convert Hex String to Uint8List", () {
      const hexString =
          "5234d08dfa2c815f3097b8ba848a28172e85bec78886e8e201afccb166fc54c1";
      final expectedUint8Array = Uint8List.fromList([
        82,
        52,
        208,
        141,
        250,
        44,
        129,
        95,
        48,
        151,
        184,
        186,
        132,
        138,
        40,
        23,
        46,
        133,
        190,
        199,
        136,
        134,
        232,
        226,
        1,
        175,
        204,
        177,
        102,
        252,
        84,
        193
      ]);
      expect(uint8ArrayFromHexString(hexString), equals(expectedUint8Array));
    });

    test("Empty string throws", () {
      expect(() => uint8ArrayFromHexString(""), throwsArgumentError);
    });

    test("Odd length string throws", () {
      expect(() => uint8ArrayFromHexString("123"), throwsArgumentError);
    });

    test("Invalid characters throw", () {
      expect(() => uint8ArrayFromHexString("oops"), throwsArgumentError);
    });

    test("Padded buffer", () {
      expect(
          uint8ArrayFromHexString("01", 2), equals(Uint8List.fromList([0, 1])));
    });

    test("Overflowing length throws", () {
      expect(() => uint8ArrayFromHexString("0100", 1), throwsArgumentError);
    });
  });

  group("normalizePadding", () {
    test("Add leading zeros to match the target length", () {
      final input = Uint8List.fromList([1, 2, 3]);
      final expected = Uint8List.fromList([0, 0, 1, 2, 3]);
      expect(normalizePadding(input, 5), equals(expected));
    });

    test("Trim leading zeros to match the target length", () {
      final input = Uint8List.fromList([0, 0, 1, 2, 3]);
      final expected = Uint8List.fromList([1, 2, 3]);
      expect(normalizePadding(input, 3), equals(expected));
    });

    test("Invalid number of leading zeros", () {
      final input = Uint8List.fromList([0, 0, 1, 2, 3]);
      expect(() => normalizePadding(input, 2), throwsArgumentError);
    });

    test("No change when target length matches input length", () {
      final input = Uint8List.fromList([1, 2, 3]);
      expect(normalizePadding(input, 3), equals(input));
    });
  });

  group("hexToAscii", () {
    test("Convert hex string to ASCII string", () {
      const hexString = "68656c6c6f";
      const expected = "hello";
      expect(hexToAscii(hexString), equals(expected));
    });

    test("Empty string results in empty ASCII string", () {
      const hexString = "";
      const expected = "";
      expect(hexToAscii(hexString), equals(expected));
    });

    test("Odd-length hex string throws an error", () {
      const hexString = "123";
      expect(() => hexToAscii(hexString), throwsArgumentError);
    });

    test("Hex string with special characters converts correctly", () {
      const hexString = "212223";
      const expected = "!\"#";
      expect(hexToAscii(hexString), equals(expected));
    });
  });

  group("base64StringToBase64UrlEncodedString", () {
    test('Converts base64 to base64 URL-safe format', () {
      final input = 'aGVsbG8rYmFzZTY0/==';
      final output = base64StringToBase64UrlEncodedString(input);
      expect(output, equals('aGVsbG8rYmFzZTY0_'));
    });
  });
}
