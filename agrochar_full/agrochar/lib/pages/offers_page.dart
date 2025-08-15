import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/offer.dart';
import '../services/repository.dart';
import '../widgets/offer_card.dart';

enum OfferListType { sell, buy }

class OffersPage extends StatelessWidget {
  final OfferListType type;
  const OffersPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<Repository>();
    final isSell = type == OfferListType.sell;
    final t = context.read<LocaleController>().t;

    return Scaffold(
      appBar: AppBar(title: Text(isSell ? t('sell_offers') : t('buy_offers'))),
      body: StreamBuilder(
        stream: repo.offers(isSell ? OfferType.sell : OfferType.buy),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final items = snap.data as List<Offer>;
          if (items.isEmpty) return const Center(child: Text('No data'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (_, i) => OfferCard(offer: items[i]),
          );
        },
      ),
    );
  }
}
