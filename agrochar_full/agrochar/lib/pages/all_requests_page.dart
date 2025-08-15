import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';
import '../models/request_item.dart';
import '../services/repository.dart';
import '../widgets/request_card.dart';

class AllRequestsPage extends StatefulWidget {
  const AllRequestsPage({super.key});

  @override
  State<AllRequestsPage> createState() => _AllRequestsPageState();
}

class _AllRequestsPageState extends State<AllRequestsPage> {
  String _type = 'all'; // all/sell/buy
  String _query = '';
  double? _minRemaining;

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
    final repo = context.read<Repository>();

    return Scaffold(
      appBar: AppBar(title: Text(t('all_requests'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DropdownButton<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'sell', child: Text('Sell')),
                    DropdownMenuItem(value: 'buy', child: Text('Buy')),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? 'all'),
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Search product'),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Min remaining'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => setState(() => _minRemaining = double.tryParse(v)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<RequestItem>>(
              stream: _type == 'sell'
                  ? repo.requests(RequestType.sell)
                  : _type == 'buy'
                      ? repo.requests(RequestType.buy)
                      : _merge(repo.requests(RequestType.sell), repo.requests(RequestType.buy)),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                var items = snap.data!;
                if (_query.isNotEmpty) {
                  final q = _query.toLowerCase();
                  items = items.where((r) => r.product.toLowerCase().contains(q)).toList();
                }
                if (_minRemaining != null) {
                  items = items.where((r) => r.quantityRemaining >= _minRemaining!).toList();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (_, i) => RequestCard(item: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Stream<List<RequestItem>> _merge(Stream<List<RequestItem>> a, Stream<List<RequestItem>> b) {
  // Simple combine: we listen to both and emit concatenated lists.
  // For production use RxDart or similar; here keep lightweight.
  late StreamController<List<RequestItem>> ctl;
  List<RequestItem> la = const [];
  List<RequestItem> lb = const [];
  ctl = StreamController<List<RequestItem>>.broadcast(onListen: () {
    a.listen((v) { la = v; ctl.add([...la, ...lb]); });
    b.listen((v) { lb = v; ctl.add([...la, ...lb]); });
  });
  return ctl.stream;
}
