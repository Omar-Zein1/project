import 'dart:async';
import '../models/offer.dart';
import '../models/request_item.dart';
import 'repository.dart';

class MockRepository implements Repository {
  final Map<String, Offer> _offers = {};
  final Map<String, RequestItem> _requests = {};

  final StreamController<List<Offer>> _sellOffersCtl = StreamController.broadcast();
  final StreamController<List<Offer>> _buyOffersCtl = StreamController.broadcast();

  final StreamController<List<RequestItem>> _sellReqCtl = StreamController.broadcast();
  final StreamController<List<RequestItem>> _buyReqCtl = StreamController.broadcast();

  MockRepository.seeded() {
    // seed offers
    final seedOffers = <Offer>[
      Offer(id: 's1', type: OfferType.sell, product: 'قش أرز', unit: 'طن', pricePerUnit: 1200, quantityTotal: 50, quantityRemaining: 50),
      Offer(id: 's2', type: OfferType.sell, product: 'سيلاج ذرة', unit: 'طن', pricePerUnit: 1800, quantityTotal: 30, quantityRemaining: 12),
      Offer(id: 'b1', type: OfferType.buy,  product: 'حطب ذرة', unit: 'طن', pricePerUnit: 900,  quantityTotal: 40, quantityRemaining: 40),
      Offer(id: 'b2', type: OfferType.buy,  product: 'تبن قمح', unit: 'طن', pricePerUnit: 1000, quantityTotal: 20, quantityRemaining: 5),
    ];
    for (final o in seedOffers) {
      _offers[o.id] = o;
    }

    // seed requests
    final seedReqs = <RequestItem>[
      RequestItem(id: 'rs1', type: RequestType.sell, product: 'مخلفات طماطم', unit: 'طن', pricePerUnit: 700, quantityTotal: 25, quantityRemaining: 25),
      RequestItem(id: 'rs2', type: RequestType.sell, product: 'حطب فول', unit: 'طن', pricePerUnit: 650, quantityTotal: 15, quantityRemaining: 8),
      RequestItem(id: 'rb1', type: RequestType.buy, product: 'قش أرز', unit: 'طن', pricePerUnit: 1100, quantityTotal: 60, quantityRemaining: 44),
      RequestItem(id: 'rb2', type: RequestType.buy, product: 'تبن قمح', unit: 'طن', pricePerUnit: 950, quantityTotal: 30, quantityRemaining: 30),
    ];
    for (final r in seedReqs) {
      _requests[r.id] = r;
    }

    _push();
  }

  void _push() {
    _sellOffersCtl.add(_offers.values.where((o) => o.type == OfferType.sell).toList());
    _buyOffersCtl.add(_offers.values.where((o) => o.type == OfferType.buy).toList());

    _sellReqCtl.add(_requests.values.where((r) => r.type == RequestType.sell).toList());
    _buyReqCtl.add(_requests.values.where((r) => r.type == RequestType.buy).toList());
  }

  // Offers
  @override
  Stream<List<Offer>> offers(OfferType type) => type == OfferType.sell ? _sellOffersCtl.stream : _buyOffersCtl.stream;

  @override
  Future<void> addOffer(Offer offer) async {
    _offers[offer.id] = offer;
    _push();
  }

  @override
  Future<void> reserve(String offerId, double qty) async {
    final o = _offers[offerId];
    if (o == null) return;
    final remaining = o.quantityRemaining - qty;
    o.quantityRemaining = remaining < 0 ? 0 : remaining;
    _offers[offerId] = o;
    _push();
  }

  // Requests
  @override
  Stream<List<RequestItem>> requests(RequestType type) => type == RequestType.sell ? _sellReqCtl.stream : _buyReqCtl.stream;

  @override
  Future<void> addRequest(RequestItem item) async {
    _requests[item.id] = item;
    _push();
  }

  @override
  Future<void> reserveRequest(String requestId, double qty) async {
    final r = _requests[requestId];
    if (r == null) return;
    final remaining = r.quantityRemaining - qty;
    r.quantityRemaining = remaining < 0 ? 0 : remaining;
    _requests[requestId] = r;
    _push();
  }
}
