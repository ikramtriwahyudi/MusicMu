import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    this.color = Colors.brown,
    this.size = 14,
    this.align = TextAlign.center,
    this.fontWeight = FontWeight.normal,
    Key? key,
  }) : super(key: key);
  final String text;
  final Color color;
  final double size;
  final TextAlign align;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
      ),
      textAlign: align,
    );
  }
}

class CustomTextSimple extends StatelessWidget {
  const CustomTextSimple(this.text, this.color, this.align, {Key? key})
      : super(key: key);
  final String text;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: color,
      size: 14,
      align: align,
    );
  }
}

class TextSimple extends StatelessWidget {
  const TextSimple(this.text, {this.align = TextAlign.center, Key? key})
      : super(key: key);
  final String text;
  final TextAlign align;

  Widget primary() {
    return CustomText(text, color: ColorCustom.primary, align: align);
  }

  @override
  Widget build(BuildContext context) {
    return CustomText(text, color: ColorCustom.primary, align: align);
  }
}

class CustomTextTitle extends StatelessWidget {
  const CustomTextTitle(this.text, this.color, this.align, {Key? key})
      : super(key: key);
  final String text;
  final Color color;
  final TextAlign align;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: color,
      size: 18,
      align: align,
    );
  }
}

class CustomTextLabel extends StatelessWidget {
  const CustomTextLabel(this.text, this.color, {Key? key}) : super(key: key);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: color,
      size: 12,
    );
  }
}

class CustomTextHeader extends StatelessWidget {
  const CustomTextHeader(this.text, this.color, {Key? key}) : super(key: key);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: color,
      size: 26,
    );
  }
}
