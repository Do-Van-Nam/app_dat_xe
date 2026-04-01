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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.color_69FF87.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppImages.icCar),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(l10n.sharedRide),
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
                                        '~${state.estimatedPrice.toStringAsFixed(0)}đ',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(l10n.shareRideDescription),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

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
