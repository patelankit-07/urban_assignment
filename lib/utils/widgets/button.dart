import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyButton extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final bool loading;
  final Color? bgColor;

  const MyButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false,
      this.style,
      this.width,
      this.height,
      this.padding,
      this.textColor,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)),
              alignment: Alignment.center,
              textStyle: style ??
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          child: Center(
              child: loading == false
                  ? Text(
                      title,
                      style: TextStyle(
                          color: textColor ??
                              const Color.fromRGBO(66, 31, 31, 0.996)),
                    )
                  : LoadingAnimationWidget.inkDrop(
                      color: Colors.white,
                      size: 30,
                    ))),
    );
  }
}
