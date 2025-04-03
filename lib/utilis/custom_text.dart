import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextDecoration? decoration;

  const CustomText({
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.color = const Color(0xFF2C2E35),
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      ),
    );
  }
}

class CustomTextSubtitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextDecoration? decoration;

  const CustomTextSubtitle({
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = const Color.fromARGB(255, 147, 147, 147),
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      ),
    );
  }
}
