import 'dart:async';
import 'package:flutter/material.dart';

class AppOverlaySnackbar {
  static OverlayEntry? _currentOverlay;

  static void showSuccess(BuildContext context, {required String message}) {
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);

    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 350),
    );

    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 24,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: _ErrorCard(message: message,hasError: false,),
              ),
            ),
          ),
        );
      },
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    animationController.forward();

    Timer(const Duration(seconds: 3), () async {
      await animationController.reverse();

      entry.remove();

      animationController.dispose();

      if (_currentOverlay == entry) {
        _currentOverlay = null;
      }
    });
  }

  static void showError(BuildContext context, {required String message}) {
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);

    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 350),
    );

    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 24,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: _ErrorCard(message: message,hasError:true),
              ),
            ),
          ),
        );
      },
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    animationController.forward();

    Timer(const Duration(seconds: 3), () async {
      await animationController.reverse();

      entry.remove();

      animationController.dispose();

      if (_currentOverlay == entry) {
        _currentOverlay = null;
      }
    });
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final bool hasError;

  const _ErrorCard({required this.message,required this.hasError});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: hasError? Color(0xFFEF4444):Color.fromARGB(255, 109, 241, 138),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(40, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
