import 'dart:convert';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Items {
  Items();
  List items = [];
  int index = 0;

  @override
  toString() async {
    items = await getItems();
    index = await getIndex();
    return 'success';
  }

  getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('index') ?? 0;
  }

  resetIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    index = 0;
    prefs.setInt('index', 0);
  }

  incIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = prefs.getInt('index') ?? 0;
    index = i + 1;
    prefs.setInt('index', i + 1);
  }

  decIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = prefs.getInt('index') ?? 0;
    index = i - 1;
    prefs.setInt('index', i - 1);
  }

  addItem(item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var items = await getItems();
    items = [...items, item];
    prefs.setString('items', jsonEncode(items));
  }

  // removeItem(item) {
  //   items.remove(item);
  // }

  addSingleItem(item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    index = 0;
    items = [item];
    prefs.setString('items', jsonEncode(items));
    prefs.setInt('index', 0);
  }

  getItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List items = jsonDecode(prefs.getString('items')!);
    return items;
  }

  getItemsAudioSource() async {
    List items = await getItems();
    List<AudioSource> outp = [];
    for (var item in items) {
      outp = [
        ...outp,
        AudioSource.uri(
          Uri.parse(
            'https://mbr-productions.my.id/new-yt-music/video/${item['id']}',
          ),
          tag: MediaItem(
            id: '1',
            artist: item['artist'] == '' ? 'Unknown' : item['artist'],
            title: item['title'],
            artUri: Uri.parse(
              'https://img.youtube.com/vi/${item['id']}/mqdefault.jpg',
            ),
          ),
        )
      ];
    }
    return outp;
  }

  getItem(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List items = jsonDecode(prefs.getString('items')!);
    return items[index];
  }
}
