import 'package:flutter/material.dart';


class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.count,
    required this.title,
  });

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 5,
      margin: EdgeInsets.only(top: 8, left: 8,right: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Column(
          children: [
            Text(
              count,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
