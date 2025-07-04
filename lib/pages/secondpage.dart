import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/pages/frontpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory('f20586a7a2b95824572b1c10a1ca1257');
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName("Nigeria").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/drawer');
          },
          child: Icon(Icons.menu, color: Colors.white),
        ),
        title: Row(children: [Icon(Icons.location_on, color: Colors.red)]),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FrontPage()),
              );
            },
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // <- allows flexible height
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _locationHeader(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
                _dataTimeInfo(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                _weatherIcon(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                _currentTemp(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                _extraInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationHeader() {
    // ✅ renamed from _locationMeder
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dataTimeInfo() {
    DateTime now = _weather?.date?.toLocal() ?? DateTime.now(); // ✅ null-safe
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WeatherIconAnimation(
          iconUrl:
              "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.25,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "Humidity: ${_weather?.humidity?.toString()}%",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherIconAnimation extends StatefulWidget {
  final String iconUrl;

  // 🔹 Removed super.key from here
  const _WeatherIconAnimation({required this.iconUrl});

  @override
  State<_WeatherIconAnimation> createState() => _WeatherIconAnimationState();
}

class _WeatherIconAnimationState extends State<_WeatherIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: Image.network(
        widget.iconUrl,
        height: MediaQuery.sizeOf(context).height * 0.20,
        fit: BoxFit.contain,
      ),
    );
  }
}
