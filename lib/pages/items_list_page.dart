import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hylastix_fridge/backend/fridge_items/fridge_items.dart';
import 'package:hylastix_fridge/components/card_fridge_item.dart';
import 'package:hylastix_fridge/components/custom_button.dart';
import 'package:hylastix_fridge/models/fridge_item.dart';
import 'package:hylastix_fridge/theme.dart';

import 'fridge_item_details.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  bool loadingItems = false;
  List<FridgeItem> _items = [];

  late final FridgeItemsDataSource ds;
  StreamSubscription<List<FridgeItem>>? sub;
  bool byBestBefore = false;

  @override
  void initState() {
    super.initState();

    ds = FridgeItemsFirestore();

    _resubscribe();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  void _resubscribe() {

    sub?.cancel();
    final stream = byBestBefore
        ? ds.watchAllSortedByBestBefore()
        : ds.watchAllSortedByAddedAt();

    sub = stream.listen(
      (list) => setState(() => _items = list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hylastix Fridge',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: colorWhite,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: loadingItems
            ? _LoadingState()
            : _items.isEmpty
            ? const _EmptyState()
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Time stored',
                          onPressed: () {
                            if (byBestBefore) {
                              setState(() => byBestBefore = false);
                              _resubscribe();
                            }
                          },
                          backgroundColor: byBestBefore ? null : colorAccent,
                          textColor: byBestBefore ? null : colorBackground,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Best Before',
                          onPressed: () {
                            if (!byBestBefore) {
                              setState(() => byBestBefore = true);
                              _resubscribe();
                            }
                          },
                          backgroundColor: byBestBefore ? colorAccent : null,
                          textColor: byBestBefore ? colorBackground : null,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          for (var item in _items)
                            CardFridgeItem(
                              item: item,
                              onTap: () => _openDetails(item),
                              onDelete: () {},
                            ),

                          SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FridgeItemDetailsPage(item: null),
            ),
          );
        },
        child: Icon(Icons.add, color: colorCard),
      ),
    );
  }

  void _openDetails(FridgeItem item) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FridgeItemDetailsPage(item: item),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.kitchen, size: 64, color: colorWhite),
          const SizedBox(height: 12),
          Text(
            'No items yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: colorWhite),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add your first item',
            style: GoogleFonts.dmSans(color: colorWhite),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: colorWhite));
  }
}
