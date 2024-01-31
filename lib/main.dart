import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _weather = 'Loading...';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';

  @override
  void initState() {
    super.initState();
    _updateWeather();
  }

  Future<void> _updateWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=c36d00a1ade6f97e5f7d9861c3dff92c'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String weather = data['weather'][0]['description'];
      String city = data['name'];
      print(data);

      setState(() {
        _weather = weather;
        _latitude = position.latitude;
        _longitude = position.longitude;
        _city = city;
      });
    } else {
      setState(() {
        _weather = 'Failed to load weather data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String locationImage =
        'https://maps.googleapis.com/maps/api/staticmap?center=$_latitude,$_longitude=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$_latitude,$_longitude&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Weather: $_weather'),
            SizedBox(height: 20),
            Text('Latitude: $_latitude'),
            Text('Longitude: $_longitude'),
            Text('City: $_city'),
            Image.network(
              locationImage,
              width: 300,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
