part of 'driver_bloc.dart';

class DriverState extends Equatable {
  const DriverState({
    this.screen = DriverScreen.offline,
    this.selectedTab = NavTab.orders,
    this.todayIncome = 0,
    this.totalTrips = 0,
    this.currentOffer,
    this.countdownSeconds = 15,
    this.customer = const CustomerInfo(
      name: 'Nam Huy',
      rating: 4.9,
      paymentMethod: 'Thanh toán tiền mặt',
      pickupAddress: '81 Tôn Thất Tùng, Phường Phạm Ngũ...',
    ),
    this.activeCustomer = const CustomerInfo(
      name: 'Nguyễn Minh Hoàng',
      rating: 4.9,
      paymentMethod: 'Tiền mặt',
      pickupAddress: '123 Lê Lợi, Q1',
      isVip: true,
      avatarAsset: 'assets/images/driver_avatar.jpg',
    ),
    this.distanceToPickupM = 800,
    this.estimatedMinutes = 3,
    this.tripMinutes = 12,
    this.tripKm = 3.5,
    this.tripEta = '14:45',
    this.error,
  });

  final DriverScreen screen;
  final NavTab selectedTab;
  final int todayIncome; // VND
  final int totalTrips;
  final RideOffer? currentOffer;
  final int countdownSeconds;
  final CustomerInfo customer; // pickup customer
  final CustomerInfo activeCustomer; // in-trip customer
  final int distanceToPickupM;
  final int estimatedMinutes;
  final int tripMinutes;
  final double tripKm;
  final String tripEta;
  final UniqueError? error;

  bool get isOnline => screen != DriverScreen.offline;

  DriverState copyWith({
    DriverScreen? screen,
    NavTab? selectedTab,
    int? todayIncome,
    int? totalTrips,
    RideOffer? currentOffer,
    bool clearOffer = false,
    int? countdownSeconds,
    CustomerInfo? customer,
    CustomerInfo? activeCustomer,
    int? distanceToPickupM,
    int? estimatedMinutes,
    int? tripMinutes,
    double? tripKm,
    String? tripEta,
    UniqueError? error,
  }) {
    return DriverState(
      screen: screen ?? this.screen,
      selectedTab: selectedTab ?? this.selectedTab,
      todayIncome: todayIncome ?? this.todayIncome,
      totalTrips: totalTrips ?? this.totalTrips,
      currentOffer: clearOffer ? null : (currentOffer ?? this.currentOffer),
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      customer: customer ?? this.customer,
      activeCustomer: activeCustomer ?? this.activeCustomer,
      distanceToPickupM: distanceToPickupM ?? this.distanceToPickupM,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tripMinutes: tripMinutes ?? this.tripMinutes,
      tripKm: tripKm ?? this.tripKm,
      tripEta: tripEta ?? this.tripEta,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        screen,
        selectedTab,
        todayIncome,
        totalTrips,
        currentOffer,
        countdownSeconds,
        customer,
        activeCustomer,
        distanceToPickupM,
        estimatedMinutes,
        tripMinutes,
        tripKm,
        tripEta,
        error,
      ];
}
