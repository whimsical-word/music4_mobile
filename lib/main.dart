import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: Music4App(),
    ),
  );
}

class Music4App extends StatelessWidget {
  const Music4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Music4',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
