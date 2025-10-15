import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hylastix_fridge/backend/fridge_items/fridge_items.dart';
import 'package:hylastix_fridge/components/custom_button.dart';
import 'package:hylastix_fridge/components/custom_input_field.dart';
import 'package:hylastix_fridge/models/fridge_item.dart';
import 'package:hylastix_fridge/theme.dart';

class FridgeItemDetailsPage extends StatefulWidget {
  final FridgeItem? item;

  const FridgeItemDetailsPage({super.key, this.item});

  @override
  State<FridgeItemDetailsPage> createState() => _FridgeItemDetailsPageState();
}

class _FridgeItemDetailsPageState extends State<FridgeItemDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _qtyC;
  DateTime? _bestBefore;
  late DateTime _addedAt;
  final FridgeItemsDataSource ds = FridgeItemsFirestore();

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _nameC = TextEditingController(text: i?.name ?? '');
    _qtyC = TextEditingController(text: (i?.quantity ?? 1).toString());
    _bestBefore = i?.bestBefore;
    _addedAt = i?.addedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameC.dispose();
    _qtyC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null ? 'Add item' : 'Edit item',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorWhite),
        ),
        actions: [
          if (widget.item != null)
            IconButton(
              onPressed: () async {
                var navigator = Navigator.of(context);
                var scaffold = ScaffoldMessenger.of(context);

                var check = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure?',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: colorWhite),
                    ),
                    contentPadding: EdgeInsets.zero,
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              text: 'Cancel',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              text: 'Confirm',
                              textColor: colorBackground,
                              backgroundColor: colorAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                if (check!=null && check) {
                  String messageText = 'Successfully deleted item!';
                  Result res;
                  res = await ds.delete(widget.item!.id);
                  if (!res.isOk) {
                    messageText = res.errorText!;
                  }

                  scaffold.showSnackBar(
                    SnackBar(
                      backgroundColor: res.isOk ? Colors.green : Colors.red,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        messageText,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );

                  // Close page only on success
                  if (res.isOk) navigator.pop();
                }
              },
              icon: Icon(CupertinoIcons.delete, color: Colors.red),
            ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Cancel',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      var navigator = Navigator.of(context);
                      var scaffold = ScaffoldMessenger.of(context);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Saving',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(color: colorWhite),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [CircularProgressIndicator()],
                          ),
                        ),
                      );

                      final item = FridgeItem(
                        id:
                            widget.item?.id ??
                            DateTime.now().microsecondsSinceEpoch.toString(),
                        name: _nameC.text.trim(),
                        quantity: int.parse(_qtyC.text),
                        addedAt: _addedAt,
                        bestBefore: _bestBefore,
                      );

                      String messageText = '';
                      Result res;
                      if (widget.item == null) {
                        messageText = 'Successfully added item!';
                        res = await ds.create(item);
                      } else {
                        messageText = 'Successfully updated item!';
                        res = await ds.update(item);
                      }
                      if (!res.isOk) {
                        messageText = res.errorText!;
                      }

                      scaffold.showSnackBar(
                        SnackBar(
                          backgroundColor: res.isOk ? Colors.green : Colors.red,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            messageText,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      );

                      // Close dialog
                      navigator.pop();
                      // Close page only on success
                      if (res.isOk) navigator.pop();
                    },
                    text: widget.item == null ? 'Add' : 'Save',
                    textColor: colorBackground,
                    backgroundColor: colorAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomInputField(
                controller: _nameC,
                hint: 'Name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              CustomInputField(
                controller: _qtyC,
                hint: 'Quantity',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Best-before: ',
                    style: GoogleFonts.dmSans(color: Colors.white),
                  ),

                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now.subtract(const Duration(days: 365)),
                        lastDate: now.add(const Duration(days: 365 * 5)),
                        initialDate: _bestBefore ?? now,
                      );
                      if (picked != null) setState(() => _bestBefore = picked);
                    },
                    child: Text(
                      _bestBefore == null
                          ? 'Pick date'
                          : _fmtDate(_bestBefore!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) => "${d.year}-${_two(d.month)}-${_two(d.day)}";

  String _two(int x) => x < 10 ? '0$x' : '$x';
}
