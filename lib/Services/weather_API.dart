
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class weather_API
{
  String access_key="f11d0823164b1fdf85a880a2f1e7de52";

  //Future<http.Response> get_weather_data()
  Future<String> get_temperature() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${access_key}&units=imperial"));
    Map<String, dynamic> json = jsonDecode(response.body);
    int temperature = json['main']['temp'].round();
    String temp = temperature.toString() + "°F";
    return temp;
  }

  Future<String> get_condition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${access_key}&units=imperial"));
    Map<String, dynamic> json = jsonDecode(response.body);
    String condition = json['weather'][0]['main'];
    return condition;
  }
}