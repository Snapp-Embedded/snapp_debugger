import 'package:snapp_cli/configs/embedder.dart';
import 'package:snapp_cli/host_runner/host_runner_platform.dart';
import 'package:snapp_cli/service/custom_device_builder/src/flutter.dart';
import 'package:snapp_cli/service/custom_device_builder/src/flutter_pi.dart';
import 'package:snapp_cli/service/custom_device_builder/src/homescreen.dart';
import 'package:snapp_cli/service/setup_device/device_config_context.dart';
import 'package:snapp_cli/service/setup_device/device_setup.dart';
// ignore: implementation_imports
import 'package:flutter_tools/src/custom_devices/custom_device_config.dart';
import 'package:snapp_cli/snapp_cli.dart';

abstract class CustomDeviceBuilder {
  const CustomDeviceBuilder({
    required this.flutterSdkManager,
    required this.hostPlatform,
  });

  factory CustomDeviceBuilder.create({
    required FlutterEmbedder embedder,
    required FlutterSdkManager flutterSdkManager,
    required HostRunnerPlatform hostPlatform,
  }) {
    switch (embedder) {
      case FlutterEmbedder.flutter:
        return FlutterCustomDeviceBuilder(
          flutterSdkManager: flutterSdkManager,
          hostPlatform: hostPlatform,
        );

      case FlutterEmbedder.flutterPi:
        return FlutterPiCustomDeviceBuilder(
          flutterSdkManager: flutterSdkManager,
          hostPlatform: hostPlatform,
        );
      case FlutterEmbedder.iviHomescreen:
        return HomescreenCustomDeviceBuilder(
          flutterSdkManager: flutterSdkManager,
          hostPlatform: hostPlatform,
        );
    }
  }

  final FlutterSdkManager flutterSdkManager;
  final HostRunnerPlatform hostPlatform;

  Future<CustomDeviceConfig> buildDevice(
    final DeviceConfigContext context,
  );

  bool isContextValid(DeviceConfigContext context) {
    return context.id != null &&
        context.label != null &&
        context.targetIp != null &&
        context.username != null &&
        context.remoteHasSshConnection &&
        context.appExecuterPath != null;
  }
}
