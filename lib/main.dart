import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/auth/view/auth_gate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuickSlotApp());
}

/// Temporary bootstrap shell. Replaced by the real App widget (theme,
/// providers, router) once feature code is added.
class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QuickSlot',
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
