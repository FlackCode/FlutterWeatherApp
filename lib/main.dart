import 'package:flutter/material.dart';
import 'package:flutterweatherapp/pages/home_page.dart';
import 'package:flutterweatherapp/services/weather_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherService>(
      create: (context) => WeatherService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
