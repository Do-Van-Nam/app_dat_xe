import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/rating/bloc/rate_trip_bloc.dart';

import '../widgets/app_outlined_card.dart';
import '../widgets/section_label.dart';
import '../widgets/star_rating.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const review = CustomerReview(
      reviewerName: 'Nguyễn Thu Thảo',
      reviewerType: 'Khách hàng thân thiết',
      comment: '"Tài xế rất lịch sự và nhiệt tình, xe sạch sẽ."',
      rating: 5,
    );
    return BlocBuilder<RateTripBloc, RateTripState>(
      builder: (context, state) {
        // final review = review;
        return AppOutlinedCard(
          child: Column(
            children: [
              // Title
              SectionLabel(label: l10n.hoanTatReviewTitle),
              const SizedBox(height: 16),

              // Reviewer info
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.colorSectionBg,
                    backgroundImage: review.avatarUrl.isNotEmpty
                        ? NetworkImage(review.avatarUrl)
                        : null,
                    child: review.avatarUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 24, color: AppColors.colorTextSecondary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: AppStyles.inter15SemiBold,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        review.reviewerType,
                        style: AppStyles.inter12Regular,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Stars
              StarRating(rating: review.rating, starSize: 32),

              const SizedBox(height: 12),

              // Comment
              Text(
                review.comment,
                textAlign: TextAlign.center,
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.colorReviewQuote,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
