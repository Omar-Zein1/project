import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import 'offers_page.dart';
import 'add_offer_page.dart';
import 'requests_page.dart';
import 'all_requests_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
        final tiles = [
      _Tile(t('sell_offers'), Icons.store, () => _go(context, const OffersPage(type: OfferListType.sell))),
      _Tile(t('buy_offers'), Icons.shopping_cart, () => _go(context, const OffersPage(type: OfferListType.buy))),
      _Tile(t('sell_requests'), Icons.outbox, () => _go(context, const RequestsPage(type: RequestListType.sell))),
      _Tile(t('buy_requests'), Icons.inbox, () => _go(context, const RequestsPage(type: RequestListType.buy))),
      _Tile(t('all_requests'), Icons.list_alt, () => _go(context, const AllRequestsPage())),
      _Tile(t('add_offer'), Icons.add_box, () => _go(context, const AddOfferPage())),
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text('AgroChar'),
        actions: [
          IconButton(onPressed: () => context.read<LocaleController>().toggle(), icon: const Icon(Icons.language)),
          IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: tiles.length,
        itemBuilder: (_, i) => _HomeCard(tile: tiles[i]),
      ),
    );
  }

  void _go(BuildContext ctx, Widget page) => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => page));
}

class _Tile { final String title; final IconData icon; final VoidCallback onTap; _Tile(this.title, this.icon, this.onTap); }

class _HomeCard extends StatelessWidget {
  final _Tile tile;
  const _HomeCard({required this.tile, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tile.onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tile.icon, size: 42),
              const SizedBox(height: 8),
              Text(tile.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
