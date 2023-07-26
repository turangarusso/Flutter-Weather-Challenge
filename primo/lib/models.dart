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

