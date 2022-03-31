import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yt_music/component/modal.dart';

class MusicCard extends StatelessWidget {
  const MusicCard(this.item, this.modal, {Key? key}) : super(key: key);
  final dynamic item;
  final modal;

  @override
  Widget build(BuildContext context) {
    debugPrint(item.toString());
    return Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 0,
              right: 10,
            ),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://img.youtube.com/vi/${item['id']}/mqdefault.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['artist'] == '' ? 'No Artist' : item['artist']}',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 11,
                    fontWeight: FontWeight.w100,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '${item['title']}',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              modal(item);
            },
            child: const SizedBox(
              width: 30,
              height: 50,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Entypo.dots_three_vertical,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
