part of 'order_tracking_bloc.dart';

enum TrackingStatus { initial, loading, success, failure }

class OrderTrackingState extends Equatable {
  const OrderTrackingState({
    this.trackingStatus = TrackingStatus.initial,
    this.currentStep = OrderStep.delivering,
    this.selectedTab = NavTab.activity,
    this.orderCode = '#FUD-88291',
    this.estimatedMinutes = 12,
    this.driver = const DriverInfo(
      name: 'Nguyễn Văn Nam',
      rating: 4.9,
      totalTrips: 1240,
      vehicle: 'Yamaha Exciter',
      plateNumber: '59-A1 123.45',
      avatarAsset: 'assets/images/driver_avatar.jpg',
    ),
    this.items = const [
      TrackingOrderItem(
        qty: 1,
        name: 'Phở Bái Tái Lăn',
        variant: 'Thêm hành, ít bánh',
        price: 65000,
      ),
      TrackingOrderItem(
        qty: 2,
        name: 'Quẩy Giòn',
        variant: 'Túi giấy',
        price: 10000,
      ),
    ],
    this.address = const TrackingAddress(
      buildingName: 'Tòa nhà Landmark 81',
      detail: '720A Điện Biên Phủ, Phường 22, Bình Thạnh, TP.HCM',
    ),
    this.shippingFee = 15000,
    this.restaurantName = 'Phở Thin Lò Đúc',
    this.driverDistance = '1.2km',
  });

  final TrackingStatus trackingStatus;
  final OrderStep currentStep;
  final NavTab selectedTab;
  final String orderCode;
  final int estimatedMinutes;
  final DriverInfo driver;
  final List<TrackingOrderItem> items;
  final TrackingAddress address;
  final int shippingFee;
  final String restaurantName;
  final String driverDistance;

  int get subtotal => items.fold(0, (sum, i) => sum + i.price);
  int get grandTotal => subtotal + shippingFee;

  OrderTrackingState copyWith({
    TrackingStatus? trackingStatus,
    OrderStep? currentStep,
    NavTab? selectedTab,
    String? orderCode,
    int? estimatedMinutes,
    DriverInfo? driver,
    List<TrackingOrderItem>? items,
    TrackingAddress? address,
    int? shippingFee,
    String? restaurantName,
    String? driverDistance,
  }) {
    return OrderTrackingState(
      trackingStatus: trackingStatus ?? this.trackingStatus,
      currentStep: currentStep ?? this.currentStep,
      selectedTab: selectedTab ?? this.selectedTab,
      orderCode: orderCode ?? this.orderCode,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      driver: driver ?? this.driver,
      items: items ?? this.items,
      address: address ?? this.address,
      shippingFee: shippingFee ?? this.shippingFee,
      restaurantName: restaurantName ?? this.restaurantName,
      driverDistance: driverDistance ?? this.driverDistance,
    );
  }

  @override
  List<Object?> get props => [
        trackingStatus,
        currentStep,
        selectedTab,
        orderCode,
        estimatedMinutes,
        driver,
        items,
        address,
        shippingFee,
        restaurantName,
        driverDistance,
      ];
}
