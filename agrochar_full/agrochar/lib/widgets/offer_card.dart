import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/offer.dart';
import '../services/repository.dart';

class OfferCard extends StatefulWidget {
  final Offer offer;
  const OfferCard({super.key, required this.offer});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  final _qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
    final o = widget.offer;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(o.type == OfferType.sell ? t('sell') : t('buy'))),
                const SizedBox(width: 8),
                Text(o.product, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Text('${t('price')}: ${o.pricePerUnit} / ${o.unit}'),
            Text('${t('quantity')}: ${o.quantityTotal} ${o.unit}'),
            Text('${t('remaining')}: ${o.quantityRemaining} ${o.unit}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextField(controller: _qty, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: t('quantity')))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final qty = double.tryParse(_qty.text) ?? 0;
                    if (qty <= 0) return;
                    await context.read<Repository>().reserve(o.id, qty);
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('reserved_ok'))));
                    _qty.clear();
                  },
                  child: Text(t('reserve')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
