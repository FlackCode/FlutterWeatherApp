import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:flutterweatherapp/consts.dart';

class WeatherService extends ChangeNotifier {
  late WeatherFactory _wf;
  late StreamController<Weather?> _weatherController;
  Weather? _currentWeather;

  WeatherService() {
    _wf = WeatherFactory(OPENWEATHER_API_KEY);
    _weatherController = StreamController<Weather?>();
  }

  Stream<Weather?> get weatherStream => _weatherController.stream;

  void fetchWeatherByCity(String city) {
    _wf.currentWeatherByCityName(city).then((weather) {
      _currentWeather = weather;
      _weatherController.add(_currentWeather);
    }).catchError((error) {
      print("Error fetching weather data: $error");
      _weatherController.addError("Error fetching weather data");
    });
  }

  void dispose() {
    super.dispose();
    _weatherController.close();
  }
}
