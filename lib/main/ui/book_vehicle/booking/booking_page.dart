import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'booking_bloc.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => BookingBloc()..add(LoadBookingOptionsEvent()),
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
              final selectedVehicle = state.vehicles.firstWhere(
                (v) => v.id == state.selectedVehicleId,
              );

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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  pickup: state.pickupAddress,
                                  destination: state.destinationAddress,
                                  l10n: l10n,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Promo Code Button
                          Row(
                            children: [
                              _PromoCodeButton(l10n: l10n),
                              Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Vehicle Selection Section
                          Text(
                            l10n.chooseVehicle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),

                          ...state.vehicles.map((vehicle) => _VehicleOptionCard(
                                vehicle: vehicle,
                                isSelected:
                                    vehicle.id == state.selectedVehicleId,
                                onTap: () => context
                                    .read<BookingBloc>()
                                    .add(SelectVehicleEvent(vehicle.id)),
                              )),

                          const SizedBox(height: 24),

                          // Payment Method
                          _PaymentMethodSection(l10n: l10n),

                          const SizedBox(
                              height: 100), // space for bottom button
                        ],
                      ),
                    ),
                  ),

                  // Bottom Confirm Button
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: _ConfirmButton(
                      totalAmount: state.totalAmount,
                      l10n: l10n,
                      onPressed: () => context.push(PATH_TRACKING),
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
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 12, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(child: Text(pickup)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          Row(
            children: [
              const Icon(Icons.circle, size: 12, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(child: Text(destination)),
            ],
          ),
        ],
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
      onTap: () {
        // TODO: Mở bottom sheet nhập mã
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_offer, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.promoCode,
                style: const TextStyle(fontWeight: FontWeight.w600)),
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
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(vehicle.icon, size: 32),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: vehicle.tagColor?.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            vehicle.tag,
                            style: TextStyle(
                              color: vehicle.tagColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Text("⏱ ${vehicle.time}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${vehicle.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _PaymentMethodSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.wallet, color: Colors.blue),
          const SizedBox(width: 12),
          const Expanded(
            child:
                Text("Tiền mặt", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(
            "THAY ĐỔI",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
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
