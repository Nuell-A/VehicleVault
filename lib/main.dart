import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_tracker/pages/GaragePage.dart';


void main() async {
  // Init firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run app.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomHome(), // Using a cutsome widget. 
    );
  }
}

class CustomHome extends StatefulWidget {
  const CustomHome({super.key});

  @override
  State<CustomHome> createState() => _CustomHomeState();
}

class _CustomHomeState extends State<CustomHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3A3F40),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: AppBar(
            title: const Text("Garage"),
            centerTitle: true,
            backgroundColor: const Color(0xff47777D),
          ),
        ),
      ),
      body: HomePage(),
    );
  }
}

// Custom class for rounded corners on appbar.
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 30.0;

    // Start from the top left corner
    path.lineTo(0.0, size.height - radius);

    // Create a smooth curve at the bottom left corner
    path.quadraticBezierTo(0.0, size.height, radius, size.height);

    // Draw a line across the bottom
    path.lineTo(size.width - radius, size.height);

    // Create a smooth curve at the bottom right corner
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - radius);

    // Close the path at the top right corner
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}