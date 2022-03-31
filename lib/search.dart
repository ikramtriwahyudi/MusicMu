import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'component/items.dart';
import 'component/music_card.dart';
import 'component/searchbar.dart';

class Search extends StatefulWidget {
  Search({Key? key, this.nowPlaying, this.play, this.openPlayer, this.modal})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var nowPlaying;
  final play;
  final openPlayer;
  final modal;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List musics = [];
  getMusics(keyword) async {
    await http
        .get(
      Uri.parse(
        'https://mbr-productions.my.id/new-yt-music/search/$keyword',
      ),
    )
        .then((res) {
      musics = jsonDecode(res.body);
      // debugPrint(musics.toString());
      setState(() {});
    });
  }

  var items = Items();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SearchMusic(
            onComplete: (val) {
              getMusics(val);
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (var item in musics)
                  GestureDetector(
                    onTap: () async {
                      await items.addSingleItem(item);
                      await items.getItemsAudioSource().then((value) {
                        widget.play(value, 0);
                      });
                      widget.openPlayer();
                    },
                    child: MusicCard(item, widget.modal),
                  )
              ],
            ),
          ),
          items.items.isEmpty
              ? const SizedBox(height: 0)
              : const SizedBox(height: 1000),
        ],
      ),
    );
  }
}
