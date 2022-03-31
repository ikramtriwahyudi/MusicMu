import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'items.dart';

class PopupModalMusicCard extends StatelessWidget {
  PopupModalMusicCard(this.item, {Key? key}) : super(key: key);
  final item;

  var items = Items();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Add playlist',
              style: GoogleFonts.lexendDeca(
                fontSize: 20,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await items.addItem(item);
                Navigator.pop(context);
              },
              child: Text(
                'Add Queue',
                style: GoogleFonts.lexendDeca(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
