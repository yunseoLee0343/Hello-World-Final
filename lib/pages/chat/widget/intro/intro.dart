import 'package:flutter/material.dart';

class IntroBox extends StatelessWidget {
  final Icon icon;
  final String title;
  final String sampleText1;
  final String sampleText2;
  final Function(String) onTap; // Add onTap callback

  const IntroBox({
    super.key,
    required this.icon,
    required this.title,
    required this.sampleText1,
    required this.sampleText2,
    required this.onTap, // Add onTap parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Icon(icon.icon, size: 28),
          const SizedBox(height: 1),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => onTap(sampleText1), // Add onTap handler
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    sampleText1,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => onTap(sampleText2), // Add onTap handler
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    sampleText2,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
