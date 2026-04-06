part of 'rate_trip_bloc.dart';

enum RateTripStatus { initial, confirming, confirmed, error }

class EarningDetail extends Equatable {
  const EarningDetail({
    required this.baseFare,
    required this.serviceFeeDiscount,
    required this.serviceFeeValue,
    required this.totalEarning,
  });

  final String baseFare;
  final String serviceFeeDiscount;
  final String serviceFeeValue;
  final String totalEarning;

  @override
  List<Object?> get props =>
      [baseFare, serviceFeeDiscount, serviceFeeValue, totalEarning];
}

class TripSummary extends Equatable {
  const TripSummary({
    required this.heroAmount,
    required this.heroDuration,
    required this.heroDistance,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.mapDistanceValue,
    required this.mapDurationValue,
    required this.earning,
  });

  final String heroAmount;
  final String heroDuration;
  final String heroDistance;
  final String pickupAddress;
  final String destinationAddress;
  final String mapDistanceValue;
  final String mapDurationValue;
  final EarningDetail earning;

  @override
  List<Object?> get props => [
        heroAmount,
        heroDuration,
        heroDistance,
        pickupAddress,
        destinationAddress,
        mapDistanceValue,
        mapDurationValue,
        earning,
      ];
}

class CustomerReview extends Equatable {
  const CustomerReview({
    required this.reviewerName,
    required this.reviewerType,
    required this.comment,
    required this.rating,
    this.avatarUrl = '',
  });

  final String reviewerName;
  final String reviewerType;
  final String comment;
  final int rating; // 1-5
  final String avatarUrl;

  @override
  List<Object?> get props =>
      [reviewerName, reviewerType, comment, rating, avatarUrl];
}

class RateTripState extends Equatable {
  const RateTripState({
    this.status = RateTripStatus.initial,
    this.trip = const TripSummary(
      heroAmount: '45.000đ',
      heroDuration: '15 phút',
      heroDistance: '3.5km',
      pickupAddress: '221B Baker Street, Phường Võ Thị Sáu, Quận 3',
      destinationAddress: 'Landmark 81, Vinhomes Central Park, Bình Thạnh',
      mapDistanceValue: '3.5km',
      mapDurationValue: '15 ph',
      earning: EarningDetail(
        baseFare: '52.000đ',
        serviceFeeDiscount: '-15%',
        serviceFeeValue: '-7.000đ',
        totalEarning: '45.000đ',
      ),
    ),
    this.review = const CustomerReview(
      reviewerName: 'Nguyễn Thu Thảo',
      reviewerType: 'Khách hàng thân thiết',
      comment: '"Tài xế rất lịch sự và nhiệt tình, xe sạch sẽ."',
      rating: 5,
    ),
    this.errorMessage,
  });

  final RateTripStatus status;
  final TripSummary trip;
  final CustomerReview review;
  final String? errorMessage;

  RateTripState copyWith({
    RateTripStatus? status,
    TripSummary? trip,
    CustomerReview? review,
    String? errorMessage,
  }) {
    return RateTripState(
      status: status ?? this.status,
      trip: trip ?? this.trip,
      review: review ?? this.review,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, trip, review, errorMessage];
}
