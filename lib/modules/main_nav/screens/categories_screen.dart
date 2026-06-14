import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/components/category_item.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/modules/main_nav/controllers/categories_controller.dart';

class CategoriesScreen extends GetView<CategoriesController> {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: _searchBar(theme)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // Sort chips
            Row(
              children: ['Recommended', 'Popular', 'A-Z']
                  .asMap()
                  .entries
                  .map(
                    (e) => Obx(
                      () => Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CustomChoiceChip(
                          label: e.value,
                          selected: controller.selectedSortIndex.value == e.key,
                          onSelected: (_) => controller.setSortIndex(e.key),
                          borderRadius: 50,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            // Category grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.categories.isEmpty) {
                  return Center(
                    child: Text(
                      'No categories yet.',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: controller.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, i) {
                    final cat = controller.categories[i];
                    return CategoryItem(
                      image: cat.iconUrl ?? '',
                      itemName: cat.name,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(ThemeData theme) => SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        hintText: 'Search...',
        backgroundColor: WidgetStateProperty.all(
          theme.colorScheme.surfaceContainer,
        ),
        trailing: [Icon(Icons.search, color: theme.colorScheme.primary)],
      );
}
