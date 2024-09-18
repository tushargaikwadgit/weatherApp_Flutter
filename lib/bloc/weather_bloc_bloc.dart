import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/model/my_data.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBloc() : super(WeatherBlocInitial()) {
    on<FetchWeatherApi>(_fetchApi);
    on<RefreshApp>(_refreshApp);
  }

  Future<void> _fetchApi(
      FetchWeatherApi event, Emitter<WeatherBlocState> emit) async {
    emit(WeatherBlocLoading());
    try {
      WeatherFactory wf = WeatherFactory(apiKey, language: Language.ENGLISH);
      Weather weather = await wf.currentWeatherByLocation(
          event.position.latitude, event.position.longitude);
      emit(WeatherBlocSuccess(weather: weather));
    } catch (e) {
      emit(WeatherBlocFailed());
    }
  }

  Future<void> _refreshApp(
      RefreshApp event, Emitter<WeatherBlocState> emit) async {
    emit(WeatherBlocLoading());
    try {
      WeatherFactory wf = WeatherFactory(apiKey, language: Language.ENGLISH);
      Weather weather = await wf.currentWeatherByLocation(
          event.position.latitude, event.position.longitude);
      emit(WeatherBlocSuccess(weather: weather));
    } catch (e) {
      emit(WeatherBlocFailed());
    }
  }
}
