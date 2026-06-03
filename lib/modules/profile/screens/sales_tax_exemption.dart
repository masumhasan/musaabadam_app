import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class SalesTaxExemptionScreen extends StatelessWidget {
  const SalesTaxExemptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: const BackButton(),
      title: CustomText(text: AppStrings.salesTaxExemption, fontSize: 18, fontWeight: FontWeight.w900,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            CustomText(
                text: "Adam",
              translate: false,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: "${AppStrings.exemptionStatus}: Not Approved",
              translate: false,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: "${AppStrings.exemptionDate} 20 May 2026",
              translate: false,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            CustomButton(
                label: AppStrings.applyNow,
              buttonHeight: 40.h,
            ),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
