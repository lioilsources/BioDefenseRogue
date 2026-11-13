import 'package:flutter/material.dart';

import '../../config/balance.dart';

/// Vystředí dialog a zmenší ho, když se na obrazovku nevejde (malý telefon
/// na šířku). Nikdy nezvětšuje, takže na větších displejích se nic nemění.
class FitToScreen extends StatelessWidget {
  const FitToScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Balance.overlayScreenMargin),
        child:   FittedBox(fit: BoxFit.scaleDown, child: child),
      ),
    );
  }
}
