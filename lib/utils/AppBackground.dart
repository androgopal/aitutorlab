import 'package:flutter/material.dart';

import '../theme/common_color.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.primaryContainer],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )
      ),
      child: SafeArea(child: child),
    );
  }
}
