// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_service/audio_service.dart';
import 'home.dart';

void main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  //   notificationColor: Colors.white,
  // );
  AudioHandler h = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      notificationColor: Colors.white,
    ),
  );
  await h.playMediaItem(MediaItem(
    id: 'https://example.com/audio.mp3',
    album: 'Album name',
    title: 'Track title',
    artist: 'Artist name',
    duration: const Duration(milliseconds: 123456),
    artUri: Uri.parse('https://example.com/album.jpg'),
  ));
  h.play();
  // h.updateMediaItem(MediaItem(
  //   id: 'https://example.com/audio.mp3',
  //   album: 'Album name',
  //   title: 'Track title',
  //   artist: 'Artist name',
  //   duration: const Duration(milliseconds: 123456),
  //   artUri: Uri.parse('https://example.com/album.jpg'),
  // ));

  runApp(const MyApp());
}

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  // The most common callbacks:
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
  }
  Future<void> pause() async {}
  Future<void> stop() async {}
  Future<void> seek(Duration position) async {}
  Future<void> skipToQueueItem(int i) async {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YT Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Home(),
      ),
    );
  }
}
