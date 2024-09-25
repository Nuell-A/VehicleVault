import "package:flutter/material.dart";

class CardComponent extends StatelessWidget {
  final String title;
  final int year;
  final String image;
  final String description;
  final bool showDescription;

  const CardComponent({super.key, required this.title, required this.year, required this.image, required this.description, required this.showDescription});

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

          // Subtitle
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              year.toString(), 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey
              )
            ),
          ),

          // Image
          Image.asset(
            image,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          // Description
          if (showDescription) // If showed to choose whether it's displayed or not. 
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                description, 
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