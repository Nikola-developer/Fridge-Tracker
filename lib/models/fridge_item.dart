class FridgeItem {
  final String id;
  String name;
  int quantity;
  DateTime addedAt; // when stored
  DateTime? bestBefore; // optional

  FridgeItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.addedAt,
    this.bestBefore,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'addedAt': addedAt.toIso8601String(),
    'bestBefore': bestBefore?.toIso8601String(),
  };

  static FridgeItem fromMap(String id, Map<String, dynamic> m) {
    return FridgeItem(
      id: id,
      name: m['name'] as String,
      quantity: (m['quantity'] as num).toInt(),
      addedAt: DateTime.parse(m['addedAt'] as String),
      bestBefore: m['bestBefore'] != null
          ? DateTime.parse(m['bestBefore'] as String)
          : null,
    );
  }
}
