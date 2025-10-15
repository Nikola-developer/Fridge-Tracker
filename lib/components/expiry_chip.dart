import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hylastix_fridge/models/fridge_item.dart';
import 'package:hylastix_fridge/theme.dart';

class ExpiryChip extends StatelessWidget {
  final FridgeItem item;

  const ExpiryChip({required this.item});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bb = item.bestBefore;
    late final String label;
    late final Color color;

    if (bb == null) {
      label = 'No date';
      color = Colors.white;
    } else {
      final diff = bb.difference(now).inDays;
      if (diff < 0) {
        label = 'Expired';
        color = Colors.redAccent;
      } else if (diff <= 2) {
        label = '${diff}d left';
        color = colorAccent;
      } else {
        label = '${diff}d left';
        color = Colors.greenAccent;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: color),
      ),
      // side: BorderSide(color: color.withOpacity(0.6)),
    );
  }
}
