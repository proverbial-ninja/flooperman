import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
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

  Future<void> pickFolder() async {
    try {
      String? savePath = await FilePicker.platform.getDirectoryPath();

      if (savePath != null) {
        print(savePath);
      } else {
        // User canceled the folder selection
        print('Folder selection canceled');
      }
    } catch (e) {
      print(e);
    }
  }
}
