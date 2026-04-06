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

    return BlocBuilder<RateTripBloc, RateTripState>(
      buildWhen: (p, c) => p.review != c.review,
      builder: (context, state) {
        final review = state.review;
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
