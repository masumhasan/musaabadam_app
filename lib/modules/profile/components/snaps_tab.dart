import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class SnapsTab extends StatelessWidget {
  const SnapsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final snaps = box.read<List<dynamic>>('snaps') ?? [];
    
    if (snaps.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const CustomText(
              text: 'No snaps captured yet.',
              fontColor: Colors.grey,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: snaps.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 9 / 10,
      ),
      itemBuilder: (context, index) {
        final reversedIndex = snaps.length - 1 - index; // latest snaps first
        final base64String = snaps[reversedIndex] as String;
        final bytes = base64Decode(base64String);
        
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(bytes, fit: BoxFit.contain),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
