import 'package:flutter/material.dart';
import 'package:maintenance_tracker/components/CardComponent.dart';
import 'package:maintenance_tracker/database/Database.dart';
import 'package:maintenance_tracker/models/Vehicle.dart';
import 'package:maintenance_tracker/pages/MenuPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>  HomePageState();
}

class  HomePageState extends State<HomePage> {

  // Vehicle dialog
  void _showVehicleDialog(BuildContext context) {
    TextEditingController vehicleNameController = TextEditingController();
    TextEditingController yearController = TextEditingController();
    TextEditingController milesController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add A Vehicle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Vehicle name input
            TextFormField(
              controller: vehicleNameController,
              decoration: const InputDecoration(labelText: "Vehicle Name"),
            ),
            // Year input
            TextFormField(
              controller: yearController,
              decoration: const InputDecoration(labelText: "Year"),
            ),
            // Miles input
            TextFormField(
              controller: milesController,
              decoration: const InputDecoration(labelText: "Miles"),
            ),
            // Description input
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description")
            ),
          ],
        ),
        actions: <Widget>[
          // Cancel button
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // Add vehicle button
          ElevatedButton(
            child: const Text('Add Vehicle'),
            onPressed: () async {
              // Get the input values
              String vehicleName = vehicleNameController.text;
              int year = int.tryParse(yearController.text) ?? 0;
              int miles = int.tryParse(milesController.text) ?? 0;
              String description = descriptionController.text;

              // Adds vehicle to database.
              Database().addVehicle(vehicleName: vehicleName, year: year, miles: miles, description: description);

              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stack used to have a floating action button.
    return Stack(
      children: <Widget>[
        // Main content
        Container(
          decoration: const BoxDecoration(
            color: Color(0xff3A3F40),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<Vehicle>>(
                  // Gets vehicle stream
                  stream: Database().getVehiclesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<Vehicle> vehiclesDb = snapshot.data ?? [];

                    if (vehiclesDb.isEmpty) {
                      return const Center(child: Text('No vehicles added yet'));
                    }

                    return ListView.builder(
                      itemCount: vehiclesDb.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuPage(vehiclesDb[index].id),
                              ),
                            );
                          },
                          child: CardComponent(
                            title: vehiclesDb[index].vehicleName,
                            year: vehiclesDb[index].year,
                            image: 'lib/assets/2023-nissan-frontier-pro-4x.jpg',
                            description: vehiclesDb[index].description,
                            showDescription: false,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Positioned ElevatedButton in the bottom-right corner
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () => _showVehicleDialog(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(), // Makes button circular
              backgroundColor: const Color(0xff47777D),
              foregroundColor: Colors.black
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}