import 'package:demo_app/core/app_export.dart';

import 'bloc/driver_bloc.dart';
import 'driver_models.dart';
import 'driver_widgets.dart';
// import 'sections/arrived_dest_section.dart';
import 'sections/going_to_pickup_section.dart';
import 'sections/new_ride_section.dart';
import 'sections/offline_section.dart';
import 'sections/online_section.dart';
import 'sections/start_trip_section.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key});

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

    return BlocConsumer<DriverBloc, DriverState>(
      listenWhen: (prev, curr) => prev.screen != curr.screen,
      listener: (context, state) {
        if (state.screen == DriverScreen.online && state.totalTrips > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hoàn thành chuyến! +29.000đ 🎉'),
              backgroundColor: AppColors.color27AE60,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state.screen == DriverScreen.arrivedDest) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã đến điểm trả!'),
              backgroundColor: AppColors.color27AE60,
              duration: const Duration(seconds: 2),
            ),
          );
          context.push(PATH_RATE_TRIP);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.colorF0F2F5,
          appBar: _buildAppBar(context, state, l10n),
          body: SafeArea(
            top: false,
            child: _buildBody(state),
          ),
          // bottomNavigationBar: _buildBottomNav(context, state, l10n),
        );
      },
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
    }
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody(DriverState state) {
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
        return const SizedBox.shrink();
      // return const ArrivedDestSection();
    }
  }
}
