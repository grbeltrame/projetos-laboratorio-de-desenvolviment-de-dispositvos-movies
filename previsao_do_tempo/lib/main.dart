import 'package:flutter/material.dart';
import 'home.dart';
import 'air.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/air') {
          final args = settings.arguments as Map<String, double?>;
          final latitude = args['latitude']!;
          final longitude = args['longitude']!;
          return MaterialPageRoute(
            builder: (context) => Air(latitude: latitude, longitude: longitude),
          );
        }
        return null;
      },
    );
  }
}
