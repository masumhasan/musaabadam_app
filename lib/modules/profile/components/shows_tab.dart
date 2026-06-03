import 'package:flutter/material.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import '../../../core/widgets/cached_image_widget.dart';

class ShowsTab extends StatelessWidget {
  const ShowsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 10,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return showItem(
          context,
          imageUrl: Dummy.live1,
          userName: "Jackob",
          userAvatar: Dummy.user2,
          timeStamp: "Today 8:30 PM",
        );
      },
    );
  }

  Widget showItem(
      BuildContext context, {
        required String imageUrl,
        required String userName,
        required String userAvatar,
        required String timeStamp,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Row(
          children:[
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedImageWidget(
                imageUrl: userAvatar,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              userName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onSurface
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Stack(
            children:[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedImageWidget(imageUrl: imageUrl),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeStamp,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}