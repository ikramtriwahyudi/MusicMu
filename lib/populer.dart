import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_music/component/items.dart';
import 'component/modal.dart';
import 'component/music_card.dart';
import 'component/searchbar.dart';

class Populer extends StatefulWidget {
  Populer({Key? key, this.play, this.player, this.openPlayer, this.modal})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final play;
  final player;
  final openPlayer;
  final modal;

  @override
  _PopulerState createState() => _PopulerState();
}

class _PopulerState extends State<Populer> {
  var items = Items();
  List populer = [];
  getPopuler() async {
    await http
        .get(Uri.parse(
          'https://mbr-productions.my.id/new-yt-music-populer/get.php',
        ))
        .then(
          (res) async => {
            for (var i = 0; i < jsonDecode(res.body).length; i++)
              {
                await cachedInfoRequest(jsonDecode(res.body)[i]['video_id'])
                    .then(
                  (pop) {
                    populer.add(jsonDecode(pop));
                    setState(() {});
                  },
                ),
              },
          },
        );
  }

  cachedInfoRequest(videoId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? cachedInfo = pref.getString(videoId);
    // pref.clear();
    if (cachedInfo == null || cachedInfo == '') {
      var outp;
      await http
          .get(
        Uri.parse(
          'https://mbr-productions.my.id/new-yt-music/info/$videoId',
        ),
      )
          .then(
        (res) async {
          pref.setString(videoId, res.body);
          outp = res.body;
        },
      );
      return outp;
    } else {
      return cachedInfo;
    }
  }

  itemRawToItem(itemRaw) {
    var item = {};
    item = {
      'id': itemRaw['videoId'],
      'title': itemRaw['title'],
      'artist': itemRaw['ownerChannelName'],
      'duration': itemRaw['lengthSeconds'],
    };
    return item;
  }

  @override
  void initState() {
    super.initState();
    getPopuler();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Feel Your Music',
            textAlign: TextAlign.start,
            style: GoogleFonts.lexendDeca(
              fontSize: 34,
              color: Colors.grey.shade800,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'We have a lot of music collections',
            textAlign: TextAlign.start,
            style: GoogleFonts.lexendDeca(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (var itemRaw in populer)
                  GestureDetector(
                    onTap: () async {
                      var item = itemRawToItem(itemRaw);
                      await items.addSingleItem(item);
                      await items.getItemsAudioSource().then((value) {
                        widget.play(value, 0);
                      });
                      widget.openPlayer();
                    },
                    // child: Text('data'),
                    child: MusicCard(itemRawToItem(itemRaw), widget.modal),
                  )
              ],
            ),
          ),
          items.items.isEmpty
              ? const SizedBox(height: 0)
              : const SizedBox(height: 60),
        ],
      ),
    );
  }
}
