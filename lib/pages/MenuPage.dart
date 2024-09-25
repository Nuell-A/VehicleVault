import 'package:flutter/material.dart';
import 'package:maintenance_tracker/components/Navigation.dart';
import 'package:maintenance_tracker/pages/HistoryPage.dart';
import 'package:maintenance_tracker/pages/SchedulePage.dart';
import 'package:maintenance_tracker/pages/VehiclePage.dart';

class MenuPage extends StatefulWidget {
  final String vehicelId;
  const MenuPage(this.vehicelId, {super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late TabItem _currentTab; // Bottom navigation
  late final String vehicelId; // Current vehicle 

  // Initialize current tab and vehicle.
  @override
  void initState() {
    super.initState();
    vehicelId = widget.vehicelId;
    _currentTab = TabItem.Vehicle;
  }

  // Used to update current screen/tab.
  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  Widget _buildBody() { // STATE MACHINE
    switch (_currentTab) {
      case TabItem.History:
        return HistoryPage(vehicelId);
      case TabItem.Vehicle:
        return VehiclePage(vehicelId);
      case TabItem.Schedule:
        return SchedulePage(vehicelId);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3A3F40),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: AppBar(
            title: const Text("Vehicle"),
            centerTitle: true,
            backgroundColor: const Color(0xff47777D),
          ),
        ),
      ),
      body: _buildBody(),
      // Bottom navigation is completed with a combination of Padding, ClipRRect, and BottomNavigationBar
      bottomNavigationBar: Padding( // Padding to create space for floating effect
        padding: const EdgeInsets.all(15),
        child: ClipRRect( // ClipRRect to round all edges.
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: BottomNavigationBar( // Creates navigation items and hides labels. 
            unselectedItemColor: Colors.white,
            
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: const Color(0xff585858),
            selectedItemColor: const Color(0xff1D192B),
            currentIndex: _currentTab.index,
            onTap: (index) => _selectTab(TabItem.values[index]),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History"
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.car_rental),
                label: "Vehicle"
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: "Schedule"
              )
            ]
          ),
        ),
      )   
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