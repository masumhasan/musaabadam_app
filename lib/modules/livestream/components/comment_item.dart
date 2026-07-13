import 'package:flutter/material.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';

class CommentItem extends StatelessWidget {
  final String user;
  final String comment;
  final bool isMod;
  final String? avatarUrl;

  const CommentItem({
    super.key,
    required this.user,
    required this.comment,
    required this.isMod,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            imageUrl: avatarUrl ?? '',
            height: 30,
            width: 30,
            borderRadius: 50,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: isMod ? Border.all(color: Colors.cyan) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      if (isMod) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "MOD",
                            style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 4), // Added slight spacing between username and comment
                  Text(
                    comment,
                    style: TextStyle(color: isMod ? Colors.orange : Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}