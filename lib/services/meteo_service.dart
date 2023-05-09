import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/models/meteo.dart';
import 'package:flutter/widgets.dart';

Future<Meteo?> cityRequest(cityEntries) async {
  List<Location> locations;
  print("cityRequest");
  print(cityEntries);
  if (cityEntries.runtimeType == String) {
    locations = await locationFromAddress(cityEntries);
  } else {
    locations = await locationFromAddress(cityEntries.text.toString());
  }

  Uri url = Uri.https("api.openweathermap.org", "/data/2.5/weather", {
    'lat': locations[0].latitude.toString(),
    'lon': locations[0].longitude.toString(),
    'units': 'metric',
    'lang': 'fr',
    'appid': '109e23b902d8a46b4fcca288e80abc1d'
  });
  Meteo currentMeteo = Meteo();

  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponde = jsonDecode(response.body);
    print(jsonResponde);

    currentMeteo = Meteo.fromJson(jsonResponde);
    return currentMeteo;
  } else {
    throw 'Failed to get data';
  }
}

Future<ForecastWeather> cityHourly(cityEntries) async {
  ForecastWeather futureMeteo = ForecastWeather();
  List<Location> locations;
  if (cityEntries.runtimeType == String) {
    locations = await locationFromAddress(cityEntries);
  } else {
    locations = await locationFromAddress(cityEntries.text.toString());
  }

  Uri url = Uri.https("api.openweathermap.org", "/data/2.5/forecast", {
    'lat': locations[0].latitude.toString(),
    'lon': locations[0].longitude.toString(),
    'units': 'metric',
    'lang': 'fr',
    'appid': '109e23b902d8a46b4fcca288e80abc1d'
  });

  print(url);

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponde = jsonDecode(response.body);
    print(jsonResponde);
    futureMeteo = ForecastWeather.fromJson(jsonResponde);
    return futureMeteo;
  } else {
    print('Failed to get data');
  }
  return futureMeteo;
}
