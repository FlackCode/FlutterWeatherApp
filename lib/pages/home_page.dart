import 'package:flutter/material.dart';
import 'package:flutterweatherapp/services/weather_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Info',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            width: 200,
            height: 60,
            margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  hintText: 'Enter city...',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepOrange, width: 2.0))),
              style: const TextStyle(color: Colors.black),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Provider.of<WeatherService>(context, listen: false)
                      .fetchWeatherByCity(value);
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Builder(
            builder: (context) {
              final weatherService = Provider.of<WeatherService>(context);
              return StreamBuilder<Weather?>(
                stream: weatherService.weatherStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No data available');
                  }
                  return _buildWeatherUI(context, snapshot.data!);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherUI(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Text(
          weather.areaName ?? '',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        //_dateTimeInfo(weather),
        //const SizedBox(height: 20),
        _weatherIcon(context, weather),
        const SizedBox(height: 20),
        Text(
          '${weather.temperature?.celsius?.toStringAsFixed(0)}°C',
          style: const TextStyle(
            fontSize: 90,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        _extraInfo(context, weather),
      ],
    );
  }

  Widget _dateTimeInfo(Weather weather) {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Text(
          DateFormat('h:mm a').format(now!),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEEE').format(now),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon(BuildContext context, Weather weather) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${weather.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          weather.weatherDescription?.capitalizeFirstLetter() ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _extraInfo(BuildContext context, Weather weather) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${weather.tempMax?.celsius?.toStringAsFixed(0)}°C",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "Min: ${weather.tempMin?.celsius?.toStringAsFixed(0)}°C",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${(weather.windSpeed ?? 0 * 3.6).toStringAsFixed(0)} km/h",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "Humidity: ${weather.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
