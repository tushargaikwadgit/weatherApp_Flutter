import 'dart:ui';
import '../utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  Future<void> _refreshWeather() async {
    try {
      Position position = await LocationUtils.determinePosition();
      context.read<WeatherBloc>().add(RefreshApp(position));
    } catch (e) {}
  }

  Widget getWeatherIcon(int code) {
    if (code >= 200 && code < 300) {
      return Image.asset("lib/assets/images/1.png");
    } else if (code >= 300 && code < 400) {
      return Image.asset("lib/assets/images/2.png");
    } else if (code >= 500 && code < 600) {
      return Image.asset("lib/assets/images/3.png");
    } else if (code >= 600 && code < 700) {
      return Image.asset("lib/assets/images/4.png");
    } else if (code >= 700 && code < 800) {
      return Image.asset("lib/assets/images/5.png");
    } else if (code == 800) {
      return Image.asset("lib/assets/images/6.png");
    } else if (code >= 801 && code <= 804) {
      return Image.asset("lib/assets/images/7.png");
    } else {
      return Image.asset("lib/assets/images/7.png"); // Default case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshWeather(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(3, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF673AB7)),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-3, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF673AB7)),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -1.2),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFAB40),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 100.0,
                        sigmaY: 100.0,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    BlocBuilder<WeatherBloc, WeatherBlocState>(
                      builder: (context, state) {
                        if (state is WeatherBlocSuccess) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 50),
                                Text(
                                  "📍 ${state.weather.areaName}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),

                                const SizedBox(height: 10),
                                const Text(
                                  "Good Morning",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                getWeatherIcon(
                                    state.weather.weatherConditionCode!),
                                Center(
                                  child: Text(
                                    "${state.weather.temperature!.celsius!.round()}°C",
                                    style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    state.weather.weatherMain!.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    DateFormat('EEEE dd .')
                                        .add_jm()
                                        .format(state.weather.date!),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "lib/assets/images/11.png",
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Sunrise",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunrise!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "lib/assets/images/12.png",
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Sunset",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunset!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "lib/assets/images/13.png",
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Temp Max",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              '${state.weather.tempMax!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "lib/assets/images/14.png",
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Temp Min",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              '${state.weather.tempMin!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





// RefreshIndicator(
//         onRefresh: () => _refreshWeather(),
//         child: CustomScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: const AlignmentDirectional(3, -0.3),
//                         child: Container(
//                           height: 300,
//                           width: 300,
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: Color(0xFF673AB7)),
//                         ),
//                       ),
//                       Align(
//                         alignment: const AlignmentDirectional(-3, -0.3),
//                         child: Container(
//                           height: 300,
//                           width: 300,
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle, color: Color(0xFF673AB7)),
//                         ),
//                       ),
//                       Align(
//                         alignment: const AlignmentDirectional(0, -1.2),
//                         child: Container(
//                           height: 300,
//                           width: 300,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color(0xFFFFAB40),
//                           ),
//                         ),
//                       ),
//                       BackdropFilter(
//                         filter: ImageFilter.blur(
//                           sigmaX: 100.0,
//                           sigmaY: 100.0,
//                         ),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.transparent,
//                           ),
//                         ),
//                       ),
//                       BlocBuilder<WeatherBloc, WeatherBlocState>(
//                         builder: (context, state) {
//                           if (state is WeatherBlocSuccess) {
//                             return SizedBox(
//                               height: MediaQuery.of(context).size.height,
//                               width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // const SizedBox(height: 50),
//                                   Text(
//                                     "📍 ${state.weather.areaName}",
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 15),
//                                   ),

//                                   const SizedBox(height: 10),
//                                   const Text(
//                                     "Good Morning",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   getWeatherIcon(
//                                       state.weather.weatherConditionCode!),
//                                   Center(
//                                     child: Text(
//                                       "${state.weather.temperature!.celsius!.round()}°C",
//                                       style: const TextStyle(
//                                         fontSize: 55,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   Center(
//                                     child: Text(
//                                       state.weather.weatherMain!.toUpperCase(),
//                                       style: const TextStyle(
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   Center(
//                                     child: Text(
//                                       DateFormat('EEEE dd .')
//                                           .add_jm()
//                                           .format(state.weather.date!),
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w300,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 40),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "lib/assets/images/11.png",
//                                             scale: 8,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Sunrise",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w300,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 3),
//                                               Text(
//                                                 DateFormat().add_jm().format(
//                                                     state.weather.sunrise!),
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "lib/assets/images/12.png",
//                                             scale: 8,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Sunset",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w300,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 3),
//                                               Text(
//                                                 DateFormat().add_jm().format(
//                                                     state.weather.sunset!),
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 5.0),
//                                     child: Divider(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "lib/assets/images/13.png",
//                                             scale: 8,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Temp Max",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w300,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 3),
//                                               Text(
//                                                 '${state.weather.tempMax!.celsius!.round()}°C',
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             "lib/assets/images/14.png",
//                                             scale: 8,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Temp Min",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w300,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 3),
//                                               Text(
//                                                 '${state.weather.tempMin!.celsius!.round()}°C',
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),