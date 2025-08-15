import '../models/offer.dart';
import '../models/request_item.dart';

abstract class Repository {
  // Offers
  Stream<List<Offer>> offers(OfferType type);
  Future<void> addOffer(Offer offer);
  Future<void> reserve(String offerId, double qty);

  // Requests
  Stream<List<RequestItem>> requests(RequestType type);
  Future<void> addRequest(RequestItem item);
  Future<void> reserveRequest(String requestId, double qty);
}
