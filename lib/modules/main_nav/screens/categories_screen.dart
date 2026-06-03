import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/components/category_item.dart';
import '../../../core/utils/app_constants.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final RxInt selectedIndex = 0.obs;

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
            Row(
              children: ["Recommended", "Popular", "A-Z"]
                  .asMap()
                  .entries
                  .map(
                    (e) => Obx(
                      () => Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CustomChoiceChip(
                          label: e.value,
                          selected: selectedIndex.value == e.key,
                          onSelected: (_) => selectedIndex.value = e.key,
                          borderRadius: 50,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 120,
                  mainAxisSpacing: 8
                ),
                itemBuilder: (context, i) =>
                    CategoryItem(image: Dummy.product1, itemName: "Watch"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(ThemeData theme) => SearchBar(
    elevation: WidgetStatePropertyAll(0),
    hintText: "Search...",
    backgroundColor: WidgetStateProperty.all(
      theme.colorScheme.surfaceContainer,
    ),
    trailing: [Icon(Icons.search, color: theme.colorScheme.primary)],
  );
}
