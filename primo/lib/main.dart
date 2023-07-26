import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CurrentWeather> fetchMeteo() async {
  final response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=41.9027835&longitude=12.4963655&hourly=temperature_2m&current_weather=true'));
  if (response.statusCode == 200) {
    print("hello");
    return CurrentWeather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load meteo');
  }
}

class CurrentWeather {
  final double? temperature;
  final double? windSpeed;

  const CurrentWeather({this.temperature, this.windSpeed});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['current_weather']['temperature']?.toDouble(),
      windSpeed: json['current_weather']['windspeed']?.toDouble(),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<CurrentWeather> futureMeteo;

  @override
  void initState() {
    super.initState();
    futureMeteo= fetchMeteo();
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.yellow)),
        centerTitle: true,
        leading: Icon(Icons.search, color: Colors.yellow)
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            FutureBuilder<CurrentWeather>(
              future: futureMeteo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data!.temperature}'+'°',
                      style: TextStyle(
                          fontSize: 90,
                          shadows: [
                            Shadow(
                                offset: Offset(5.0,5.0),
                                blurRadius: 10.0,
                                color: Color.fromARGB(128, 128, 128, 128)
                            )
                          ]
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
            children: <Widget>[
                Icon(Icons.wind_power),
              FutureBuilder<CurrentWeather>(
                future: futureMeteo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String windSpeedString = "${snapshot.data!.windSpeed} m/s";
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          windSpeedString,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ]
                ),
                Icon(Icons.sunny),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.cloud),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}