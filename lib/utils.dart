import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

class Utility {
  var io;

  Future<File> downloadFile(String url, String fileName) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var file = new File('$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  Uri removeQueryParameters(Uri uri) {
    return uri.replace(queryParameters: {});
  }

  String? getTextBetweenStrings(
      String text, String startString, String endString) {
    // Get the index of the start string.
    int startIndex = text.indexOf(startString);

    // If the start string is not found, return null.
    if (startIndex == -1) {
      return null;
    }

    // Get the index of the end string.
    int endIndex = text.indexOf(endString, startIndex + startString.length);

    // If the end string is not found, return null.
    if (endIndex == -1) {
      return null;
    }

    // Get the text between the two strings.
    String substring =
        text.substring(startIndex + startString.length, endIndex);

    // Return the text.
    return substring;
  }

  Future<Uint8List> readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    late Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  Future<void> pickFolder() async {
    try {
      String? savePath = await FilePicker.platform.getDirectoryPath();

      if (savePath != null) {
        print(savePath);
        GetStorage().write('download_path', savePath);
      } else {
        // User canceled the folder selection
        print('Folder selection canceled');
      }
    } catch (e) {
      print(e);
    }
  }
}
