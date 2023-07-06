import 'package:flooperman/Loop.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class LoopermanParser {
  Future<List<Loop>> home({url: "https://www.looperman.com/loops"}) async {
    final response = await http.get(Uri.parse(url));
    List<Loop> list = [];

    if (response.statusCode == 200) {
      // Parse the HTML content
      final document = parser.parse(response.body);

      // Extract the loop elements
      final loopElements = document.querySelectorAll('.loop');

      // Process each loop element
      for (var loopElement in loopElements) {
        final loopUrl = loopElement.attributes['rel'] ?? '';
        final loopName = loopElement.querySelector('.player-title')?.text ?? '';
        final loopAuthor =
            loopElement.querySelector('.loop-author')?.text ?? '';

        list.add(Loop(title: loopName, mp3Url: loopUrl));
        // print('Loop Name: $loopName');
        // print('Loop URL: $loopUrl');
        // print('Loop Author: $loopAuthor');

        print('---');
      }
    } else {
      print('Failed to fetch the website. Status code: ${response.statusCode}');
    }
    return list;
  }
}
