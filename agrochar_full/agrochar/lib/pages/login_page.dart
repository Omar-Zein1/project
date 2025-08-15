import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _phone = TextEditingController();
  final _sms = TextEditingController();
  String? _verificationId;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final t = context.read<LocaleController>().t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('login')),
        actions: [
          IconButton(
            onPressed: () => context.read<LocaleController>().toggle(),
            icon: const Icon(Icons.language),
            tooltip: t('language'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(controller: _email, decoration: InputDecoration(labelText: t('email'))),
                    const SizedBox(height: 8),
                    TextField(controller: _pass, obscureText: true, decoration: InputDecoration(labelText: t('password'))),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loading ? null : () async {
                        setState(() => _loading = true);
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _pass.text);
                        } on FirebaseAuthException catch (_) {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _pass.text);
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                      child: Text(t('login')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(controller: _phone, decoration: InputDecoration(labelText: t('phone'))),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loading ? null : () async {
                        setState(() => _loading = true);
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: _phone.text,
                          verificationCompleted: (cred) async {
                            await FirebaseAuth.instance.signInWithCredential(cred);
                          },
                          verificationFailed: (e) { },
                          codeSent: (id, _) { setState(() { _verificationId = id; _loading = false; }); },
                          codeAutoRetrievalTimeout: (id) { _verificationId = id; },
                        );
                      },
                      child: Text(t('send_code')),
                    ),
                    const SizedBox(height: 8),
                    TextField(controller: _sms, decoration: const InputDecoration(labelText: 'SMS')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: (_verificationId == null || _loading) ? null : () async {
                        setState(() => _loading = true);
                        try {
                          final cred = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: _sms.text);
                          await FirebaseAuth.instance.signInWithCredential(cred);
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                      child: Text(t('verify')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
