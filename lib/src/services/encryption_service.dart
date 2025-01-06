import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final Key key;
  final IV iv;

  EncryptionService(String keyString, String ivString)
      : key = Key.fromUtf8(keyString),
        iv = IV.fromUtf8(ivString);

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64; // Retorna o texto criptografado em Base64
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key));
    final decrypted =
        encrypter.decrypt(Encrypted.from64(encryptedText), iv: iv);
    return decrypted; // Retorna o texto descriptografado
  }
}
