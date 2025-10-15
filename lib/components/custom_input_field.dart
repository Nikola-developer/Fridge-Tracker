import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hylastix_fridge/theme.dart';

class CustomInputField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;

  const CustomInputField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization,
            validator: widget.validator,
            style: GoogleFonts.dmSans(color: Colors.white),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              hintStyle: GoogleFonts.dmSans(color: colorWhite),
              filled: true,
              fillColor: colorCard,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: colorCard, width: 0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: colorCard, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: colorCard, width: 0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: colorCard, width: 0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: colorCard, width: 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
