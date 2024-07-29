import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Import the package
import 'package:qr_app/splash_screen.dart'; // Import your HomeScreen

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(MyApp());
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove(); // Remove splash screen after 2 seconds
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Main application screen
    );
  }
}
