import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_choice_chip.dart';
import '../../../core/widgets/sized_box_widget.dart';

class ChipButtonsBar extends StatelessWidget {
  ChipButtonsBar({super.key});

  // 1. Define the reactive variable to track the selected index
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    // 2. Define your list of labels dynamically
    final List<String> chipLabels = [
      AppStrings.all.tr,
      AppStrings.inProgress.tr,
      AppStrings.completed.tr,
      AppStrings.refunds.tr,
      AppStrings.cancelled.tr,
      AppStrings.tips.tr,
      AppStrings.pendingReview.tr,
      AppStrings.communityBoost.tr,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
            () => Row(
          children: [
            SizedBoxWidget(width: 20),
            ...List.generate(chipLabels.length, (index) {
              return Row(
                children: [
                  CustomChoiceChip(
                    label: chipLabels[index],
                    borderRadius: 100,
                    padding: const [8, 4],
                    // 3. Make 'selected' reactive based on current index
                    selected: selectedIndex.value == index,
                    colorChangeable: true,
                    // 4. Update the reactive state on click
                    onSelected: (isSelected) {
                      if (isSelected) {
                        selectedIndex.value = index;
                      }
                    },
                  ),
                  // Add spacing after every item except the last one
                  if (index != chipLabels.length - 1)
                    SizedBoxWidget(width: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}