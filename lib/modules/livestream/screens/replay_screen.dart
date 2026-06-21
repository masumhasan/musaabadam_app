import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/modules/livestream/controllers/replay_controller.dart';

/// Full-screen player for a recorded past show (replay) served from S3.
class ReplayScreen extends GetView<ReplayController> {
  const ReplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              controller.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text('Loading replay…', style: TextStyle(color: Colors.white70)),
              ],
            );
          }

          if (controller.hasError.value) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value.isEmpty
                        ? 'Replay unavailable.'
                        : controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: controller.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final chewie = controller.chewie.value;
          if (chewie == null) {
            return const Text('Replay unavailable.', style: TextStyle(color: Colors.white70));
          }

          return AspectRatio(
            aspectRatio: chewie.aspectRatio ?? 16 / 9,
            child: Chewie(controller: chewie),
          );
        }),
      ),
    );
  }
}
