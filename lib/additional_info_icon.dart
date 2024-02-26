import 'package:flutter/material.dart';

class AddiotionalIcon extends StatelessWidget {
  final IconData icn;
  final String label;
  final data;
  const AddiotionalIcon(
      {super.key, required this.icn, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
      child: Column(
        children: [
          Icon(
            icn,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$data",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
