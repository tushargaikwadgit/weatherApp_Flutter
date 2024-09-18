part of 'weather_bloc_bloc.dart';

abstract class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchWeatherApi extends WeatherBlocEvent {
  final Position position;
  const FetchWeatherApi(this.position);

  @override
  List<Object> get props => [position];
}

class RefreshApp extends WeatherBlocEvent {
  final Position position;
  const RefreshApp(this.position);

  @override
  List<Object> get props => [position];
}
