import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double fontSize;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.height = 50,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor ?? Theme.of(context).primaryColor,
                  side: BorderSide(
                    color: backgroundColor ?? Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(text, style: TextStyle(fontSize: fontSize)),
              )
              : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).primaryColor,
                  foregroundColor: textColor ?? Colors.white,
                ),
                child: Text(text, style: TextStyle(fontSize: fontSize)),
              ),
    );
  }
}
