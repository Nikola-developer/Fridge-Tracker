import 'package:flutter/material.dart';
import 'package:flutter_easy_date/flutter_easy_date.dart';
import 'package:hylastix_fridge/theme.dart';
import '../models/fridge_item.dart';
import 'expiry_chip.dart';

class CardFridgeItem extends StatelessWidget {
  final FridgeItem item;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CardFridgeItem({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorWhite,
          ),
        ),
        subtitle: Text(
          _subtitle(item),
          style: TextStyle(color: colorWhite),
        ),
        trailing: ExpiryChip(item: item),
        onTap: onTap,
      ),
    );
  }

  String _subtitle(FridgeItem i) {
    final storedDays = DateTime.now().difference(i.addedAt).inDays;
    final storedText = storedDays == 0
        ? 'Stored today'
        : 'Stored ${storedDays}d ago';
    final bb = i.bestBefore;
    final bbText = bb == null
        ? ''
        : ' • Best-before ${EasyDate.date(bb)}';
    return '$storedText$bbText';
  }
}
