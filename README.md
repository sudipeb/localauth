# Flutter Local Authentication

A Flutter app demonstrating **secure local authentication** using **Face ID, Touch ID, and Android fingerprint**.  
The app shows a **loading spinner on launch**, triggers biometric authentication, and navigates to the main screen only after successful authentication.  

---

## Features

- **Cross-platform support**: iOS (Face ID / Touch ID) and Android (Fingerprint / PIN / Pattern)  
- **Passcode fallback** when biometrics are unavailable  
- **Handles user cancellation gracefully**  
- Fully integrated with Flutter widgets and navigation  

---

## Screenshots

| iOS Face ID | Android Fingerprint |
|-------------|-------------------|
| ![ios_face_id](screenshots/ios_face_id.png) | ![android_fingerprint](screenshots/android_fingerprint.png) |

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0  
- Xcode (for iOS)  
- Android Studio or VS Code with Android SDK
- local_auth:^2.2.0  

---

## Clone the repository
    git clone https://github.com/yourusername/localauth-flutter.git
    cd localauth-flutter
    flutter pub get
## IOS Setup for Biometrics 
- To enable Face ID or Touch ID authentication in your iOS app, follow these steps:
### 1. Update `Info.plist` Open `ios/Runner/Info.plist` and add the following:
    <key>NSFaceIDUsageDescription</key>
    <string>Authenticate using Face ID or Touch ID</string> correct the structure  
### 2.Ensure Device Has Biometrics Enrolled
- Face ID: Go to Settings → Face ID & Passcode
- Touch ID: Go to Settings → Touch ID & Passcode
### 3. Use a real device for testing.
- Simulator can simulate biometrics via Features → Face ID / Touch ID.
## Android Setup for Biometrics
### 1. Add the permission in `android/app/src/main/AndroidManifest.xml`:
    <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
### 2. Ensure the device has screen lock and fingerprint enrolled.
### 3. Update MainActivity to extend FlutterFragmentActivity:
    import io.flutter.embedding.android.FlutterFragmentActivity
    class MainActivity: FlutterFragmentActivity() { 
    }
## Code Implementation
 ### Auth Service
    class PerformAppAuthentication {
    static final LocalAuthentication localAuth = LocalAuthentication();

    static Future<bool> authenticate() async {
    try {
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;

      final available = await localAuth.getAvailableBiometrics();
      debugPrint('Available biometrics: $available');

      if (!isSupported) return false;

      return await localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Auth error: ${e.code}');
      return false;
    }
    }
    }
### Add an gate
    class AuthGate extends StatefulWidget {
    const AuthGate({super.key});

    @override
    State<AuthGate> createState() => _AuthGateState();
    }

    class _AuthGateState extends State<AuthGate> {
    @override
    void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500)); // for Android window attach
      _authenticate();
    });
    }

    Future<void> _authenticate() async {
    final isAuthenticated = await PerformAppAuthentication.authenticate();

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
    }

    @override
    Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
    }
    }


