import 'package:flutter/material.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';

class EditSnapScreen extends StatelessWidget {
  const EditSnapScreen({super.key});

  // Replace these with your actual Network Image URLs
  final List<String> imageUrls = const [
    Dummy.live1,
    Dummy.live1,
    Dummy.live1,
    Dummy.live1,
    Dummy.live1,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Main Display Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedImageWidget(
                  imageUrl: imageUrls[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 2. Thumbnail Gallery
          // SizedBox(
          //   height: 60,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 15),
          //     itemCount: imageUrls.length + 1, // +1 for the play button
          //     itemBuilder: (context, index) {
          //       if (index == 0) {
          //         // Play Button Item
          //         return Container(
          //           width: 60,
          //           margin: const EdgeInsets.symmetric(horizontal: 2),
          //           color: Colors.blue.withOpacity(0.2),
          //           child: const Icon(Icons.play_arrow, color: Colors.cyan, size: 40),
          //         );
          //       }
          //
          //       // Image Thumbnails
          //       return Container(
          //         width: 60,
          //         margin: const EdgeInsets.symmetric(horizontal: 2),
          //         child: Image.network(
          //           imageUrls[index - 1],
          //           fit: BoxFit.cover,
          //         ),
          //       );
          //     },
          //   ),
          // ),

          const SizedBox(height: 30),

          // 3. Save Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CustomButton(
              buttonHeight: 40,
                label: AppStrings.save
            ),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}