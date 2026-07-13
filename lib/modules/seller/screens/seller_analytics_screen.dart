import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_analytics_controller.dart';

class SellerAnalyticsScreen extends GetView<SellerAnalyticsController> {
  const SellerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: 'Seller Analytics',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.overview.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: Colors.red),
                SizedBox(height: 12.h),
                CustomText(text: 'Failed to load analytics data.', fontColor: colorScheme.outline),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: controller.load,
                  child: const Text('Try Again'),
                )
              ],
            ),
          );
        }

        final overview = controller.overview;
        final streams = overview['streams'] as Map<String, dynamic>? ?? {};
        final revenue = (overview['totalRevenue'] as num?)?.toDouble() ?? 0.0;
        final totalOrders = overview['totalOrders'] as int? ?? 0;
        final pendingOrders = overview['pendingOrders'] as int? ?? 0;
        final totalProducts = overview['totalProducts'] as int? ?? 0;
        final activeProducts = overview['activeProducts'] as int? ?? 0;
        final totalStreams = streams['totalStreams'] as int? ?? 0;
        final peakViewers = streams['peakViewers'] as int? ?? 0;

        return RefreshIndicator(
          onRefresh: controller.load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Selector Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Performance Overview',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        _buildChoiceChip(7, '7 Days'),
                        SizedBox(width: 8.w),
                        _buildChoiceChip(30, '30 Days'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Grid of overview metrics
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard(
                      context,
                      'Total Revenue',
                      '\$${revenue.toStringAsFixed(2)}',
                      Icons.attach_money_rounded,
                      Colors.green,
                    ),
                    _buildMetricCard(
                      context,
                      'Orders Filled',
                      '$totalOrders total',
                      Icons.shopping_bag_outlined,
                      AppColors.orange,
                    ),
                    _buildMetricCard(
                      context,
                      'Pending Orders',
                      '$pendingOrders pending',
                      Icons.hourglass_empty_rounded,
                      Colors.amber,
                    ),
                    _buildMetricCard(
                      context,
                      'Active Listings',
                      '$activeProducts / $totalProducts',
                      Icons.list_alt_rounded,
                      Colors.teal,
                    ),
                    _buildMetricCard(
                      context,
                      'Completed Shows',
                      '$totalStreams shows',
                      Icons.video_call_outlined,
                      Colors.purple,
                    ),
                    _buildMetricCard(
                      context,
                      'Peak Viewers',
                      '$peakViewers viewers',
                      Icons.trending_up_rounded,
                      Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // Revenue Trend Section
                CustomText(
                  text: 'Revenue Trend',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 16.h),

                // Chart Container
                _buildRevenueTrendChart(context),

                SizedBox(height: 25.h),

                // Daily Breakdown List
                CustomText(
                  text: 'Daily Breakdown',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 10.h),
                _buildDailyBreakdownList(context),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChoiceChip(int days, String label) {
    return Obx(() {
      final isSelected = controller.selectedDays.value == days;
      return GestureDetector(
        onTap: () => controller.changeTimeline(days),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontColor: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      );
    });
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                fontSize: 12.sp,
                fontColor: colorScheme.outline,
              ),
              Icon(icon, size: 20.sp, color: color),
            ],
          ),
          CustomText(
            text: value,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontColor: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrendChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trend = controller.revenueTrend;

    if (trend.isEmpty) {
      return Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CustomText(
            text: 'No revenue records for this period.',
            fontColor: colorScheme.outline,
          ),
        ),
      );
    }

    // Prepare chart spots
    final List<FlSpot> spots = [];
    double maxVal = 0.0;
    for (int i = 0; i < trend.length; i++) {
      final val = (trend[i]['revenue'] as num?)?.toDouble() ?? 0.0;
      if (val > maxVal) maxVal = val;
      spots.add(FlSpot(i.toDouble(), val));
    }

    // Avoid chart zero scaling errors
    if (maxVal == 0.0) maxVal = 100.0;

    return Container(
      height: 200.h,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10.w, 20.h, 20.w, 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (val) => FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (val, meta) {
                  return CustomText(
                    text: '\$${val.toInt()}',
                    fontSize: 9.sp,
                    fontColor: colorScheme.outline,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx >= 0 && idx < trend.length && (idx == 0 || idx == trend.length ~/ 2 || idx == trend.length - 1)) {
                    final dateStr = trend[idx]['_id'].toString();
                    final parts = dateStr.split('-');
                    final label = parts.length == 3 ? '${parts[1]}/${parts[2]}' : dateStr;
                    return Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: CustomText(
                        text: label,
                        fontSize: 9.sp,
                        fontColor: colorScheme.outline,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (trend.length - 1).toDouble(),
          minY: 0,
          maxY: maxVal * 1.15,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.orange,
              barWidth: 3.w,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.orange.withValues(alpha: 0.25),
                    AppColors.orange.withValues(alpha: 0.01),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBreakdownList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trend = controller.revenueTrend;

    if (trend.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: CustomText(text: 'No data logs.', fontColor: colorScheme.outline),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: trend.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = trend[(trend.length - 1) - index]; // show latest dates first
          final dateStr = item['_id'].toString();
          final rev = (item['revenue'] as num?)?.toDouble() ?? 0.0;
          final ord = item['orders'] as int? ?? 0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: _formatDate(dateStr),
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: '$ord order${ord == 1 ? '' : 's'} placed',
                      fontSize: 12.sp,
                      fontColor: colorScheme.outline,
                    ),
                  ],
                ),
                CustomText(
                  text: '\$${rev.toStringAsFixed(2)}',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  fontColor: AppColors.orange,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length != 3) return dateStr;
      final monthInt = int.tryParse(parts[1]) ?? 1;
      final day = parts[2];
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[monthInt - 1];
      return '$month $day, ${parts[0]}';
    } catch (_) {
      return dateStr;
    }
  }
}
