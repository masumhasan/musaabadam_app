import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/modules/home/controllers/home_screen_controller.dart';
import 'package:musaab_adam/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/components/livestream_grid_item.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/components/category_item.dart';
import '../../../core/widgets/sized_box_widget.dart';

class HomeScreen extends GetView<MainNavController> {
  HomeScreen({super.key});

  final RoleService roleService = Get.find<RoleService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeCtrl = Get.find<HomeScreenController>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _appBar(theme, context),
      body: Obx(() => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: AppStrings.categories,
                        fontWeight: FontWeight.w600,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.changeIndex(1);
                        },
                        child: CustomText(
                          text: AppStrings.viewAll,
                          fontSize: 14,
                          fontColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                _categoryItems(),
                if (roleService.getUpdatedRole() == Role.buyer)
                  _buildPromoCard(theme, homeCtrl),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: CustomText(
                    text: AppStrings.liveStreams,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBoxWidget(height: 15.h),
              ],
            ),
          ),
          _liveStreamSliverGrid(homeCtrl.liveStreams),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      )),
    );
  }

  AppBar _appBar(ThemeData theme, BuildContext context) => AppBar(
    titleSpacing: 0,
    forceMaterialTransparency: true,
    backgroundColor: Colors.transparent,
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          hintText: 'Search...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              Assets.icons.search,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface.withValues(alpha: 0.5),
                BlendMode.srcIn,
              ),
            ),
          ),
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
        ),
      ),
    ),
    actions: actionButtons(context),
  );

  Widget _buildPromoCard(ThemeData theme, HomeScreenController homeCtrl) => Container(
    height: 180.h,
    margin: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.r),
      image: DecorationImage(
        image: NetworkImage(Dummy.cover1),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'Bidsrush Wonderland',
            fontColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          Row(
            children: [
              Icon(Icons.live_tv, color: Colors.white),
              CustomText(text: homeCtrl.liveShowCountText, fontColor: Colors.white),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _categoryItems() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBoxWidget(width: 15.w),
        CategoryItem(
          image: "",
          assetImage: Assets.images.forYou.keyName,
          itemName: AppStrings.forYou,
        ),
        CategoryItem(
          image: "",
          assetImage: Assets.images.followedHost.keyName,
          itemName: AppStrings.followedHosts,
        ),
        ...List.generate(
          8,
          (i) => CategoryItem(
            image: Dummy.product1,
            itemName: "Watch",
          ),
        ),
      ],
    ),
  );

  Widget _liveStreamSliverGrid(List<StreamModel> streams) {
    if (streams.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            mainAxisExtent: 185.h,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => LivestreamGridItem(
              userName: "Suja Rae",
              userAvatarUrl: Dummy.user2,
              thumbnailUrl: Dummy.live1,
              streamTitle: "Live Bag Haul",
              onTap: () => Get.toNamed(AppRoutes.livestreamScreen),
              viewerCount: '2.5 k',
              category: "Women's category",
            ),
            childCount: 8,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: 185.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final stream = streams[index];
            return LivestreamGridItem(
              userName: stream.sellerName ?? '',
              userAvatarUrl: stream.sellerAvatarUrl ?? Dummy.user2,
              thumbnailUrl: stream.thumbnailUrl ?? Dummy.live1,
              streamTitle: stream.title,
              onTap: () => Get.toNamed(AppRoutes.livestreamScreen, arguments: stream.id),
              viewerCount: _formatViewers(stream.totalViewers),
              category: stream.categoryId ?? '',
            );
          },
          childCount: streams.length,
        ),
      ),
    );
  }

  String _formatViewers(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)} k';
    return count.toString();
  }

  List<IconButton> actionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconButton buildActionIcon(String assetPath, VoidCallback onPressed) {
      return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    return [
      buildActionIcon(Assets.icons.message, () => Get.toNamed(AppRoutes.inboxScreen)),
      buildActionIcon(Assets.icons.notification, () => Get.toNamed(AppRoutes.notificationScreen)),
      buildActionIcon(Assets.icons.gift, () => Get.toNamed(AppRoutes.inviteScreen)),
    ];
  }
}
