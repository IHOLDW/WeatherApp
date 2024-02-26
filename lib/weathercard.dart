import 'package:flutter/material.dart';

class WthrCard extends StatelessWidget {
  final IconData ic;
  final String time;
  final String temp;
  const WthrCard({
    super.key,
    required this.ic,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Card(
        elevation: 20,
        child: Column(
          children: [
            Center(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Icon(
              ic,
              size: 30,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              temp,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
