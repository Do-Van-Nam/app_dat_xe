import 'package:demo_app/main/data/repository/finance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'points_wallet_event.dart';
part 'points_wallet_state.dart';

class PointsWalletBloc extends Bloc<PointsWalletEvent, PointsWalletState> {
  final FinanceRepository _financeRepository = FinanceRepository();

  PointsWalletBloc() : super(PointsWalletInitial()) {
    on<LoadPointsWalletEvent>(_onLoadPointsWallet);
  }

  Future<void> _onLoadPointsWallet(
      LoadPointsWalletEvent event, Emitter<PointsWalletState> emit) async {
    emit(PointsWalletLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 900));

      final redeemList = [
        RedeemItem(
          id: "1",
          title: "Voucher Burger King 50k",
          subtitle:
              "Áp dụng cho toàn bộ thực đơn tại hệ thống của hàng Burger King toàn quốc.",
          pointsRequired: 350,
          imageUrl: "https://picsum.photos/id/1080/600/300",
          tag: "HOT DEAL",
        ),
        RedeemItem(
          id: "2",
          title: "Giảm giá 50% chuyến đi tỉnh",
          subtitle: "",
          pointsRequired: 200,
          imageUrl: "https://picsum.photos/id/201/300/200",
        ),
        RedeemItem(
          id: "3",
          title: "Chuyến xe sân bay đồng giá 50k",
          subtitle: "",
          pointsRequired: 150,
          imageUrl: "https://picsum.photos/id/180/300/200",
        ),
      ];

      final activityList = [
        RecentActivity(
          title: "Hoàn tất chuyến xe #3942",
          time: "Hôm nay, 14:20",
          points: 25,
          isPositive: true,
        ),
        RecentActivity(
          title: "Đổi ưu đãi Highlands Coffee",
          time: "Hôm qua, 09:15",
          points: -100,
          isPositive: false,
        ),
        RecentActivity(
          title: "Thưởng nhiệm vụ hàng ngày",
          time: "12 Th08, 2023",
          points: 10,
          isPositive: true,
        ),
      ];
      final (success, pointWallet) = await _financeRepository.getPointWallet();
      if (success && pointWallet != null) {
        emit(PointsWalletLoaded(
          totalPoints: pointWallet.currentBalance,
          membershipTier: "Vàng (Gold)",
          redeemItems: redeemList,
          recentActivities: activityList,
        ));
      } else {
        emit(PointsWalletError("Không thể tải ví điểm thưởng"));
      }
      // emit(PointsWalletLoaded(
      //   totalPoints: 1250,
      //   membershipTier: "Vàng (Gold)",
      //   redeemItems: redeemList,
      //   recentActivities: activityList,
      // ));
    } catch (e) {
      emit(PointsWalletError("Không thể tải ví điểm thưởng"));
    }
  }
}
