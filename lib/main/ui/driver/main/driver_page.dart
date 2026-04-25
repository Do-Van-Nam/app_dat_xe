import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/ui/driver/main/sections/shipping/going_to_pickup_shipping_order_section.dart';
import 'package:demo_app/main/ui/driver/main/sections/shipping/new_shipping_order_section.dart';
import 'package:demo_app/main/ui/driver/main/sections/shipping/start_shipping_section.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/main/utils/widget/popup_widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../map_background.dart';
import 'bloc/driver_bloc.dart';
import 'driver_models.dart';
import 'driver_widgets.dart';
// import 'sections/arrived_dest_section.dart';
import 'sections/ride/going_to_pickup_section.dart';
import 'sections/ride/new_ride_section.dart';
import 'sections/ride/offline_section.dart';
import 'sections/ride/online_section.dart';
import 'sections/ride/start_trip_section.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key, this.rideId});
  final String? rideId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverBloc(),
      child: const _DriverView(),
    );
  }
}

class _DriverView extends StatelessWidget {
  const _DriverView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.colorF0F2F5,
      // Sử dụng BlocBuilder riêng cho AppBar để tối ưu
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) => _buildAppBar(context, state, l10n),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // BlocSelector chỉ rebuild Map khi các thuộc tính liên quan thay đổi
            Positioned.fill(
              child: BlocSelector<DriverBloc, DriverState,
                  ({bool isAutoFetchRoute, LatLng? destinationPoint})>(
                selector: (state) => (
                  isAutoFetchRoute: state.isAutoFetchRoute,
                  destinationPoint: state.destinationPoint,
                ),
                builder: (context, record) {
                  if (!Constant.isDebugMode) {
                    return MapBackground(
                      followUserLocation: true,
                      destinationPoint: record.destinationPoint,
                      autoFetchRoute: record.isAutoFetchRoute,
                    );
                  } else {
                    return SizedBox(
                      height: 100,
                      width: 100,
                    );
                  }
                },
              ),
            ),
            BlocListener<DriverBloc, DriverState>(
              listenWhen: (prev, curr) => prev.error != curr.error,
              listener: (context, state) {
                if (state.error != null && state.error?.message != "goToChat") {
                  AppToast.show(context, state.error!.message);
                }
                if (state.error != null && state.error?.message == "goToChat") {
                  context.push(
                    PATH_CHAT,
                    extra: {'rideId': state.currentOffer?.id},
                  );
                }
              },
              child: SizedBox(),
            ),
            // BlocConsumer (con summer) bao lấy phần thân để xử lý Logic (Listen) và UI (Build)
            BlocConsumer<DriverBloc, DriverState>(
              listenWhen: (prev, curr) => prev.screen != curr.screen,
              listener: (context, state) {
                if (state.screen == DriverScreen.online &&
                    state.totalTrips > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hoàn thành chuyến! +29.000đ 🎉'),
                      backgroundColor: AppColors.color27AE60,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state.screen == DriverScreen.arrivedDest) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Đã đến điểm trả!'),
                  //     backgroundColor: AppColors.color27AE60,
                  //     duration: const Duration(seconds: 2),
                  //   ),
                  // );
                  context.push(PATH_RATE_TRIP,
                      extra: {'rideId': state.currentOffer!.id});
                } else if (state.screen == DriverScreen.customerCancel) {
                  showCommonPopup(
                    context: context,
                    title:
                        'Khách hàng yêu cầu huỷ chuyến. Xác nhận huỷ chuyến?',
                    option1Text: 'Không',
                    option1OnTap: () => Navigator.pop(context),
                    option2Text: 'Đồng ý',
                    option2OnTap: () {
                      // xử lý huỷ chuyến
                      context
                          .read<DriverBloc>()
                          .add(CustomerCancel(state.currentOffer!));
                      Navigator.pop(context);
                    },
                    isShowOption1: false,
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    _buildBody(state),

                    // // dropdown doi giao dien de debug
                    if (Constant.isDebugMode) ...[
                      Positioned(
                        top: 100,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: DropdownButton<DriverScreen>(
                            value: state.screen,
                            items: DriverScreen.values.map((screen) {
                              return DropdownMenuItem(
                                value: screen,
                                child: Text(
                                  screen.name,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                context
                                    .read<DriverBloc>()
                                    .add(DebugChangeScreen(val));
                              }
                            },
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 100,
                          right: 20,
                          child: TextButton(
                            child: Text("show popup"),
                            onPressed: () {
                              showCommonPopup(
                                context: context,
                                title:
                                    'Khách hàng yêu cầu huỷ chuyến. Xác nhận huỷ chuyến?',
                                option1Text: 'Không',
                                option1OnTap: () => context.pop(),
                                option2Text: 'Huỷ chuyến',
                                option2OnTap: () {
                                  context.pop();
                                  // xử lý huỷ chuyến
                                },
                              );
                            },
                          )),
                      Positioned(
                          top: 200,
                          right: 20,
                          child: TextButton(
                            child: Text("chat"),
                            onPressed: () {
                              context.push(PATH_CHAT,
                                  extra: {'rideId': "161351382691115916"});
                            },
                          ))
                    ]
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    DriverState state,
    AppLocalizations l10n,
  ) {
    final isOnline = state.screen != DriverScreen.offline;

    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundImage: const AssetImage('assets/images/driver_avatar.png'),
          backgroundColor: AppColors.colorF3F4F6,
          child: null,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _appBarTitle(state, l10n),
            style: AppStyles.inter16Bold.copyWith(
              color: isOnline ? AppColors.color1A56DB : AppColors.color1A1A1A,
            ),
          ),
          if (isOnline && state.screen == DriverScreen.online)
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.color2ECC71,
                  ),
                ),
                const SizedBox(width: 4),
                Text(l10n.statusOnlineActive,
                    style: AppStyles.inter11SemiBold
                        .copyWith(color: AppColors.color2ECC71)),
              ],
            ),
        ],
      ),
      actions: [
        SosBadge(
          label: l10n.sos,
          onTap: () => context.read<DriverBloc>().add(const SosTapped()),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              AppImages.icBell,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                  AppColors.color1A1A1A, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  String _appBarTitle(DriverState state, AppLocalizations l10n) {
    switch (state.screen) {
      case DriverScreen.offline:
        return l10n.statusOffline;
      case DriverScreen.online:
      case DriverScreen.newRide:
        return l10n.statusOnline;
      case DriverScreen.goingToPickup:
        return l10n.goingToPickup;
      case DriverScreen.arrivedPickup:
        return l10n.startTrip;
      case DriverScreen.startTrip:
        return l10n.startTrip;
      case DriverScreen.arrivedDest:
        return l10n.arrivedDest;
      case DriverScreen.newShippingOrder:
        return l10n.arrivedDest;
      case DriverScreen.goingToPickupShippingOrder:
        return l10n.arrivedDest;
      case DriverScreen.startTripShippingOrder:
        return l10n.arrivedDest;
      case DriverScreen.customerCancel:
        return l10n.arrivedDest;
    }
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody(DriverState state) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: () {
        switch (state.screen) {
          case DriverScreen.offline:
            return const OfflineSection();
          case DriverScreen.online:
            return const OnlineSection();
          case DriverScreen.newRide:
            return const NewRideSection();
          case DriverScreen.goingToPickup:
            return const GoingToPickupSection();
          case DriverScreen.startTrip:
            return const StartTripSection();
          case DriverScreen.arrivedPickup:
            return const StartTripSection();
          case DriverScreen.arrivedDest:
            return const OnlineSection();
          case DriverScreen.newShippingOrder:
            return const NewShippingOrderSection();
          case DriverScreen.goingToPickupShippingOrder:
            return const GoingToPickupShippingOrderSection();

          case DriverScreen.startTripShippingOrder:
            return const StartShippingSection();
          case DriverScreen.customerCancel:
            return const OnlineSection();

          // return const ArrivedDestSection();
        }
      }(),
    );
  }
}
