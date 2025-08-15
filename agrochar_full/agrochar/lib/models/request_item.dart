enum RequestType { sell, buy }

class RequestItem {
  String id;
  RequestType type;
  String product;
  String unit;
  double pricePerUnit;
  double quantityTotal;
  double quantityRemaining;

  RequestItem({
    required this.id,
    required this.type,
    required this.product,
    required this.unit,
    required this.pricePerUnit,
    required this.quantityTotal,
    required this.quantityRemaining,
  });

  factory RequestItem.fromMap(String id, Map<String, dynamic> m) => RequestItem(
        id: id,
        type: m['type'] == 'sell' ? RequestType.sell : RequestType.buy,
        product: m['product'],
        unit: m['unit'],
        pricePerUnit: (m['pricePerUnit'] as num).toDouble(),
        quantityTotal: (m['quantityTotal'] as num).toDouble(),
        quantityRemaining: (m['quantityRemaining'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'type': type == RequestType.sell ? 'sell' : 'buy',
        'product': product,
        'unit': unit,
        'pricePerUnit': pricePerUnit,
        'quantityTotal': quantityTotal,
        'quantityRemaining': quantityRemaining,
      };
}
