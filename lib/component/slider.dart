import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MusicSlider extends StatelessWidget {
  MusicSlider(
      {Key? key, this.currentSliderValue = 0.0, this.maxSliderValue = 0.0})
      : super(key: key);
  double currentSliderValue;
  double maxSliderValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.grey.shade800,
              inactiveTrackColor: Colors.grey.shade200,
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 5.0,
                elevation: 0,
              ),
              thumbColor: Colors.grey.shade800,
              overlayColor: Colors.grey.shade300,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
              tickMarkShape: const RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.grey.shade500,
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: GoogleFonts.lexendDeca(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Colors.grey.shade500,
              ),
            ),
            child: Slider(
              value: currentSliderValue,
              min: 0,
              // thumbColor: Colors.white,
              max: maxSliderValue,
              // divisions: 100,
              label: currentSliderValue.round().toString(),
              onChanged: (double value) {
                currentSliderValue = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      currentSliderValue.toInt(),
                    ),
                  ),
                  style: GoogleFonts.lexendDeca(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  DateFormat('mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      maxSliderValue.toInt(),
                    ),
                  ),
                  style: GoogleFonts.lexendDeca(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    ;
  }
}
