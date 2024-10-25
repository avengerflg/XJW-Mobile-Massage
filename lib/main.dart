import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart'; // Import the Login Screen
import 'screens/profile_screen.dart'; // Import the Profile Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XJW Mobile Massage',
      theme: ThemeData(
        primaryColor: const Color(0xFF3B5998), // Matching color from logo
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF4A4A4A), // Complementary accent color
        ),
      ),
      debugShowCheckedModeBanner: false, // Disable the debug banner.
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) =>
            const SplashScreen(), // Splash screen as the initial route
        '/login': (context) => const LoginScreen(), // Login screen route
        '/profile': (context) => const ProfileScreen(
            userId: '1'), // Profile screen route with sample user ID
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
