import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({this.label = 'Loading demo content', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
