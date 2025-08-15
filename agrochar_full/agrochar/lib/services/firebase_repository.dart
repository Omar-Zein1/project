import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer.dart';
import '../models/request_item.dart';
import 'repository.dart';

class FirebaseRepository implements Repository {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String,dynamic>> get _offers => _db.collection('offers');
  CollectionReference<Map<String,dynamic>> get _requests => _db.collection('requests');

  // Offers
  @override
  Stream<List<Offer>> offers(OfferType type) {
    return _offers.where('type', isEqualTo: type == OfferType.sell ? 'sell' : 'buy')
      .snapshots()
      .map((snap) => snap.docs.map((d) => Offer.fromMap(d.id, d.data())).toList());
  }

  @override
  Future<void> addOffer(Offer offer) async {
    await _offers.add(offer.toMap());
  }

  @override
  Future<void> reserve(String offerId, double qty) async {
    final ref = _offers.doc(offerId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() as Map<String, dynamic>;
      final remaining = (data['quantityRemaining'] as num).toDouble();
      final newRemaining = (remaining - qty) < 0 ? 0.0 : (remaining - qty);
      tx.update(ref, {'quantityRemaining': newRemaining});
    });
  }

  // Requests
  @override
  Stream<List<RequestItem>> requests(RequestType type) {
    return _requests.where('type', isEqualTo: type == RequestType.sell ? 'sell' : 'buy')
      .snapshots()
      .map((snap) => snap.docs.map((d) => RequestItem.fromMap(d.id, d.data())).toList());
  }

  @override
  Future<void> addRequest(RequestItem item) async {
    await _requests.add(item.toMap());
  }

  @override
  Future<void> reserveRequest(String requestId, double qty) async {
    final ref = _requests.doc(requestId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() as Map<String, dynamic>;
      final remaining = (data['quantityRemaining'] as num).toDouble();
      final newRemaining = (remaining - qty) < 0 ? 0.0 : (remaining - qty);
      tx.update(ref, {'quantityRemaining': newRemaining});
    });
  }
}
