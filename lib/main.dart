import 'dart:convert';
import 'package:encrypt/encrypt.dart' as e;
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class EncryptData {
//for AES Algorithms

  static e.Encrypted? encrypted;

  // ignore: prefer_typing_uninitialized_variables
  static var decrypted;

  static encryptAES(plainText) {
    final key = e.Key.fromUtf8('my 32 length key................');
    final iv = e.IV.fromLength(16);
    final encrypter = e.Encrypter(e.AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    if (kDebugMode) {
      print(encrypted!.base64);
    }
  }

  static decryptAES(plainText) {
    final key = e.Key.fromUtf8('my 32 length key................');
    final iv = e.IV.fromLength(16);
    final encrypter = e.Encrypter(e.AES(key));
    decrypted = encrypter.decrypt(encrypted!, iv: iv);
    if (kDebugMode) {
      print(decrypted);
    }
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String fileName = '';
  String text = '';
  String encrypt = '';
  String plainText = '';
  late Uint8List bytes;
  late List<int> encryptText;
  late Uint8List byteList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('File : '),
                  SizedBox(
                      height: 50,
                      width: 500,
                      child: Card(child: Center(child: Text(fileName)))),
                ],
              ),
              const SizedBox(height: 50),
              const Row(
                children: [
                  Text('Folder : '),
                  SizedBox(
                      height: 50,
                      width: 500,
                      child: Card(child: Center(child: Text('FolderName')))),
                ],
              ),
              const SizedBox(height: 50),
              const Row(
                children: [
                  Text('Password : '),
                  Expanded(child: TextField()),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          bytes = result!.files.first.bytes!;
                          text = String.fromCharCodes(bytes);
                          fileName = result.files.first.name;
                          setState(() {});
                        },
                        child: const Text('Add File')),
                    TextButton(
                        onPressed: () async {
                          await FileSaver.instance.saveFile(
                              bytes: byteList,
                              name: fileName,
                              mimeType: MimeType.text);
                        },
                        child: const Text('Select Folder')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            encrypt = EncryptData.encryptAES(text);
                          });
                          encryptText = utf8.encode(encrypt);
                          byteList = Uint8List.fromList(encryptText);
                          setState(() {});
                        },
                        child: const Text('Encryption')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            plainText = EncryptData.decrypted(encrypt);
                          });
                        },
                        child: const Text('Decryption')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
