import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText {
  dynamic text;
  dynamic fontSize;
  dynamic fontWeight;
  dynamic letterSpacing;
  dynamic fontColor;
  dynamic textAlign;
  dynamic textDecoration;
  dynamic maxLines;
  dynamic shadows;
  dynamic height;
  CustomText(
      {required this.text,
      this.fontSize,
      this.fontWeight,
      this.letterSpacing,
      this.shadows,
      this.fontColor,
      this.textAlign,
      this.maxLines,
      this.height,
      this.textDecoration});
  Widget setText() {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
          shadows: shadows,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: fontColor,
          height: height,
          decoration: textDecoration ?? TextDecoration.none,
          letterSpacing: letterSpacing),
    );
  }
}
