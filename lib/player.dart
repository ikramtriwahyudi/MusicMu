import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_music/component/music_card.dart';

import 'component/items.dart';
import 'component/slider.dart';

class Player extends StatefulWidget {
  Player(this.player, this.play, {Key? key}) : super(key: key);

  var play;
  AudioPlayer player;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double currentSliderValue = 0.0;
  double maxSliderValue = 0.0;

  var items = Items();
  List nowPlaying = [];
  int nowPlayingIndex = 0;

  duration() async {
    setState(() {});
    await nowPlayinginit();
    Future.delayed(const Duration(seconds: 1), () {
      duration();
    });
  }

  String thumbnail = "";
  var thumbnailMax = "";
  var thumbnailMin = "";
  checkYThumbnail(id) async {
    await http
        .get(
      Uri.parse(thumbnailMax),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return thumbnail = thumbnailMax;
      } else {
        return thumbnail = thumbnailMin;
      }
    });
  }

  nowPlayinginit() async {
    nowPlaying = await items.getItems();
    nowPlayingIndex = widget.player.currentIndex ?? 0;
    thumbnailMax =
        'https://img.youtube.com/vi/${nowPlaying[nowPlayingIndex]['id']}/maxresdefault.jpg';
    thumbnailMin =
        'https://img.youtube.com/vi/${nowPlaying[nowPlayingIndex]['id']}/mqdefault.jpg';
    await checkYThumbnail(nowPlaying[nowPlayingIndex]['id']);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    duration();
    nowPlayinginit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  thumbnail,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text(
                  nowPlaying[nowPlayingIndex]['artist'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  nowPlaying[nowPlayingIndex]['title'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Text(
          //   DateFormat('mm:ss').format(
          //     DateTime.fromMillisecondsSinceEpoch(
          //       widget.player.bufferedPosition.inMilliseconds
          //           .toInt(),
          //     ),
          //   ),
          //   style: GoogleFonts.lexendDeca(
          //     fontSize: 12,
          //     fontWeight: FontWeight.w200,
          //     color: Colors.grey.shade800,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MusicSlider(
                currentSliderValue:
                    widget.player.position.inMilliseconds.toDouble() >
                            widget.player.duration!.inMilliseconds.toDouble()
                        ? widget.player.duration!.inMilliseconds.toDouble()
                        : widget.player.position.inMilliseconds.toDouble(),
                maxSliderValue:
                    widget.player.duration!.inMilliseconds.toDouble(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 15,
                  right: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey.shade500,
                ),
                child: const Icon(
                  Ionicons.md_shuffle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  widget.player.seekToPrevious();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 14,
                    bottom: 16,
                    left: 14,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade800,
                  ),
                  child: const Icon(
                    Ionicons.md_skip_backward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              widget.player.playing
                  ? GestureDetector(
                      onTap: () async {
                        // setState(() {
                        //   widget.isPlaying = false;
                        // });
                        await widget.player.pause();
                        // widget.pause();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 13,
                          bottom: 17,
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.shade800,
                        ),
                        child: const Icon(
                          Ionicons.md_pause,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        // setState(() {
                        //   widget.isPlaying = true;
                        // });
                        await widget.player.play();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 13,
                          bottom: 17,
                          left: 18,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.shade800,
                        ),
                        child: const Icon(
                          Ionicons.md_play,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  widget.player.seekToNext();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 14,
                    bottom: 16,
                    left: 17,
                    right: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade800,
                  ),
                  child: const Icon(
                    Ionicons.md_skip_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  showBarModalBottomSheet(
                    duration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.only(
                        top: 25,
                        bottom: 15,
                        left: 15,
                        right: 15,
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Up Next',
                            style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (var i = 0; i < nowPlaying.length; i++)
                            Container(
                              color: i == nowPlayingIndex
                                  ? Colors.grey.shade200
                                  : Colors.transparent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 5,
                                      right: 10,
                                    ),
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          'https://img.youtube.com/vi/${nowPlaying[i]['id']}/mqdefault.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nowPlaying[i]['artist'],
                                          style: GoogleFonts.lexendDeca(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        Text(
                                          nowPlaying[i]['title'],
                                          style: GoogleFonts.lexendDeca(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade500,
                  ),
                  child: const Icon(
                    MaterialIcons.queue_music,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
