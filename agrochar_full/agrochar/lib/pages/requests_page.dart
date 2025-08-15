import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/request_item.dart';
import '../services/repository.dart';
import '../widgets/request_card.dart';

enum RequestListType { sell, buy }

class RequestsPage extends StatelessWidget {
  final RequestListType type;
  const RequestsPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<Repository>();
    final isSell = type == RequestListType.sell;
    final t = context.read<LocaleController>().t;

    return Scaffold(
      appBar: AppBar(title: Text(isSell ? t('sell_requests') : t('buy_requests'))),
      body: StreamBuilder(
        stream: repo.requests(isSell ? RequestType.sell : RequestType.buy),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final items = snap.data as List<RequestItem>;
          if (items.isEmpty) return const Center(child: Text('No data'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (_, i) => RequestCard(item: items[i]),
          );
        },
      ),
    );
  }
}
