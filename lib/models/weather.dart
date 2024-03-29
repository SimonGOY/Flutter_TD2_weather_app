class Weather {
  Weather({
    required this.main,
    required this.desc,
    required this.icon,
    required this.temp,
  });

  final String main;
  final String desc;
  final String icon;
  final double temp;

Weather.fromJson(Map<String, dynamic> json)
    : this(
          main: json['weather'][0]['main'] as String,
          desc: json['weather'][0]['description'] as String,
          icon: json['weather'][0]['icon'] as String,
          temp: json['main']['temp'] as double
        );

}
