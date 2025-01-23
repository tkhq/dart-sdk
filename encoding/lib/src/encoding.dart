import 'dart:typed_data';

/// Converts a `Uint8List` to a hexadecimal string.
///
/// - [input]: The input `Uint8List` to convert.
///
/// Returns a `String` representing the hexadecimal value of the byte array.
String uint8ArrayToHexString(Uint8List input) {
  return input.map((x) => x.toRadixString(16).padLeft(2, '0')).join('');
}

/// Converts a hexadecimal string to a `Uint8List`.
///
/// - [hexString]: The input hexadecimal string.
/// - [length]: (Optional) The desired length of the output array. If provided,
///   the resulting array is padded or trimmed to this length.
///
/// Throws an [ArgumentError] if the input string is invalid or if the hex value
/// cannot fit into the specified length.
///
/// Returns a `Uint8List` representation of the hexadecimal string.
Uint8List uint8ArrayFromHexString(String hexString, [int? length]) {
  final hexRegex = RegExp(r'^[0-9A-Fa-f]+$');

  if (hexString.isEmpty ||
      hexString.length % 2 != 0 ||
      !hexRegex.hasMatch(hexString)) {
    throw ArgumentError(
        'Cannot create Uint8List from invalid hex string: "$hexString"');
  }

  final buffer = Uint8List.fromList(
    List.generate(
      hexString.length ~/ 2,
      (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16),
    ),
  );

  if (length == null) {
    return buffer;
  }

  if (hexString.length ~/ 2 > length) {
    throw ArgumentError('Hex value cannot fit in a buffer of $length byte(s)');
  }

  // If a length is specified, pad the buffer
  final paddedBuffer = Uint8List(length);
  paddedBuffer.setRange(length - buffer.length, length, buffer);
  return paddedBuffer;
}

/// Normalizes the padding of a byte array with 0's to match a target length.
///
/// - [byteArray]: The byte array to pad or trim.
/// - [targetLength]: The desired length of the output array.
///
/// Adds leading 0's if the array is too short, or removes leading 0's if too long.
///
/// Throws an [ArgumentError] if the number of leading 0's in the array is invalid.
///
/// Returns a `Uint8List` of the normalized byte array.
Uint8List normalizePadding(Uint8List byteArray, int targetLength) {
  final paddingLength = targetLength - byteArray.length;

  // Add leading 0's to the array
  if (paddingLength > 0) {
    final padding = Uint8List(paddingLength);
    return Uint8List.fromList([...padding, ...byteArray]);
  }

  // Remove leading 0's from the array
  if (paddingLength < 0) {
    final expectedZeroCount = -paddingLength;
    int zeroCount = 0;

    for (int i = 0; i < expectedZeroCount && i < byteArray.length; i++) {
      if (byteArray[i] == 0) {
        zeroCount++;
      }
    }

    // Check if the number of leading zeros matches the expectation
    if (zeroCount != expectedZeroCount) {
      throw ArgumentError(
        'Invalid number of starting zeroes. Expected $expectedZeroCount, found $zeroCount.',
      );
    }
    return Uint8List.sublistView(
        byteArray, expectedZeroCount, expectedZeroCount + targetLength);
  }

  return byteArray;
}

/// Converts a hexadecimal string to an ASCII string.
///
/// - [hexString]: The input hexadecimal string to convert.
///
/// Throws an [ArgumentError] if the input string is not valid.
///
/// Returns the converted ASCII string.
String hexToAscii(String hexString) {
  if (hexString.length % 2 != 0) {
    throw ArgumentError('Invalid hex string: length must be even.');
  }

  final buffer = StringBuffer();
  for (int i = 0; i < hexString.length; i += 2) {
    final hexPair = hexString.substring(i, i + 2);
    final charCode = int.parse(hexPair, radix: 16);
    buffer.write(String.fromCharCode(charCode));
  }

  return buffer.toString();
}

/// Converts a base64-encoded string to a base64 URL-encoded string.
///
/// This function replaces `+` with `-`, `/` with `_`, and removes `=` characters
/// from the input string, converting it to a base64 URL-safe format.
///
/// - [input]: The input base64 string to convert.
///
/// Returns a `String` representing the base64 URL-encoded version of the input.
String base64StringToBase64UrlEncodedString(String input) {
  return input.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
}
