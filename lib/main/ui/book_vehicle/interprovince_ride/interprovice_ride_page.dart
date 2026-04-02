import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'interprovince_ride_bloc.dart';
import 'widgets/ride_form_widget.dart';

class InterprovinceRidePage extends StatelessWidget {
  const InterprovinceRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => InterprovinceRideBloc()..add(LoadInitialData()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.interprovinceRide, style: AppStyles.inter18Bold),
          leading: const BackButton(),
          actions: const [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 16),
          ],
        ),
        backgroundColor: AppColors.background,
        body: BlocBuilder<InterprovinceRideBloc, InterprovinceRideState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            return Stack(
              children: [
                Image.asset(
                  AppImages.imgInterprovince,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Background image + gradient (giữ nguyên logic)
                // ...

                // Phần nội dung chínhXZ

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form: Điểm đón, Điểm đến, Ngày, Giờ
                        RideFormWidget(), // tách ra widget riêng để sạch

                        const SizedBox(height: 24),

                        // Chọn loại xe
                        Text(
                          l10n.chooseVehicleType,
                          style: AppStyles.labelSmall,
                        ),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            color: const Color(0x3369FF87),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x0C000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: SvgPicture.asset(AppImages.icCar)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Text(
                                          l10n.sharedRide,
                                          style: AppStyles.inter18Bold.copyWith(
                                              fontSize: 16,
                                              color: AppColors.color_1C1E),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.color_69FF87,
                                            borderRadius:
                                                BorderRadius.circular(9999),
                                          ),
                                          child: Text(l10n.saveMoney),
                                        ),
                                        Text(
                                          '~250k',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: l10n.shareRideDescription,
                                        children: [
                                          TextSpan(
                                            text: ' ${l10n.seatsAvailable}',
                                            style: AppStyles.inter18Bold
                                                .copyWith(
                                                    fontSize: 10,
                                                    color:
                                                        AppColors.color_004317),
                                          ),
                                        ],
                                        style: AppStyles.inter12Medium.copyWith(
                                            color: AppColors.color_434654),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                                child: _buildCarCard(
                                    '4-7 chỗ',
                                    'Xe 4-7 chỗ',
                                    '250k',
                                    'https://stimg.cardekho.com/images/carexteriorimages/930x620/Audi/Q6-e-tron/11608/1710995400792/front-left-side-47.jpg')),
                            SizedBox(width: 16),
                            Expanded(
                                child: _buildCarCard(
                                    '4-7 chỗ',
                                    'Xe 4-7 chỗ',
                                    '250k',
                                    'https://stimg.cardekho.com/images/carexteriorimages/930x620/Audi/Q6-e-tron/11608/1710995400792/front-left-side-47.jpg')),
                          ],
                        ),

                        // Giá dự kiến + Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.estimatedPrice,
                                style: const TextStyle(fontSize: 16)),
                            Text(
                              '~${state.estimatedPrice.toStringAsFixed(0)}đ',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            // context.read<InterprovinceRideBloc>().add(SubmitRideRequest());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999)),
                          ),
                          child: Text(l10n.findRideNow,
                              style: AppStyles.buttonLarge),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation Bar (có thể tách thành widget riêng)
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildCarCard(String name, String type, String price, String image) {
  return AspectRatio(
    aspectRatio: 1,
    child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F3F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                name,
                style: AppTextFonts.interBold
                    .copyWith(fontSize: 14, color: AppColors.color_1C1E),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: AppTextFonts.interMedium
                        .copyWith(fontSize: 12, color: AppColors.color_434654),
                  ),
                  Text(
                    price,
                    style: AppTextFonts.interBold
                        .copyWith(fontSize: 14, color: AppColors.color_1C1E),
                  ),
                ],
              ),
            )
          ],
        )),
  );
}
