import 'package:flutter/material.dart';
import 'package:hylastix_fridge/theme.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.onPressed,

    super.key,
  });

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function()? onPressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        // Text and icon color
        foregroundColor: widget.textColor ?? colorWhite,
        // Background color
        backgroundColor: widget.backgroundColor ?? colorBackground,
        // Border color and width
        side: BorderSide(color: colorWhite, width: .5),
        // Button shape
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        // Internal padding
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Text style
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      child: Text(widget.text),
    );
  }
}
