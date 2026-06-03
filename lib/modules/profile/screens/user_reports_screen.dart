import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class UserReportsScreen extends StatelessWidget {
  UserReportsScreen({super.key});

  final RxBool isAllSelected = true.obs;
  final RxBool isSubmittedSelected = true.obs;
  final RxBool isClosedSelected = true.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.userReports,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 15,
          children:[
            _buildChip(AppStrings.all, isAllSelected),
            _buildChip(AppStrings.submitted, isSubmittedSelected),
            _buildChip(AppStrings.closed, isClosedSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, RxBool state) {
    return Obx(() => CustomChoiceChip(
      label: label,
      selected: state.value,
      borderRadius: 50,
      onSelected: (val) => state.value = !state.value,
    ));
  }
}