import 'package:flooperman/Loop.dart';
import 'package:flooperman/looperman_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

void main() {
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

  late int _selectedIndex = -1;
  AudioPlayer player = AudioPlayer();
  late var _icon = Icons.waving_hand_rounded;

  // late List<Loop> loopList;
  @override
  void initState() {
    // TODO: implement initState
    // LoopermanParser().home();
    // Utility().pickFolder();
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
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flooperman 0.1'),
            backgroundColor: Colors.green[400],
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
                ? Icon(
                    Icons.pause_circle,
                    color: Colors.pink,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )
                : Icon(
                    Icons.play_circle,
                    color: Colors.pink,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
            trailing: const Icon(
              Icons.download,
              color: Colors.pink,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
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
}
