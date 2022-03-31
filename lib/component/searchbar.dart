import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchMusic extends StatefulWidget {
  SearchMusic({Key? key, this.onComplete}) : super(key: key);
  var onComplete;

  @override
  _SearchMusicState createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> {
  String keyword = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          keyword = value;
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (value == keyword && value != '') {
              widget.onComplete(value);
            }
          });
        },
        onEditingComplete: () {
          widget.onComplete(keyword);
        },
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        cursorColor: Colors.grey.shade800,
        style: GoogleFonts.lexendDeca(
          fontSize: 14,
          color: Colors.grey.shade800,
          // height: 0.5,
        ),
        decoration: const InputDecoration(
          // fillColor: Colors.grey,
          hintText: 'Search...',
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
