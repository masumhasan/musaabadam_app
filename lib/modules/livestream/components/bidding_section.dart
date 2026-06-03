import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_button.dart';
import 'livestream_dialogs.dart';

class BiddingSection extends StatelessWidget {
  const BiddingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white.withOpacity(0.9),
      child: Column(
        children: [
          Row(
            children: [
              CachedImageWidget(
                imageUrl: Dummy.product1,
                height: 48,
                width: 48,
                borderRadius: 8,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nike Air Max Sneakers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text("Size : 34-44  • New  • 1 Available", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text("+shipping+taxes", style: TextStyle(color: Colors.cyan.shade700, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("£4.13", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: const [
                      Icon(Icons.timer_outlined, size: 14, color: Colors.black),
                      SizedBox(width: 4),
                      Text("00:09", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: AppStrings.custom,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  borderWidth: 2,
                  borderColor: AppColors.primaryColor,
                  buttonRadius: 8,
                  onPressed: (){
                    showBiddingDialog();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: AppStrings.bid,
                  backgroundColor: AppColors.orange,
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w900,
                  buttonRadius: 8,
                  onPressed: (){

                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
