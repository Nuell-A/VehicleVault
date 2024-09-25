import 'package:flutter/material.dart';
import 'package:maintenance_tracker/components/CardComponent.dart';
import 'package:maintenance_tracker/database/Database.dart';
import 'package:maintenance_tracker/models/Vehicle.dart';


class VehiclePage extends StatefulWidget {
  // Constructor with title, used to identify which vehicle was tapped.
  final String vehicelId;
  const VehiclePage(this.vehicelId, {super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // Map to hold vehicle data.
  Vehicle vehicleData = Vehicle(id: "n/a", vehicleName: "n/a", year: 9999, miles: 9999, description: 'Please reload.');

  // initState override needed to grab title from widget.
  @override
  void initState() {
    super.initState();
    _findVehicle();
  }

  Future<void> _findVehicle() async {
    Vehicle vehicle = await Database().findVehicle(widget.vehicelId);
    setState(() {
      vehicleData = vehicle;
    });
  }

  // Returns CardComponent for display.
  @override
  Widget build(BuildContext context) {
    return CardComponent(
      title: vehicleData.vehicleName, 
      year: vehicleData.year, 
      image: 'lib/assets/2023-nissan-frontier-pro-4x.jpg', 
      description: vehicleData.description,
      showDescription: true,
      );
  }
}