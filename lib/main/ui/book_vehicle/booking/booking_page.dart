import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'booking_bloc.dart';

class BookingPage extends StatelessWidget {
  final GoongPlaceDetail pickUp;
  final GoongPlaceDetail dropOff;
  const BookingPage({super.key, required this.pickUp, required this.dropOff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final request = CreateRideRequest(
      pickupAddress: pickUp.formattedAddress ?? "",
      pickupLat: pickUp.geometry?.location?.lat.toString() ?? "",
      pickupLng: pickUp.geometry?.location?.lng.toString() ?? "",
      destinationAddress: dropOff.formattedAddress ?? "",
      destinationLat: dropOff.geometry?.location?.lat.toString() ?? "",
      destinationLng: dropOff.geometry?.location?.lng.toString() ?? "",
      vehicleType: 1,
    );

    return BlocProvider(
      create: (_) => BookingBloc()
        // ..add(LoadBookingOptionsEvent())
        ..add(LoadInitialBookingData(request)),
      child: Scaffold(
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingError) {
              return Center(child: Text(state.message));
            }

            if (state is BookingLoaded) {
              // final selectedVehicle = "1";

              return Stack(
                children: [
                  // Background Map
                  Positioned.fill(
                    child: Image.network(
                      "https://picsum.photos/id/1015/600/900",
                      fit: BoxFit.cover,
                      color: Colors.grey.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),

                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => context.pop(),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Addresses
                              Expanded(
                                child: _AddressSection(
                                  pickup: pickUp.formattedAddress ?? "",
                                  destination: dropOff.formattedAddress ?? "",
                                  l10n: l10n,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Spacer(),

                        // Promo Code Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _PromoCodeButton(l10n: l10n),
                              Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: SvgPicture.asset(AppImages.icLocation3),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Vehicle Selection Section
                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32)),
                            ),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 48,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.color_E8E8EA,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                Text(l10n.chooseVehicle,
                                    style: AppTextFonts.interBold.copyWith(
                                        color: AppColors.color_1C1E,
                                        fontSize: 18)),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12),

                                        ...state.vehicles.map(
                                            (vehicle) => _VehicleOptionCard(
                                                  vehicle: vehicle,
                                                  isSelected: vehicle.id ==
                                                      state.selectedVehicleId,
                                                  onTap: () => context
                                                      .read<BookingBloc>()
                                                      .add(SelectVehicleEvent(
                                                          vehicle.id, request)),
                                                )),

                                        const SizedBox(height: 24),

                                        // Payment Method
                                        _PaymentMethodSection(l10n: l10n),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                commonButton(
                                    text: l10n.confirmBooking,
                                    onPressed: () {
                                      context.read<BookingBloc>().add(
                                          ConfirmRideEvent(
                                              int.parse(state.rideId ?? "0"),
                                              state.totalAmount,
                                              (String path, Ride ride) =>
                                                  context.push(
                                                      PATH_FINDING_DRIVER,
                                                      extra: {
                                                        'path': path,
                                                        'ride': ride
                                                      })));
                                      // context.push(PATH_FINDING_DRIVER,
                                      //     extra: PATH_TRACKING);
                                    }),
                                // _ConfirmButton(
                                //   totalAmount: state.totalAmount,
                                //   l10n: l10n,
                                //   onPressed: () => context.push(PATH_TRACKING),
                                // )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _AddressSection extends StatelessWidget {
  final String pickup;
  final String destination;
  final AppLocalizations l10n;

  const _AddressSection({
    required this.pickup,
    required this.destination,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(height: 12),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.colorMain,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Expanded(
                  child: VerticalDivider(
                    color: AppColors.color_C3C6D5,
                    thickness: 1.5,
                    width: 1,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pickup, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  Text(destination,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoCodeButton extends StatelessWidget {
  final AppLocalizations l10n;

  const _PromoCodeButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppImages.icVoucher),
            const SizedBox(width: 8),
            Text(l10n.promoCode, style: AppStyles.inter14Medium),
          ],
        ),
      ),
    );
  }
}

class _VehicleOptionCard extends StatelessWidget {
  final VehicleOption vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleOptionCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : AppColors.color_F3F3F6,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(vehicle.icon, height: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (vehicle.tag.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: Container(
                            // width: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: vehicle.tagColor?.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              vehicle.tag,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: vehicle.tagColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(AppImages.icClock, height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 1,
                        child: Text(vehicle.time,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "${vehicle.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodSection extends StatefulWidget {
  final AppLocalizations l10n;

  const _PaymentMethodSection({required this.l10n});

  @override
  State<_PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<_PaymentMethodSection> {
  String _selectedMethod = "Tiền mặt";

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đổi phương thức thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.color_F3F3F6,
                  child: SvgPicture.asset(AppImages.icMoney, height: 16),
                ),
                title: const Text("Tiền mặt",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedMethod == "Tiền mặt"
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedMethod = "Tiền mặt";
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.color_F3F3F6,
                  child:
                      Icon(Icons.account_balance, color: Colors.blue, size: 20),
                ),
                title: const Text("Chuyển khoản",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedMethod == "Chuyển khoản"
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedMethod = "Chuyển khoản";
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPaymentMethodSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.color_F3F3F6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: _selectedMethod == "Tiền mặt"
                  ? SvgPicture.asset(AppImages.icMoney, height: 16)
                  : const Icon(Icons.account_balance,
                      color: Colors.blue, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_selectedMethod,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const Text(
              "THAY ĐỔI",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final int totalAmount;
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  const _ConfirmButton({
    required this.totalAmount,
    required this.l10n,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = totalAmount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        "${l10n.confirmBooking} →",
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
