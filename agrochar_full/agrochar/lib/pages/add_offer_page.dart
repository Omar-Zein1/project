import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/offer.dart';
import '../services/repository.dart';

class AddOfferPage extends StatefulWidget {
  const AddOfferPage({super.key});

  @override
  State<AddOfferPage> createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  OfferType _type = OfferType.sell;
  final _product = TextEditingController();
  final _unit = TextEditingController(text: 'طن');
  final _price = TextEditingController();
  final _qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
    return Scaffold(
      appBar: AppBar(title: Text(t('add_offer'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<OfferType>(
                    value: OfferType.sell,
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                    title: Text(t('sell')),
                  ),
                ),
                Expanded(
                  child: RadioListTile<OfferType>(
                    value: OfferType.buy,
                    groupValue: _type,
                    onChanged: (v) => setState(() => _type = v!),
                    title: Text(t('buy')),
                  ),
                ),
              ],
            ),
            TextField(controller: _product, decoration: InputDecoration(labelText: t('product'))),
            TextField(controller: _unit, decoration: InputDecoration(labelText: t('unit'))),
            TextField(controller: _price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: t('price'))),
            TextField(controller: _qty, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: t('quantity'))),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final price = double.tryParse(_price.text) ?? 0;
                final qty = double.tryParse(_qty.text) ?? 0;
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final offer = Offer(
                  id: id,
                  type: _type,
                  product: _product.text,
                  unit: _unit.text,
                  pricePerUnit: price,
                  quantityTotal: qty,
                  quantityRemaining: qty,
                );
                await context.read<Repository>().addOffer(offer);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('offer_added'))));
                  Navigator.pop(context);
                }
              },
              child: Text(t('add')),
            )
          ],
        ),
      ),
    );
  }
}
