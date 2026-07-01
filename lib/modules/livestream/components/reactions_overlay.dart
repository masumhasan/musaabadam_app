import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/socket_service.dart';

/// Floating emoji reactions that rise + fade over the live video, driven by the
/// `reaction` socket event. Also spawns a local emoji immediately when the user
/// taps a reaction so their own tap feels instant.
class ReactionsOverlay extends StatefulWidget {
  final String streamId;
  const ReactionsOverlay({super.key, required this.streamId});

  @override
  State<ReactionsOverlay> createState() => ReactionsOverlayState();
}

class ReactionsOverlayState extends State<ReactionsOverlay> with TickerProviderStateMixin {
  final List<_FloatingReaction> _reactions = [];
  final _rand = Random();
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    // Listen for reactions broadcast from the server (other viewers + echo).
    _worker = ever<Map<String, dynamic>?>(SocketService.instance.latestReaction, (data) {
      if (!mounted || data == null) return;
      if (data['streamId'] != widget.streamId) return;
      final emoji = data['emoji']?.toString();
      if (emoji != null && emoji.isNotEmpty) spawn(emoji);
    });
  }

  /// Public so the screen can spawn an instant local reaction on tap.
  void spawn(String emoji) {
    if (!mounted) return;
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2200 + _rand.nextInt(900)),
    );
    final reaction = _FloatingReaction(
      emoji: emoji,
      controller: controller,
      startX: 0.55 + _rand.nextDouble() * 0.35, // right-ish column
      drift: (_rand.nextDouble() - 0.5) * 0.15,
      size: 22.0 + _rand.nextDouble() * 16.0,
    );
    setState(() => _reactions.add(reaction));
    controller.forward().whenComplete(() {
      if (!mounted) return;
      setState(() => _reactions.remove(reaction));
      controller.dispose();
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    for (final r in _reactions) {
      r.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: _reactions.map((r) {
              return AnimatedBuilder(
                animation: r.controller,
                builder: (context, child) {
                  final t = r.controller.value;
                  final bottom = t * constraints.maxHeight * 0.7;
                  final left = (r.startX + r.drift * sin(t * pi * 2)) * constraints.maxWidth;
                  final opacity = t < 0.85 ? 1.0 : (1.0 - (t - 0.85) / 0.15);
                  return Positioned(
                    left: left,
                    bottom: 80 + bottom,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Text(r.emoji, style: TextStyle(fontSize: r.size)),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _FloatingReaction {
  final String emoji;
  final AnimationController controller;
  final double startX;
  final double drift;
  final double size;

  _FloatingReaction({
    required this.emoji,
    required this.controller,
    required this.startX,
    required this.drift,
    required this.size,
  });
}
