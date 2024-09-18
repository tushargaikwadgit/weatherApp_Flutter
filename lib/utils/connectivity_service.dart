import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  // Singleton instance
  static final ConnectivityService _instance = ConnectivityService._internal();
  ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final InternetConnection _internetConnection = InternetConnection();

  // Expose a Stream of connectivity status
  Stream<bool> get connectionStream async* {
    await for (final status in _internetConnection.onStatusChange) {
      yield status == InternetStatus.connected;
    }
  }
}
