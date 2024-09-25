import "package:flutter/material.dart";

class ScheduleComponent extends StatelessWidget {
  final String title;
  final int interval;
  final int lastCompleted;
  final int dueAt;

  const ScheduleComponent({super.key, required this.title, required this.interval, required this.lastCompleted, required this.dueAt});

  // Custom Card layout. 
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      margin: const EdgeInsets.all(15),
      child: Column(
        children: <Widget> [
          // Title
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              title, 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
            ),
          ),

          // dueAt
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Due at: $dueAt miles", 
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 22, 83, 99)
              )
            ),
          ),

          // last completed
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Last Completed at: $lastCompleted miles", 
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 48, 48, 48)
              )
            ),
          ),

          // Interval
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Interval: $interval miles", 
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 48, 48, 48)
              )
            ),
          ),
        ],
      ),
    );
  }
}