import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedImageWidget(
                  imageUrl: Dummy.live1,
                fit: BoxFit.cover,
              ),
            ),

            // 2. Top User Info Section
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const BackButton(),
                    const SizedBox(width: 12),
                    CachedImageWidget(imageUrl: Dummy.user1, height: 42.h, width: 42.w, borderRadius: 50,),
                    const SizedBox(width: 12),
                    const Text(
                      'Azmir Khan',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // 3. Bottom Interaction Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30), // Extra padding for safe area
                child: Row(
                  children: [
                    // Text Input Field
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.shade300, width: 1.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Send message",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Reaction/Emojis Icons
                    _buildReactionIcon(Icons.thumb_up, Colors.blue),
                    const SizedBox(width: 12),
                    _buildReactionIcon(Icons.face, Colors.amber),
                    const SizedBox(width: 12),
                    _buildReactionIcon(Icons.favorite, Colors.teal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the reaction emojis at the bottom
  Widget _buildReactionIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 32, color: color),
    );
  }
}