import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_music/player.dart';
import 'package:yt_music/playlist.dart';
import 'package:yt_music/populer.dart';
import 'package:yt_music/search.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:audio_service/audio_service.dart';

import 'component/items.dart';
import 'component/modal.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final player = AudioPlayer();
  bool isPlaying = false;
  List nowPlaying = [];
  int nowPlayingIndex = 0;

  var items = Items();

  void play(items, index) async {
    await player.setAudioSource(
      ConcatenatingAudioSource(
        children: items,
      ),
      initialIndex: index,
    );
    player.play();
    setState(() {});
  }

  openPlayer() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Player(
          player,
          play,
        ),
      ),
    );
  }

  openModalMusicCard(item) {
    showMaterialModalBottomSheet(
      duration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => PopupModalMusicCard(item),
    );
  }

  // duration() async {
  //   ProcessingState state = player.playbackEvent.processingState;
  //   await nowPlayinginit();
  //   if (state == ProcessingState.completed) {
  //     var i = player.currentIndex ?? 0;
  //     if (i >= nowPlaying.length) {
  //       player.stop();
  //       play(nowPlaying, 0);
  //     } else {
  //       player.seekToNext();
  //     }

  //     await nowPlayinginit();
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       duration();
  //     });
  //   } else if (state == ProcessingState.ready) {
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       duration();
  //     });
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       duration();
  //     });
  //   }
  //   setState(() {});
  // }

  nowPlayinginit() async {
    nowPlaying = await items.getItems();
    nowPlayingIndex = player.currentIndex ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // duration();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    nowPlayinginit();

    // player.positionStream.listen((event) async {
    //   if (event.inSeconds.toDouble() <= 0.5 && nowPlayingIndex != 0) {
    //     await items.getItemsAudioSource().then((value) {
    //       player.setAudioSource(ConcatenatingAudioSource(children: value));
    //     });
    //   }
    // });

    // player.playbackEventStream.listen((event) async {
    //   if (event.processingState == ProcessingState.completed) {
    //     var i = player.currentIndex ?? 0;
    //     if (i >= nowPlaying.length) {
    //       player.stop();
    //       play(nowPlaying, 0);
    //     } else {
    //       player.seekToNext();
    //     }
    //     await nowPlayinginit();
    //     // duration();
    //   }
    // });

    player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        var i = player.currentIndex ?? 0;
        if (i >= nowPlaying.length) {
          player.stop();
          play(nowPlaying, 0);
        } else {
          player.seekToNext();
        }
        await nowPlayinginit();
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   duration();
        // });
      } else if (state == ProcessingState.ready) {
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   duration();
        // });
      } else if (state == ProcessingState.idle) {
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   duration();
        // });
      }
      setState(() {});
    });
  }

  int selectedIndex = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List tab = [
      Populer(
        play: play,
        openPlayer: openPlayer,
        modal: openModalMusicCard,
      ),
      Search(
        play: play,
        openPlayer: openPlayer,
        modal: openModalMusicCard,
      ),
      Playlist(
        play: play,
        openPlayer: openPlayer,
      ),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Trending"),
              selectedColor: Colors.purple,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: const Text("Search"),
              selectedColor: Colors.orange,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text("Playlist"),
              selectedColor: Colors.pink,
            ),
          ],
        ),
      ),
      // backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                child: tab[currentIndex],
              ),
              nowPlaying.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          openPlayer();
                        },
                        child: Container(
                          height: 65,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      'https://img.youtube.com/vi/${nowPlaying[nowPlayingIndex]['id']}/mqdefault.jpg',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nowPlaying[nowPlayingIndex]['artist'],
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                    Text(
                                      nowPlaying[nowPlayingIndex]['title'],
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
