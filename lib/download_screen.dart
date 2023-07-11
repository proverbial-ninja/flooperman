import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flooperman/Loop.dart';
import 'package:flooperman/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io' as io;

import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<Loop> looplist = [];
  bool _isloaded = false;
  @override
  initState() {
    // TODO: implement initState
    fetchFiles();
    super.initState();
  }

  Future<void> fetchFiles() async {
    var path = GetStorage().read("download_path");
    List<Loop> _list = [];
    Iterable<io.FileSystemEntity> files = io.Directory("${path}/")
        .listSync()
        .where((element) => element.path.endsWith("mp3"));

    for (var file in files) {
      print("file ");

      final f = new File(file.path);

      TagProcessor tp = TagProcessor();
      var _ok = await tp.getTagsFromByteArray(f.readAsBytes());

      var title = (_ok[1].tags.entries.last.value);
      var mp3_url = (Utility().getTextBetweenStrings(
              _ok[1].tags.entries.first.value.toString(), " body: ", "}")) ??
          "n/a";
      _list.add(Loop(title: title, mp3Url: mp3_url, fileName: f.path));
    }

    setState(() {
      looplist = _list;
      _isloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: _isloaded
          ? ListView.builder(
              itemBuilder: (context, index) {
                return DragItemWidget(
                  dragItemProvider: (request) {
                    final item = DragItem(
                      // This data is only accessible when dropping within same
                      // application. (optional)
                      localData: {'x': 3, 'y': 4},
                    );
                    // Add data for this item that other applications can read
                    // on drop. (optional)
                    item.add(
                        Formats.fileUri(Uri.file(looplist[index].fileName)));

                    return item;
                  },
                  allowedOperations: () => [DropOperation.copy],
                  child: DraggableWidget(
                    child: Card(
                      child: ListTile(
                        title: Text(looplist[index].title),
                        subtitle: Text(looplist[index].fileName),
                      ),
                    ),
                  ),
                );
              },
              itemCount: looplist.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
