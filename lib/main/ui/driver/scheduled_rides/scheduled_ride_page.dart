import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/scheduled_rides/widgets/accepted_trip_card.dart';
import 'bloc/scheduled_ride_bloc.dart';
import 'widgets/empty_state.dart';
import 'widgets/filter_bar.dart';
import 'widgets/trip_card.dart';

class ScheduledRidePage extends StatelessWidget {
  const ScheduledRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduledRideBloc(),
      child: const _ScheduledRideView(),
    );
  }
}

class _ScheduledRideView extends StatefulWidget {
  const _ScheduledRideView();

  @override
  State<_ScheduledRideView> createState() => _ScheduledRideViewState();
}

class _ScheduledRideViewState extends State<_ScheduledRideView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context
            .read<ScheduledRideBloc>()
            .add(ScheduledRideTabChanged(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ScheduledRideBloc, ScheduledRideState>(
      listenWhen: (p, c) =>
          p.errorMessage != c.errorMessage ||
          p.successMessage != c.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _ScheduledRideAppBar(
          title: l10n.chuyenDiAppBarTitle,
          tabController: _tabController,
          tabAllLabel: l10n.chuyenDiTabAll,
          tabAcceptedLabel: l10n.chuyenDiTabAccepted,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _AllTripsTab(l10n: l10n),
            _AcceptedTripsTab(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _ScheduledRideAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ScheduledRideAppBar({
    required this.title,
    required this.tabController,
    required this.tabAllLabel,
    required this.tabAcceptedLabel,
  });

  final String title;
  final TabController tabController;
  final String tabAllLabel;
  final String tabAcceptedLabel;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorAppBarBg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.colorAppBarTitle,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.colorAppBarTitle,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              labelColor: AppColors.colorTabSelected,
              unselectedLabelColor: AppColors.colorTabUnselected,
              indicatorColor: AppColors.colorTabIndicator,
              indicatorWeight: 2.5,
              labelStyle: AppStyles.inter14SemiBold,
              unselectedLabelStyle: AppStyles.inter14Medium,
              tabs: [
                Tab(text: tabAllLabel),
                Tab(text: tabAcceptedLabel),
              ],
            ),
            const Divider(height: 1, color: AppColors.colorTabDivider),
          ],
        ),
      ),
    );
  }
}

class _AllTripsTab extends StatelessWidget {
  const _AllTripsTab({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledRideBloc, ScheduledRideState>(
      builder: (context, state) {
        return Column(
          children: [
            FilterBar(
              filter: state.filter,
              onFilterChanged: (filter) => context
                  .read<ScheduledRideBloc>()
                  .add(ScheduledRideFilterChanged(filter)),
              onReset: () => context
                  .read<ScheduledRideBloc>()
                  .add(const ScheduledRideFilterReset()),
              labelDate: l10n.chuyenDiFilterDate,
              labelTime: l10n.chuyenDiFilterTime,
              labelType: l10n.chuyenDiFilterType,
              labelPriceMin: l10n.chuyenDiFilterPriceMin,
              labelPriceMax: l10n.chuyenDiFilterPriceMax,
              labelApply: l10n.chuyenDiFilterApply,
              labelReset: l10n.chuyenDiFilterReset,
              labelUrban: l10n.chuyenDiTypeUrban,
              labelIntercity: l10n.chuyenDiTypeIntercity,
              labelAirport: l10n.chuyenDiTypeAirport,
              priceHint: l10n.chuyenDiFilterPriceHint,
            ),
            Expanded(child: _AllTripsList(l10n: l10n, state: state)),
          ],
        );
      },
    );
  }
}

class _AllTripsList extends StatelessWidget {
  const _AllTripsList({required this.l10n, required this.state});
  final AppLocalizations l10n;
  final ScheduledRideState state;

  @override
  Widget build(BuildContext context) {
    if (state.loadStatus == ScheduledRideLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.colorPrimary),
      );
    }

    final trips = state.availableTrips;
    if (trips.isEmpty) {
      return EmptyState(message: l10n.chuyenDiEmptyAll);
    }

    return RefreshIndicator(
      color: AppColors.colorPrimary,
      onRefresh: () async {
        context
            .read<ScheduledRideBloc>()
            .add(const ScheduledRideRefreshRequested());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final trip = trips[index];
          return TripCard(
            trip: trip,
            typeLabel: _typeLabel(trip.type, l10n),
            isProcessing: state.processingTripId == trip.id,
            pickupLabel: l10n.chuyenDiPickupLabel,
            destinationLabel: l10n.chuyenDiDestinationLabel,
            acceptLabel: l10n.chuyenDiBtnAccept,
            cancelLabel: l10n.chuyenDiBtnCancel,
            onAccept: () {
              context
                  .read<ScheduledRideBloc>()
                  .add(ScheduledRideAcceptTrip(trip.id));
            },
          );
        },
      ),
    );
  }
}

class _AcceptedTripsTab extends StatelessWidget {
  const _AcceptedTripsTab({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledRideBloc, ScheduledRideState>(
      builder: (context, state) {
        if (state.loadStatus == ScheduledRideLoadStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.colorPrimary),
          );
        }

        final trips = state.acceptedTrips;
        if (trips.isEmpty) {
          return EmptyState(message: l10n.chuyenDiEmptyAccepted);
        }

        return RefreshIndicator(
          color: AppColors.colorPrimary,
          onRefresh: () async {
            context
                .read<ScheduledRideBloc>()
                .add(const ScheduledRideRefreshRequested());
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trip = trips[index];
              return AcceptedTripCard(
                trip: trip,
                typeLabel: _typeLabel(trip.type, l10n),
                isProcessing: state.processingTripId == trip.id,
                pickupLabel: l10n.chuyenDiPickupLabel,
                destinationLabel: l10n.chuyenDiDestinationLabel,
                acceptLabel: l10n.startRideBtn,
                cancelLabel: l10n.chuyenDiBtnCancel,
                onCancel: () => _confirmCancel(context, trip.id, l10n),
                onAccept: () => _confirmCancel(context, trip.id, l10n),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmCancel(
    BuildContext context,
    String tripId,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.chuyenDiCancelConfirmTitle,
          style: AppStyles.inter16SemiBold,
        ),
        content: Text(
          l10n.chuyenDiCancelConfirmBody,
          style: AppStyles.inter14Regular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.chuyenDiConfirmNo,
              style: AppStyles.inter14SemiBold
                  .copyWith(color: AppColors.colorTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<ScheduledRideBloc>()
                  .add(ScheduledRideCancelTrip(tripId));
            },
            child: Text(
              l10n.chuyenDiConfirmYes,
              style: AppStyles.inter14SemiBold
                  .copyWith(color: AppColors.colorTextRed),
            ),
          ),
        ],
      ),
    );
  }
}

String _typeLabel(TripType type, AppLocalizations l10n) {
  switch (type) {
    case TripType.urban:
      return l10n.chuyenDiTypeUrban;
    case TripType.intercity:
      return l10n.chuyenDiTypeIntercity;
    case TripType.airport:
      return l10n.chuyenDiTypeAirport;
  }
}
