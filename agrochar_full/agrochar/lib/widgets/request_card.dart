import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/request_item.dart';
import '../services/repository.dart';

class RequestCard extends StatefulWidget {
  final RequestItem item;
  const RequestCard({super.key, required this.item});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final _qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
    final r = widget.item;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(r.type == RequestType.sell ? t('sell') : t('buy'))),
                const SizedBox(width: 8),
                Text(r.product, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Text('${t('price')}: ${r.pricePerUnit} / ${r.unit}'),
            Text('${t('quantity')}: ${r.quantityTotal} ${r.unit}'),
            Text('${t('remaining')}: ${r.quantityRemaining} ${r.unit}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextField(controller: _qty, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: t('quantity')))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final qty = double.tryParse(_qty.text) ?? 0;
                    if (qty <= 0) return;
                    await context.read<Repository>().reserveRequest(r.id, qty);
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
