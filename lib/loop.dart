// ignore_for_file: file_names

import 'dart:ffi';

class Loop {
  late String title;
  late String author;
  late Float bpm;
  late LoopCategory category;
  late LoopGenre genre;
  late String fileName;
  late String mp3Url;
  var dataBin;

  Loop(
      {required this.title,
      required this.mp3Url,
      this.fileName = "/",
      this.dataBin = "no"});
}

class LoopCategory {
  late String categoryName;
  late String categoryId;

  Map<String, dynamic> get map {
    return {
      "categoryName": categoryName,
      "categoryId": categoryId,
    };
  }

  LoopCategory({required this.categoryId, required this.categoryName});
}

class LoopGenre {
  late String genreName;
  late String genreId;

  Map<String, dynamic> get map {
    return {
      "genreName": genreName,
      "genreId": genreId,
    };
  }

  LoopGenre({required this.genreId, required this.genreName});
}
