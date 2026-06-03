import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../assets_gen/assets.gen.dart';
import '../utils/app_colors.dart';
import 'cached_image_widget.dart';

class PhotoEditWidget extends StatelessWidget {
  final String? imageUrl;
  final Rxn<File> profileImage = Rxn<File>();
  final File? controllerImage;
  final Function(File file)? onImagePicked;

  PhotoEditWidget({super.key, this.imageUrl, this.onImagePicked, this.controllerImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(0),
            height: 80.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Obx(() {
                return _buildProfileImage();
              }),
            ),
          ),

          // The Edit Icon Button
          Positioned(
            right: 0,
            bottom: 0,
            child: _EditIcon(size: 34.r, iconSize: 18.r, onTap: _pickImage),
          ),
        ],
      ),
    );
  }

  // Logic to decide whether to show File, Network URL, or Placeholder
  Widget _buildProfileImage() {
    if (profileImage.value != null) {
      return Image.file(profileImage.value!, fit: BoxFit.cover);
    }else if( controllerImage != null ){
      return Image.file(controllerImage!, fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedImageWidget(
          imageUrl: imageUrl!,
        iconSize: 35,
      );
    }
    //return Icon(Icons.person, size: 50.r, color: Colors.grey);
    return Icon(Icons.person, size: 45.r, color: Colors.white);
  }

  // Image Picker Logic
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      profileImage.value = file;

      if (onImagePicked != null) {
        onImagePicked!(file);
      }
    }
  }
}

// Reusable Edit Icon Widget
class _EditIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _EditIcon({
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.black50,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            onTap.call();
          },
          child: SvgPicture.asset(Assets.icons.camera, height: 24,),
        ),
      ),
    );
  }
}
