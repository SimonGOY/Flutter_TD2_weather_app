class Weather {
  Weather({
    required this.condition,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.windSpeed,
    required this.dateTime,
  });

  final String condition;
  final String description;
  final String icon;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final double windSpeed;
  final DateTime dateTime;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0] as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    return Weather(
      condition: weather['main'] as String,
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      temperature: main['temp'].toDouble(),
      temperatureMin: main['temp_min'].toDouble(),
      temperatureMax: main['temp_max'].toDouble(),
      windSpeed: wind['speed'].toDouble() * 3.6, // m/s en km/h
      dateTime: DateTime.fromMicrosecondsSinceEpoch(
        (json['dt'] as int) * 1000000,
      ),
    );
  }
}
