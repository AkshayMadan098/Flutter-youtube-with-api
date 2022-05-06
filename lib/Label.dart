import 'package:flutter/material.dart';
class LabelWidget extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final int maxLine;
  final TextOverflow overflow;
  final bool vertical;
  final double runSpacing;
  final double? fontSize;
  final double? height;
  final EdgeInsets? padding;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  const LabelWidget(
      this.text, {
        Key? key,
        this.color = Colors.black,
        this.fontSize = 13,
        this.height,
        this.padding,
        this.fontWeight = FontWeight.normal,
        this.textAlign,
        this.maxLine = 1,
        this.overflow = TextOverflow.ellipsis,
        this.vertical = false,
        this.runSpacing = 10,
        this.textDecoration,
        this.fontFamily = 'sans/HumanSans-Bold.otf',
        this.fontStyle,
      }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Container(
        padding: padding,
        child: Wrap(
          runSpacing: runSpacing,
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: text
              .split("")
              .map(
                (string) => Text(
              string,
              style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                  fontWeight: fontWeight,
                  fontFamily: fontFamily,
                  fontStyle: fontStyle),
              textAlign: textAlign,
              maxLines: maxLine,
              overflow: overflow,
            ),
          )
              .toList(),
        ),
      );
    }
    return Container(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          decoration: textDecoration,
          fontFamily: fontFamily,
          fontStyle: fontStyle,
        ),
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: overflow,
      ),
    );
  }
}
