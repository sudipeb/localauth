import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class PerformAppAuthentication {
  static final LocalAuthentication localAuth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;

      debugPrint("isSupported: $isSupported");
      debugPrint("canCheck: $canCheck");
      debugPrint("available: ${await localAuth.getAvailableBiometrics()}");

      if (!isSupported) return false;

      return await localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true, useErrorDialogs: true),
      );
    } on PlatformException catch (e) {
      debugPrint("Auth error: ${e.code}");
      return false;
    }
  }
}
