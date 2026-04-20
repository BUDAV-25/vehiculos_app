import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/catalog_provider.dart';
import 'data/services/catalogo_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(
          create: (_) => CatalogProvider(CatalogService()),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}