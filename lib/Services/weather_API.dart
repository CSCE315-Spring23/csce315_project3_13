
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class weather_API
{
  String access_key="f11d0823164b1fdf85a880a2f1e7de52";

  //Future<http.Response> get_weather_data()
  Future<void> get_user_city() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${access_key}&units=imperial"));
    Map<String, dynamic> json = jsonDecode(response.body);
    double temperature = json['main']['temp'];
    print("temperature: $temperature");
  }
}