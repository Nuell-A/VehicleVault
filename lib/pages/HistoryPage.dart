import 'package:flutter/material.dart';
import 'package:maintenance_tracker/components/HistoryComponent.dart';
import 'package:maintenance_tracker/database/Database.dart';
import 'package:maintenance_tracker/models/History.dart';


class HistoryPage extends StatefulWidget {
  final String vehicelId;
  const HistoryPage(this.vehicelId, {super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // initState override needed to grab vehicleId from widget.
  String vehicleId = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      vehicleId = widget.vehicelId;
    });
  }

  // Dialog when user wants to add new entry.
  void _showHistoryDialog(context) {
    // Controllers for adding a new history record.
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController milesController = TextEditingController();
    TextEditingController jobDescriptionController = TextEditingController();
    DateTime? date;

    showDialog(context: context, builder: (BuildContext context) {
      // StatefulBuilder used to update UI properly. Without it, date variable updates but is not shown on UI so user can't tell.
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text("Add A New Record"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Job title input
                TextFormField(
                  controller: jobTitleController,
                  decoration: const InputDecoration(labelText: "Job Title"),
                ),
                // Date input
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        // Date picker
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        // Sets date var within dialog state
                        if (selectedDate != null) {
                          setDialogState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      // Checks if date is null else it shows the selected date.
                      child: Text(
                        date == null
                            ? "Select Date"
                            : "${date!.day}/${date!.month}/${date!.year}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                // Miles input
                TextFormField(
                  controller: milesController,
                  decoration: const InputDecoration(labelText: "Miles"),
                ),
                // Description input
                TextFormField(
                  controller: jobDescriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
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
                child: const Text('Add Record'),
                onPressed: () async {
                  // Get the input values
                  String jobTitle = jobTitleController.text;
                  int miles = int.tryParse(milesController.text) ?? 0;
                  String jobDescription = jobDescriptionController.text;

                  // Check if date is selected
                  if (date == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a date')),
                    );
                    return;
                  }

                  // Adds vehicle to database.
                  Database().addHistory(vehicleId,
                      jobTitle: jobTitle,
                      date: date!,
                      miles: miles,
                      jobDescription: jobDescription);

                  // Close the dialog
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: StreamBuilder<List<History>>(
                  // Gets history stream
                  stream: Database().getHistoryStream(vehicleId),
                  builder: (context, snapshot) {
                    // Checks for errors, awaiting and if the list is empty.
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<History> historyDb = snapshot.data ?? [];

                    if (historyDb.isEmpty) {
                      return const Center(child: Text('No history added yet'));
                    }
                    historyDb.sort((a, b) => b.date.compareTo(a.date));
                    // List of history records.
                    return ListView.builder(
                      itemCount: historyDb.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        return HistoryComponent(
                          jobTitle: historyDb[index].jobTitle,
                          datenow: historyDb[index].date,
                          miles: historyDb[index].miles,
                          jobDescription: historyDb[index].jobDescription,
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
            onPressed: () => _showHistoryDialog(context),
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