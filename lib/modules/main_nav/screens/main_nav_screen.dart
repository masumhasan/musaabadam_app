import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/modules/main_nav/controllers/main_nav_controller.dart';

class MainNavScreen extends StatelessWidget {
  final MainNavController controller = Get.find<MainNavController>();

  MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await controller.handleBackPress();
      },
      child: Scaffold(
        body: Obx(() {
          return controller.screens[controller.currentIndex.value];
        }),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            elevation: 8, // Added slight elevation for better UI depth
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
  
            // Theme-aware colors
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.5),
  
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.currentIndex.value = index,
  
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Categories"),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: "Sell"),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "Activity"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
            ],
          );
        }),
      ),
    );
  }
}