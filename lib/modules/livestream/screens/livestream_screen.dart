import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/labeled_iconbutton.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/svg_icon.dart';
import 'package:musaab_adam/modules/livestream/components/bidding_section.dart';
import 'package:musaab_adam/modules/livestream/components/comment_item.dart';
import 'package:musaab_adam/modules/livestream/components/livestream_dialogs.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/assets_gen/assets.gen.dart';

class LiveStreamScreen extends StatelessWidget {
  LiveStreamScreen({Key? key}) : super(key: key);

  RxBool isFullScreen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(Dummy.live1, fit: BoxFit.cover)),
          Obx(() {
            if (isFullScreen.value) {
              return Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => isFullScreen.value = !isFullScreen.value,
                ),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  headerSection(),
                  //const Spacer(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: commentSection()),
                        rightSideButtons(context),
                      ],
                    ),
                  ),
                  writeCommentSection(),
                  BiddingSection(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  //==================HEADER SECTION====================
  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //Profile and Fullscreen
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Get.back(),
              ),
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.storyScreen);
                },
                child: CachedImageWidget(
                  imageUrl: Dummy.user1,
                  height: 40,
                  width: 40,
                  borderRadius: 50,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Emma Watson",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () => isFullScreen.value = !isFullScreen.value,
              ),
            ],
          ),
          const SizedBox(height: 8),
          //Live Stats and Follow Button
          Row(
            children: [
              const SizedBox(width: 48),
              SvgIcon(icon: Assets.icons.liveIcon),
              const SizedBox(width: 8),
              const Icon(
                Icons.visibility,
                color: AppColors.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                "5.2k",
                style: TextStyle(color: AppColors.primaryColor, fontSize: 14),
              ),
              const SizedBoxWidget(width: 10),
              CustomButton(label: AppStrings.follow, buttonHeight: 30),
            ],
          ),
        ],
      ),
    );
  }

  //==================COMMENT SECTION====================
  Widget commentSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 300.h,
        child: SingleChildScrollView(
          reverse: true,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(user: "Lora", comment: "Price?", isMod: false),
                const CommentItem(
                  user: "David",
                  comment: "I want to buy",
                  isMod: false,
                ),
                const CommentItem(user: "Alice", comment: "Very nice", isMod: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //=================WRITE COMMENT SECTION===============
  Widget writeCommentSection() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type comment........",
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white.withOpacity(0.2),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: -pi/4,
            child: const CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget rightSideButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LabeledIconButton(
              iconPath: Assets.icons.more,
              text: AppStrings.more,
              fontColor: AppColors.primaryColor,
              onClick: () {
                showOptionsDialog(context);
              },
            ),
            LabeledIconButton(
              iconPath: Assets.icons.boost,
              text: AppStrings.boost,
              fontColor: AppColors.primaryColor,
              onClick: () {
                Get.toNamed(AppRoutes.boostScreen);
              },
            ),
            LabeledIconButton(
              iconPath: Assets.icons.clip,
              text: AppStrings.clip,
              fontColor: AppColors.primaryColor,
              onClick: () {
                showClipEditDialog(context: context);
              },
            ),
            LabeledIconButton(
              iconPath: Assets.icons.share,
              text: AppStrings.share,
              fontColor: AppColors.primaryColor,
              onClick: () async{
                await SharePlus.instance.share(
                  ShareParams(title: "Hey! Check this out.",
                  subject: "Watch this live.",
                    text: "https://www.something.com/"
                  )
                );
              },
            ),
            LabeledIconButton(
              iconPath: Assets.icons.wallet,
              text: AppStrings.wallet,
              fontColor: AppColors.primaryColor,
              onClick: () {},
            ),
            LabeledIconButton(
              iconPath: Assets.icons.shop,
              text: AppStrings.shop,
              fontColor: AppColors.primaryColor,
              onClick: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
