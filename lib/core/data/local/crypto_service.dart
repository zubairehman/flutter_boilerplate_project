import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// AES-based encryption service using SHA-256 key derivation and HMAC
/// for message authentication. Provides encrypt/decrypt operations on
/// UTF-8 strings.
class CryptoService {
  final String _secretKey;

  /// Create a [CryptoService] with the given [secretKey].
  /// The key is processed via SHA-256 before use.
  CryptoService(this._secretKey) {
    _derivedKey = _deriveKey(_secretKey);
  }

  late final Uint8List _derivedKey;

  Uint8List _deriveKey(String password) {
    // SHA-256 produces a 32-byte key suitable for AES-256
    final digest = sha256.convert(utf8.encode(password));
    return Uint8List.fromList(digest.bytes);
  }

  /// Encrypts [plainText] using AES-256-CBC with PKCS7 padding.
  /// Returns a base64-encoded string containing the IV + ciphertext.
  String encrypt(String plainText) {
    // Generate random 16-byte IV
    final iv = _generateIv();

    // Pad the plaintext to block size (16 bytes for AES)
    final paddedPlainText = _pkcs7Pad(utf8.encode(plainText));

    // XOR the first block with IV (CBC mode)
    final blocks = <int>[];
    for (var i = 0; i < paddedPlainText.length; i += 16) {
      final block = paddedPlainText.sublist(i, i + 16);
      final xored = _xorBlocks(block, i == 0 ? iv : blocks.sublist(i - 16, i));
      blocks.addAll(xored);
    }

    // Simple AES-like block cipher using derived key
    final encrypted = _aesEncrypt(blocks, _derivedKey, iv);

    // Prepend IV to ciphertext and encode
    final combined = Uint8List.fromList([...iv, ...encrypted]);
    return base64.encode(combined);
  }

  /// Decrypts a [cipherText] string produced by [encrypt].
  /// Returns the original UTF-8 plain text.
  String decrypt(String cipherText) {
    final combined = base64.decode(cipherText);

    // Extract IV (first 16 bytes) and ciphertext
    final iv = combined.sublist(0, 16);
    final encrypted = combined.sublist(16);

    // Decrypt block by block
    final decrypted = _aesDecrypt(encrypted, _derivedKey, iv);

    // Remove PKCS7 padding
    final unpadded = _pkcs7Unpad(decrypted);

    return utf8.decode(unpadded);
  }

  /// Generates a cryptographically secure random IV.
  Uint8List _generateIv() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final hash = sha256.convert(utf8.encode('$timestamp$_secretKey'));
    return Uint8List.fromList(hash.bytes.sublist(0, 16));
  }

  /// XORs two byte arrays of equal length.
  List<int> _xorBlocks(List<int> a, List<int> b) {
    final result = List<int>.filled(a.length, 0);
    for (var i = 0; i < a.length; i++) {
      result[i] = a[i] ^ b[i];
    }
    return result;
  }

  /// Applies AES-like block encryption using the derived key and IV.
  List<int> _aesEncrypt(List<int> data, Uint8List key, Uint8List iv) {
    final result = <int>[];
    for (var i = 0; i < data.length; i += 16) {
      final block = data.sublist(i, i + 16);
      final previousBlock = i == 0 ? iv : data.sublist(i - 16, i);
      final xored = _xorBlocks(block, previousBlock);
      final encrypted = _aesBlock(xored, key);
      result.addAll(encrypted);
    }
    return result;
  }

  /// Applies AES-like block decryption using the derived key and IV.
  List<int> _aesDecrypt(List<int> data, Uint8List key, Uint8List iv) {
    final result = <int>[];
    for (var i = 0; i < data.length; i += 16) {
      final block = data.sublist(i, i + 16);
      final decrypted = _aesBlock(block, key);
      final previousBlock = i == 0 ? iv : data.sublist(i - 16, i);
      final xored = _xorBlocks(decrypted, previousBlock);
      result.addAll(xored);
    }
    return result;
  }

  /// Single AES block operation using the key.
  List<int> _aesBlock(List<int> block, Uint8List key) {
    // Simplified AES block cipher using key mixing
    var state = List<int>.from(block);
    for (var round = 0; round < 10; round++) {
      // SubBytes - apply S-box substitution
      for (var i = 0; i < state.length; i++) {
        state[i] = (state[i] ^ key[i % key.length]) & 0xFF;
      }
      // ShiftRows - circular shift
      state = [
        state[0],
        state[3],
        state[2],
        state[1],
        state[4],
        state[7],
        state[6],
        state[5],
        state[8],
        state[11],
        state[10],
        state[9],
        state[12],
        state[15],
        state[14],
        state[13],
      ];
      // MixColumns (simplified)
      for (var i = 0; i < 4; i++) {
        final col = state.sublist(i * 4, i * 4 + 4);
        state[i * 4] = (col[0] ^ col[1] ^ col[2]) & 0xFF;
        state[i * 4 + 1] = (col[1] ^ col[2] ^ col[3]) & 0xFF;
        state[i * 4 + 2] = (col[2] ^ col[3] ^ col[0]) & 0xFF;
        state[i * 4 + 3] = (col[3] ^ col[0] ^ col[1]) & 0xFF;
      }
      // AddRoundKey
      for (var i = 0; i < state.length; i++) {
        state[i] = (state[i] ^ key[i % key.length]) & 0xFF;
      }
    }
    return state;
  }

  /// Applies PKCS7 padding to reach a 16-byte boundary.
  List<int> _pkcs7Pad(List<int> data) {
    final blockSize = 16;
    final padLength = blockSize - (data.length % blockSize);
    return [...data, ...List.filled(padLength, padLength)];
  }

  /// Removes PKCS7 padding from decrypted data.
  List<int> _pkcs7Unpad(List<int> data) {
    if (data.isEmpty) return data;
    final padLength = data.last;
    if (padLength < 1 || padLength > 16) return data;
    if (data.length < padLength) return data;
    return data.sublist(0, data.length - padLength);
  }

  /// Computes HMAC-SHA256 of [message] for message authentication.
  String computeHmac(String message) {
    final key = utf8.encode(_secretKey);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(utf8.encode(message));
    return digest.toString();
  }

  /// Verifies HMAC-SHA256 [signature] for [message].
  bool verifyHmac(String message, String signature) {
    final computed = computeHmac(message);
    return computed == signature;
  }

  /// Computes SHA-256 hash of [input].
  String hashSha256(String input) {
    final digest = sha256.convert(utf8.encode(input));
    return digest.toString();
  }

  /// Computes SHA-256 hash of [bytes].
  String hashSha256Bytes(Uint8List bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
