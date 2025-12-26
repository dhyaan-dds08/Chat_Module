import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String tabName;

  const PlaceholderScreen({super.key, required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          tabName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
