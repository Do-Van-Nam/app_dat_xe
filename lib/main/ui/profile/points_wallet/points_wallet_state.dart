part of 'points_wallet_bloc.dart';

@immutable
sealed class PointsWalletState {}

final class PointsWalletInitial extends PointsWalletState {}

final class PointsWalletLoading extends PointsWalletState {}

final class PointsWalletLoaded extends PointsWalletState {
  final int totalPoints;
  final String membershipTier; // Vàng (Gold)
  final List<RedeemItem> redeemItems;
  final List<RecentActivity> recentActivities;

  PointsWalletLoaded({
    required this.totalPoints,
    required this.membershipTier,
    required this.redeemItems,
    required this.recentActivities,
  });
}

final class PointsWalletError extends PointsWalletState {
  final String message;
  PointsWalletError(this.message);
}

// Model
class RedeemItem {
  final String id;
  final String title;
  final String subtitle;
  final int pointsRequired;
  final String imageUrl;
  final String? tag; // HOT DEAL

  RedeemItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pointsRequired,
    required this.imageUrl,
    this.tag,
  });
}

class RecentActivity {
  final String title;
  final String time;
  final int points;
  final bool isPositive;

  RecentActivity({
    required this.title,
    required this.time,
    required this.points,
    required this.isPositive,
  });
}
