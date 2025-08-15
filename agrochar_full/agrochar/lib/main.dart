import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart' as fo;
import 'services/repository_provider.dart';
import 'services/repository.dart';
import 'pages/splash_page.dart';
import 'pages/auth_gate.dart';
import 'l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: fo.DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // If firebase_options.dart is missing, app can still run with MockRepository.
  }
  runApp(const AgroCharApp());
}

class AgroCharApp extends StatefulWidget {
  const AgroCharApp({super.key});
  @override
  State<AgroCharApp> createState() => _AgroCharAppState();
}

class _AgroCharAppState extends State<AgroCharApp> {
  final LocaleController _locale = LocaleController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>.value(value: _locale),
        Provider<Repository>(create: (_) => provideRepository()),
      ],
      child: Consumer<LocaleController>(builder: (context, loc, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AgroChar',
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            useMaterial3: true,
          ),
          home: const SplashPage(next: AuthGate()),
        );
      }),
    );
  }
}
