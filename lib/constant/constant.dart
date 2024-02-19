import 'package:flutter/material.dart';

var width;
var height;

InputDecoration ramsInputDecoration({
  String? hint,
  IconData? prefixIcon,
  bool readOnly = false,
  EdgeInsets? padding,
  Color? borderColor,
}) {
  Color bgColor = readOnly ? Colors.grey[200]! : Colors.blue.withOpacity(0.04);
  Color prefixIconColor = readOnly ? Colors.grey : Colors.blue;
  return InputDecoration(
    contentPadding:
        padding ?? EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    counter: Offstage(),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor ?? Colors.blue)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
    ),
    hintText: hint,
    filled: true,
    fillColor: bgColor,
    prefixIcon: prefixIcon != null
        ? Icon(
            prefixIcon,
            color: prefixIconColor,
          )
        : null,
    // Add other decoration properties as needed
  );
}

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class RadiantGradientMask extends StatelessWidget {
  final Widget child;
  RadiantGradientMask({required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          HexColor('#1d5ace'),
          HexColor('#04b7f9'),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
