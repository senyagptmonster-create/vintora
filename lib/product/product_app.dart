import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'vintora_store.dart';
import '../app/brand.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VintoraStore()..init(),
      child: MaterialApp(
        title: 'Vintora',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: cBg,
          appBarTheme: const AppBarTheme(backgroundColor: cSurface),
        ),
        home: const VintoraDashboardScreen(),
      ),
    );
  }
}
