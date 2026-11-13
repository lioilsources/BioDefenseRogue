import 'package:flutter/material.dart';

import '../../config/balance.dart';

/// Pozadí obrazovek mimo arénu (generované, art/fx/manifest.json).
class ScreenImages {
  ScreenImages._();

  static const menu        = 'assets/images/bg/bg-menu.webp';
  static const runWon      = 'assets/images/bg/bg-vyhra.webp';
  static const gameOver    = 'assets/images/bg/bg-prohra.webp';
  static const vaccination = 'assets/images/fx/meta-vakcinace.webp';
}

/// Celoplošný obrázek, přes něj ztmavení a obsah. Když obrázek chybí,
/// zůstane jen ztmavení (jako dřív).
class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.asset, required this.child});

  final String asset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          asset,
          fit: BoxFit.cover,
          excludeFromSemantics: true,
          errorBuilder: (context, _, _) => const ColoredBox(color: Colors.black),
        ),
        ColoredBox(
          color: Colors.black.withValues(alpha: Balance.screenBgDimAlpha),
        ),
        child,
      ],
    );
  }
}
