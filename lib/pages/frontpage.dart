import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/pages/const.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final DateFormat formatDate = DateFormat.yMMMd();
  final DateFormat formatTime = DateFormat.jm();

  WeatherFactory? wf;
  List<Weather> forecastList = [];
  Position? currentPosition;
  String currentTime = '';
  bool isLoading = true;
  String cityName = 'Fetching location...';

  // Air quality variables
  double _airQualityValue = 50; // Default value
  String _airQualityStatus = 'Moderate';
  MaterialColor _airQualityColor = Colors.yellow;
  String _mainPollutantName = 'Carbon Monoxide';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    wf = WeatherFactory(OPEN_WEATHER_API_KEY, language: Language.ENGLISH);
    _updateCurrentTime();
    _getCurrentLocation();
    _initializeAirQuality();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeAirQuality() {
    // Set initial air quality values
    _updateAirQualityValues();

    // Update air quality periodically
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _updateAirQualityValues();
    });
  }

  void _updateAirQualityValues() {
    setState(() {
      if (_airQualityValue <= 30) {
        _airQualityStatus = 'Poor';
        _airQualityColor = Colors.red;
        _mainPollutantName = 'Ozone';
      } else if (_airQualityValue <= 50) {
        _airQualityStatus = 'Moderate';
        _airQualityColor = Colors.yellow;
        _mainPollutantName = 'Carbon Monoxide';
      } else {
        _airQualityStatus = 'Good';
        _airQualityColor = Colors.green;
        _mainPollutantName = 'Particulate matter 2.5';
      }
    });
  }

  IconData _getWeatherIcon(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  void _updateCurrentTime() {
    setState(() {
      currentTime = formatTime.format(DateTime.now());
    });
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        currentTime = formatTime.format(DateTime.now());
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    String? detectedCity;

    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      detectedCity = placemarks.first.locality;
      setState(() {
        currentPosition = position;
        cityName = detectedCity ?? 'Benin City';
      });
      await fetchForecast();
    } catch (e) {
      debugPrint('Error getting city: $e');
      debugPrint('Last detected city: $detectedCity');
      setState(() {
        cityName = detectedCity ?? 'Benin City';
      });
      await fetchForecast();
    }
  }

  Future<void> fetchForecast() async {
    try {
      List<Weather> data = await wf!.fiveDayForecastByCityName(cityName);

      Map<String, Weather> dailyForecast = {};
      for (var entry in data) {
        String dateKey = DateFormat('yyyy-MM-dd').format(entry.date!);
        if (!dailyForecast.containsKey(dateKey)) {
          dailyForecast[dateKey] = entry;
        }
      }

      setState(() {
        forecastList = dailyForecast.values.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching forecast: $e");
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _getCurrentLocation();
  }

  // ignore: unused_element
  String _pollutantNameAbrev(String pollutantCode) {
    switch (pollutantCode) {
      case 'PM2.5':
        return 'PM2.5';
      case 'PM10':
        return 'PM10';
      case 'O3':
        return 'NO3';
      case 'SO2':
        return 'SO2';
      case 'CO':
        return 'CO';
      default:
        return pollutantCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],

      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,

                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topCenter,
                      colors: [Colors.white, Color.fromARGB(255, 21, 100, 218)],
                    ),
                  ),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                            children: [
                              // Header Info
                              Text(
                                'Current Time: $currentTime',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (cityName.isNotEmpty)
                                Text(
                                  'Location: $cityName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // Forecast List
                              Column(
                                children: List.generate(forecastList.length, (
                                  index,
                                ) {
                                  final weather = forecastList[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Text(
                                          formatDate.format(
                                            weather.date ?? DateTime.now(),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              _getWeatherIcon(
                                                weather.weatherMain,
                                              ),
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              weather.weatherMain ?? 'N/A',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          '${weather.humidity}%',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                        trailing: Text(
                                          '${weather.tempMax?.celsius?.round() ?? '--'}° / ${weather.tempMin?.celsius?.round() ?? '--'}°',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Divider(color: Colors.white),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                ),

                // Air Quality Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, 21, 100, 218),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.air, size: 20, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'Air Quality',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(5),
                                minimumSize: const Size(4, 4),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Air Quality Info'),
                                        content: const Text(
                                          'This shows the current air quality index and main pollutants.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const Divider(
                          color: Colors.white,
                          thickness: 2,
                          height: 20,
                        ),

                        // Indicator
                        ListTile(
                          leading: Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              size: 35,
                              color: _airQualityColor,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                _airQualityValue.round().toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _airQualityStatus,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _airQualityColor,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Main pollutant: $_mainPollutantName',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Slider
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [Colors.red, Colors.yellow, Colors.green],
                            ).createShader(bounds);
                          },
                          child: Slider(
                            value: _airQualityValue,
                            min: 0,
                            max: 100,
                            divisions: 10,
                            label: _airQualityValue.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _airQualityValue = value;
                                _updateAirQualityValues();
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pollutants:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildPollutantColumn(
                                    'NO2',
                                    _airQualityValue * 0.6,
                                    getPollutantColor(_airQualityValue * 0.6),
                                  ),
                                  buildPollutantColumn(
                                    'O3',
                                    _airQualityValue * 0.3,
                                    getPollutantColor(_airQualityValue * 0.3),
                                  ),
                                  buildPollutantColumn(
                                    'PM10',
                                    _airQualityValue * 0.5,
                                    getPollutantColor(_airQualityValue * 0.5),
                                  ),
                                  buildPollutantColumn(
                                    'PM2.5',
                                    _airQualityValue,
                                    getPollutantColor(_airQualityValue),
                                  ),
                                  buildPollutantColumn(
                                    'CO',
                                    _airQualityValue * 0.2,
                                    getPollutantColor(_airQualityValue * 0.2),
                                  ),
                                  buildPollutantColumn(
                                    'SO2',
                                    _airQualityValue * 0.1,
                                    getPollutantColor(_airQualityValue * 0.1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPollutantColumn(String code, double value, Color color) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: value.clamp(0, 50),
          width: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: value.clamp(0, 45),
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(0),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

Color getPollutantColor(double value) {
  if (value > 50) return Colors.purple;
  if (value > 30) return Colors.orange;
  if (value > 20) return Colors.yellow;
  return Colors.green;
}
