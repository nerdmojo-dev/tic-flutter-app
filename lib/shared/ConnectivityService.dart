import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> start(Future<void> Function() onConnected) async {
    // Initial check
    final result = await Connectivity().checkConnectivity();

    if (!result.contains(ConnectivityResult.none)) {
      await onConnected();
    }

    // Listen for future changes
    _subscription = Connectivity().onConnectivityChanged.listen((results) async {
      if (!results.contains(ConnectivityResult.none)) {
        await onConnected();
      }
    });
  }


  void dispose() {
    _subscription?.cancel();
  }
}