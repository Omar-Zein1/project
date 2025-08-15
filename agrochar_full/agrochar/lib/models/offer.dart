enum OfferType { sell, buy }

class Offer {
  String id;
  OfferType type;
  String product;
  String unit;
  double pricePerUnit;
  double quantityTotal;
  double quantityRemaining;

  Offer({
    required this.id,
    required this.type,
    required this.product,
    required this.unit,
    required this.pricePerUnit,
    required this.quantityTotal,
    required this.quantityRemaining,
  });

  factory Offer.fromMap(String id, Map<String, dynamic> m) => Offer(
        id: id,
        type: m['type'] == 'sell' ? OfferType.sell : OfferType.buy,
        product: m['product'],
        unit: m['unit'],
        pricePerUnit: (m['pricePerUnit'] as num).toDouble(),
        quantityTotal: (m['quantityTotal'] as num).toDouble(),
        quantityRemaining: (m['quantityRemaining'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'type': type == OfferType.sell ? 'sell' : 'buy',
        'product': product,
        'unit': unit,
        'pricePerUnit': pricePerUnit,
        'quantityTotal': quantityTotal,
        'quantityRemaining': quantityRemaining,
      };
}
