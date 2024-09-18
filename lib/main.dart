import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/utils/location_util.dart';
import 'package:weather_app/utils/connectivity_service.dart';
import 'package:weather_app/view/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<bool>(
          stream: connectivityService.connectionStream,
          builder: (context, connectivitySnapshot) {
            if (connectivitySnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final isConnected = connectivitySnapshot.data ?? false;

            return FutureBuilder<Position>(
              future: LocationUtils.determinePosition(),
              builder: (context, locationSnapshot) {
                if (locationSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (locationSnapshot.hasData) {
                  if (!isConnected) {
                    return const Scaffold(
                      body: Center(
                        child:
                            Text("No internet connection! Please try again."),
                      ),
                    );
                  } else {
                    return BlocProvider<WeatherBloc>(
                      create: (context) => WeatherBloc()
                        ..add(FetchWeatherApi(locationSnapshot.data!)),
                      child: const HomeScreen(),
                    );
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: Text("Error occurred!"),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
