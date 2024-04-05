import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/openweathermap_api.dart';

final _dateFormatter = DateFormat.MMMMEEEEd();
final _hourFormatter = DateFormat.Hm();

String _formatTemp(double value) {
  return '${((value * 10).round() / 10)}°C';
}

String _formatSpeed(double value) {
  return '${value.round()} km/h';
}

String _capitalize(String value) {
  return value[0].toUpperCase() + value.substring(1);
}

class WeatherBlock extends StatelessWidget {
  const WeatherBlock(this.weather, {super.key});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  context.read<OpenWeatherMapApi>().getIconUrl(
                        weather.icon,
                        OpenWeatherMapIconSize.large,
                      ),
                ),
                Column(
                  children: [
                    Text(
                      _capitalize(weather.description),
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTemp(weather.temperature),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatSpeed(weather.windSpeed),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTemp(weather.temperatureMin),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.blue.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('|'),
                ),
                Text(
                  _formatTemp(weather.temperatureMax),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.red.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherTile extends StatelessWidget {
  const WeatherTile(this.weather, {super.key});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 128,
            maxWidth: 160,
          ),
          child: Column(
            children: [
              Text(_dateFormatter.format(weather.dateTime)),
              Text(_hourFormatter.format(weather.dateTime)),
              const Spacer(flex: 1),
              Image.network(
                context.read<OpenWeatherMapApi>().getIconUrl(
                      weather.icon,
                      OpenWeatherMapIconSize.medium,
                    ),
              ),
              Text(
                _capitalize(weather.description),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTemp(weather.temperatureMin),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('|'),
                  ),
                  Text(
                    _formatSpeed(weather.windSpeed),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
