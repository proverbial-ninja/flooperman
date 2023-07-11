import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flooperman/Loop.dart';
import 'package:flooperman/download_screen.dart';
import 'package:flooperman/looperman_parser.dart';
import 'package:flooperman/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/_http/_stub/_file_decoder_stub.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dart_tags/src/writers/id3v2.dart';
import 'package:just_audio/just_audio.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<Loop> loopList;
  var isLoaded = false;
  TextEditingController searchController = TextEditingController();
  late int _selectedIndex = -1;
  AudioPlayer player = AudioPlayer();
  late var _icon = Icons.waving_hand_rounded;

  // late List<Loop> loopList;
  @override
  void initState() {
    // TODO: implement initState
    // LoopermanParser().home();
    // Utility().pickFolder();
    _checkDownlaodsPath();
    _loadHome();
    player.playbackEventStream.listen((event) {
      print("xxxxx" + event.processingState.toString());

      switch (event.processingState) {
        case ProcessingState.loading:
          setState(() {
            _icon = Icons.hourglass_bottom_outlined;
          });

          break;
        case ProcessingState.ready:
          setState(() {
            _icon = Icons.pause_circle;
          });
          break;
        case ProcessingState.completed:
          setState(() {
            _icon = Icons.play_circle;
          });
          break;
        default:
      }
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Home'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Downloads'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Set Download Directory'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {},
              ),
            ],
          )),
          appBar: AppBar(
            title: Text('Flooperman 0.1'),
            backgroundColor: Colors.green[400],
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(DownloadScreen());
                  },
                  icon: Icon(Icons.download_for_offline_sharp)),
              IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                        title: "Search",
                        middleText: "Keyword",
                        textConfirm: "Search",
                        barrierDismissible: true,
                        onConfirm: () {
                          setState(() {
                            isLoaded = false;
                          });
                          _search(searchController.text);
                          Get.back();
                        },
                        content: Column(
                          children: [
                            TextField(
                              textInputAction: TextInputAction.go,
                              onSubmitted: (value) {
                                setState(() {
                                  isLoaded = false;
                                });
                                _search(searchController.text);
                                Get.back();
                              },
                              controller: searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ));
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          persistentFooterButtons: [
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(_icon),
                      // the method which is called
                      // when button is pressed
                      onPressed: () {
                        setState(
                          () {
                            if (player.playing) {
                              setState(() {
                                player.stop();
                              });
                            }
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
          body: isLoaded
              ? loopListview()
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  ListView loopListview() {
    return ListView.builder(
      itemCount: loopList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            onTap: () => _play(index),
            title: Text(loopList[index].title),
            subtitle: Text(loopList[index].mp3Url),
            leading: index == _selectedIndex
                ? const Icon(
                    Icons.pause_circle,
                    color: Colors.pink,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )
                : const Icon(
                    Icons.play_circle,
                    color: Colors.pink,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
            trailing: IconButton(
              icon: const Icon(
                Icons.download,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              onPressed: () {
                _downloadFile(index);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadHome() async {
    loopList = await LoopermanParser().home();
    setState(() {
      isLoaded = true;
    });

    print(loopList);
  }

  _downloadFile(index) async {
    var dl_url = loopList[index].mp3Url;
    var savedDir = GetStorage().read("download_path");
    var dl = DownloadManager();
    final tp = new TagProcessor();

    var url = loopList[index].mp3Url;
    // dl.addDownload(url, "$savedDir/${dl.getFileNameFromUrl(url)}");
    print("start");
    DownloadTask? task =
        await dl.addDownload(url, "$savedDir/${dl.getFileNameFromUrl(url)}");
    print("b4");
    var savepath = "$savedDir/${dl.getFileNameFromUrl(url)}";
    //var savepath =
    //  "/Volumes/Mac SSD/Users/kiki/Music/Downloads/looperman-l-2679281-0336237-lead-virtual-chords-slowkeith.mp3";
    await task?.whenDownloadComplete();
    Get.snackbar(
      "Downloads",
      "Download complete, Click here to see..",
      onTap: (snack) {
        Get.to(DownloadScreen());
      },
      backgroundColor: Colors.white,
      icon: const Icon(Icons.download_done_rounded),
    );
    print("done");
    var duration = const Duration(seconds: 5);

    print("slepts");
    print("$savedDir/${dl.getFileNameFromUrl(url)}");

// if you need encode or edit v2.4, just use `MetadataV2p4Body` instead of `MetadataV2p3Body`
// ignore: prefer_const_constructors

    final bytes = await Utility().readFileByte(savepath);
    final com1 = Comment('eng', 'dl_url', dl_url);
    final tag = Tag()
      ..tags = {
        'comment': com1,
        'bpm': '96',
        'title': loopList[index].title,
      }
      ..type = 'ID3'
      ..version = '2.4';
    final writer = ID3V2Writer();

    final blocks = await writer.write(bytes, tag);

    File(savepath).writeAsBytesSync(blocks);

    final f = new File(savepath);

    tp
        .getTagsFromByteArray(f.readAsBytes())
        .then((l) => l.forEach((f) => print(f)));
  }

  Future<void> _search(var keyword) async {
    var url = "https://www.looperman.com/loops?page=1&keys=$keyword&dir=d";
    var sloopList = await LoopermanParser().home(url: url);
    print(url);
    setState(() {
      isLoaded = false;
      loopList = sloopList;
      isLoaded = true;
    });

    print(loopList);
  }

  _play(int index) async {
    setState(() {
      _selectedIndex = index;
      if (player.playing) {
        player.stop();
      }
    });

    await player.setUrl(loopList[index].mp3Url);
    player.play();
  }

  Future<void> _checkDownlaodsPath() async {
    var _path = GetStorage().read('download_path') ?? "notSet";
    if (_path == "notSet") {
      Utility().pickFolder();
    }
  }
}
