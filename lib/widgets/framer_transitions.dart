import 'package:flutter/material.dart';

/// Transisi halaman bergaya Framer Motion
/// Mengombinasikan Slide halus + Fade in + Subtle Spring Scale
class FramerMotionPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FramerMotionPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Kurva pergerakan halus khas Framer Motion
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // 1. Animasi Slide dari bawah sedikit (8%)
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // 2. Animasi Fade Opacity
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation);

            // 3. Animasi Scale mikro (95% -> 100%)
            final scaleAnimation = Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).animate(curvedAnimation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
        );
}
