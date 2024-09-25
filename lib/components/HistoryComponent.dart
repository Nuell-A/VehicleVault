import "package:flutter/material.dart";
import "package:intl/intl.dart";


class HistoryComponent extends StatelessWidget {
  final String jobTitle;
  final DateTime datenow;
  final int miles;
  final String jobDescription;

  const HistoryComponent({super.key, required this.jobTitle, required this.datenow, required this.miles, required this.jobDescription});

  // Custom Card layout. 
  @override
  Widget build(BuildContext context) {
    // Format date to show only year, month, and day
    String date = DateFormat('yyyy-MM-dd').format(datenow);

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
              jobTitle, 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
            ),
          ),

          // Subtitle (date and miles)
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "$date - $miles miles", 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey
              )
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              jobDescription, 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black
              )
            ),
          ),
        ],
      ),
    );
  }
}