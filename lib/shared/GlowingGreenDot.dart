import 'package:flutter/material.dart';

class GlowingGreenDot extends StatefulWidget {
  const GlowingGreenDot({super.key, this.size = 12,required this.isSynced});

  final double size;
  final bool isSynced;

  @override
  State<GlowingGreenDot> createState() => _GlowingGreenDotState();
}

class _GlowingGreenDotState extends State<GlowingGreenDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: widget.isSynced?Colors.green:Colors.red, width: 1)),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final glow = 4 + (_controller.value * 12);

              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSynced?Colors.green:Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: widget.isSynced?Colors.green.withOpacity(0.8):Colors.red.withOpacity(0.8),
                      blurRadius: glow,
                      spreadRadius: glow / 10,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(width: 4),
          Text(
            widget.isSynced?"Synced":"Pending",
            style: TextStyle(
              color: widget.isSynced?Colors.green:Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
