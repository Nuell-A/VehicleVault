import 'package:flutter/material.dart';
import 'package:maintenance_tracker/components/ScheduleComponent.dart';
import 'package:maintenance_tracker/database/Database.dart';
import 'package:maintenance_tracker/models/ScheduleJob.dart';

class SchedulePage extends StatefulWidget {
  final String vehicleId;
  const SchedulePage(this.vehicleId, {super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String vehicleId = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      vehicleId = widget.vehicleId;
    });
  }

  // Dialog when user wants to add new entry.
  void _showDialog(context) {
    // Controllers for adding a new history record.
    TextEditingController titleController = TextEditingController();
    TextEditingController intervalController = TextEditingController();
    TextEditingController lastCompletedController = TextEditingController();
    TextEditingController dueAtController = TextEditingController();


    showDialog(context: context, builder: (BuildContext context) {
      // StatefulBuilder used to update UI properly. Without it, date variable updates but is not shown on UI so user can't tell.
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text("Add Scheduled Maintenance"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // title input
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                // Interval
                TextFormField(
                  controller: intervalController,
                  decoration: const InputDecoration(labelText: "Interval"),
                ),
                // Last completed
                TextFormField(
                  controller: lastCompletedController,
                  decoration: const InputDecoration(labelText: "Last Completed"),
                ),
                // Due at
                TextFormField(
                  controller: dueAtController,
                  decoration: const InputDecoration(labelText: "Due At"),
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
              // Add scheduled job button
              ElevatedButton(
                child: const Text('Add New Job'),
                onPressed: () async {
                  // Get the input values
                  String title = titleController.text;
                  int interval = int.tryParse(intervalController.text) ?? 0;
                  int lastCompleted = int.tryParse(lastCompletedController.text) ?? 0;
                  int dueAt = int.tryParse(dueAtController.text) ?? 0;

                  // Adds new scheduled job to maintenance schedule.
                  Database().addScheduledJob(
                    vehicleId, 
                    title: title, 
                    interval: interval, 
                    lastCompleted: lastCompleted, 
                    dueAt: dueAt);

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
                child: StreamBuilder<List<ScheduleJob>>(
                  // Gets history stream
                  stream: Database().getScheduledJobsStream(vehicleId),
                  builder: (context, snapshot) {
                    // Checks for errors, awaiting and if the list is empty.
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<ScheduleJob> scheduledJobs = snapshot.data ?? [];

                    if (scheduledJobs.isEmpty) {
                      return const Center(child: Text('No history added yet'));
                    }
                    scheduledJobs.sort((a, b) => a.interval.compareTo(b.interval));
                    // List of history records.
                    return ListView.builder(
                      itemCount: scheduledJobs.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        return ScheduleComponent(
                          title: scheduledJobs[index].title,
                          interval: scheduledJobs[index].interval,
                          lastCompleted: scheduledJobs[index].lastCompleted,
                          dueAt: scheduledJobs[index].dueAt,
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
            onPressed: () => _showDialog(context),
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