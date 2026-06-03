import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text: "Oops!",
                          fontSize: 30,
                        ),
                        CustomText(
                          text: AppStrings.thePageYouWereLookingFor.tr,
                          fontSize: 14,
                        ),
                        //ImageWidget(width: 324, height: 242, imagePath: Assets.images.error.keyName)
                      ],
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.symmetric( horizontal: 25.w ),
                child: CustomButton(label: AppStrings.goBack.tr,
                buttonHeight: 45,
                  buttonWidth: double.infinity,
                  backgroundColor: AppColors.primaryColor,
                  buttonRadius: 8,
                ),
              ),
              SizedBoxWidget(height: 20,)
            ],
          )
      ),
    );
  }
}
