import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_monitor_provider.g.dart';

@Riverpod(keepAlive: true)
class DeviceMonitor extends _$DeviceMonitor {
  Timer? _refreshTimer;

  @override
  void build() {
    ref.onDispose(() {
      _refreshTimer?.cancel();
    });

    return;
  }

  void stopMonitoring() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
