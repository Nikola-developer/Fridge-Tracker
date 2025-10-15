import 'package:hylastix_fridge/models/fridge_item.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result<T> {
  final T? data;
  final String? errorText;

  const Result._(this.data, this.errorText);

  static Result<T> ok<T>(T? data) => Result._(data, null);

  static Result<T> error<T>(String e) => Result._(null, e);

  bool get isOk => errorText == null;
}

/// Naš CRUD interfejs – lako menjaš backend (Firestore / Local).
abstract class FridgeItemsDataSource {
  Future<Result<String>> create(FridgeItem item);

  Future<Result<String>> update(FridgeItem item);

  Future<Result<String>> delete(String id);

  // time stored (oldest first)
  Stream<List<FridgeItem>> watchAllSortedByAddedAt();

  // best-before (soonest first, null last)
  Stream<List<FridgeItem>> watchAllSortedByBestBefore();
}

class FridgeItemsFirestore implements FridgeItemsDataSource {
  FridgeItemsFirestore({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('items');

  @override
  Future<Result<String>> create(FridgeItem item) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final doc = _col.doc();
      await doc.set(item.toMap());

      return Result.ok(doc.id);
    } on FirebaseException catch (e) {
      return Result.error(e.message ?? 'Firebase error');
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Stream<List<FridgeItem>> watchAllSortedByAddedAt() {
    return _col
        .orderBy('addedAt', descending: false)
        .snapshots()
        .map(_mapQuery);
  }

  @override
  Stream<List<FridgeItem>> watchAllSortedByBestBefore() {
    return _col
        .orderBy('bestBefore', descending: false)
        .snapshots()
        .map(_mapQuery);
  }

  List<FridgeItem> _mapQuery(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((d) => FridgeItem.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<Result<String>> update(FridgeItem item) async {
    // This is added intentionally, because using local firebase emulator i fast
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _col.doc(item.id).update(item.toMap());
      return Result.ok(null);
    } on FirebaseException catch (e) {
      return Result.error(e.message ?? 'Firebase error');
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<String>> delete(String id) async {
    // This is added intentionally, because using local firebase emulator i fast
    await Future.delayed(Duration(milliseconds: 500));
    try {
      _col.doc(id).delete();
      return Result.ok(null);
    } on FirebaseException catch (e) {
      return Result.error(e.message ?? 'Firebase error');
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
