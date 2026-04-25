import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/finance/package.dart';
import 'package:demo_app/main/data/model/finance/top_up.dart';
import 'package:demo_app/main/data/model/finance/point_wallet.dart';
import 'package:demo_app/main/data/model/finance/wallet.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/data/model/finance/spending.dart';
import 'package:demo_app/main/data/model/finance/voucher.dart';
import '../../base/base_response.dart';

class FinanceRepository {
  FinanceRepository._();
  static final FinanceRepository _instance = FinanceRepository._();
  factory FinanceRepository() => _instance;

  Future<Map<String, String>> _authHeader() async {
    final token = await SharePreferenceUtil.getLoginToken();
    return {"Authorization": "Bearer $token"};
  }

  // ============================================================
  // Xem thống kê chi tiêu (UC-23)
  // GET /api/v1/finance/spending-summary
  // ============================================================
  Future<(bool, SpendingModel?)> getSpendingSummary({
    required String range,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = {
      'range': range,
      if (range == 'custom' && startDate != null) 'start_date': startDate,
      if (range == 'custom' && endDate != null) 'end_date': endDate,
    };

    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_SPENDING_SUMMARY,
      params: queryParams,
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, SpendingModel.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getSpendingSummary parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Xem danh sách voucher (UC-21)
  // GET /api/v1/vouchers
  // ============================================================
  Future<(bool, List<Voucher>)> getVouchers({String? serviceType}) async {
    final queryParams = {
      if (serviceType != null) 'service_type': serviceType,
    };

    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_VOUCHERS,
        params: queryParams,
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final rawData = response.data['data'] ?? response.data;

        if (rawData is List) {
          final vouchers = rawData
              .map((e) => Voucher.fromJson(e as Map<String, dynamic>))
              .toList();
          return (true, vouchers);
        }
      }
      return (false, <Voucher>[]);
    } catch (e) {
      print('❌ getVouchers error: $e');
      return (false, <Voucher>[]);
    }
  }

  // ============================================================
  // Xem chi tiết voucher (UC-21)
  // GET /api/v1/vouchers/{id}
  // ============================================================
  Future<(bool, Voucher?)> getVoucherDetail(dynamic id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_VOUCHER_DETAIL(id),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Voucher.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getVoucherDetail parse error: $e');
      }
    }
    return (false, null);
  }

  // ============================================================
  // Lưu voucher (UC-21 A5)
  // POST /api/v1/vouchers/{id}/save
  // ============================================================
  Future<bool> saveVoucher(dynamic id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_SAVE_VOUCHER(id),
      headers: await _authHeader(),
    );

    return response.isSuccess;
  }

  // ============================================================
  // Áp dụng nhanh voucher (UC-22)
  // POST /api/v1/vouchers/{id}/apply-quick
  // ============================================================
  Future<(bool, String?, Voucher?)> quickApplyVoucher(dynamic id) async {
    final BaseResponse response = await ApiUtil.getInstance()!.post(
      url: ApiEndPoint.DOMAIN_APPLY_QUICK_VOUCHER(id),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final targetScreen = data['target_screen'] as String?;
        final voucherRaw = data['voucher'];
        Voucher? voucher;
        if (voucherRaw != null) {
          voucher = Voucher.fromJson(voucherRaw as Map<String, dynamic>);
        }
        return (true, targetScreen, voucher);
      } catch (e) {
        print('❌ quickApplyVoucher parse error: $e');
      }
    }
    return (false, null, null);
  }

  // ============================================================
  // Xem ví điểm (UC-24)
  // GET /api/v1/finance/point-wallet
  // ============================================================
  Future<(bool, PointWallet?)> getPointWallet() async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_REWARDS_OVERVIEW,
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, PointWallet.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getPointWallet parse error: $e');
      }
    }
    return (false, null);
  }

  // Finance  Tài xế
  Future<(bool, WalletManageResponse?)> getWalletManage() async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_WALLET_MANAGE,
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return (
          true,
          WalletManageResponse.fromJson(data as Map<String, dynamic>)
        );
      }

      return (false, null);
    } catch (e, stack) {
      print('❌ getWalletManage error: $e');
      print('Stack trace: $stack');
      return (false, null);
    }
  }

  Future<(bool, List<Package>)> getSubscriptionPackages() async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.get(
        url: ApiEndPoint.DOMAIN_SUBSCRIPTION_PACKAGES,
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final rawData = response.data['data'] ?? response.data;
        if (rawData is List) {
          final packages = rawData
              .map((e) => Package.fromJson(e as Map<String, dynamic>))
              .toList();
          return (true, packages);
        }
      }
      return (false, <Package>[]);
    } catch (e) {
      print('❌ getSubscriptionPackages error: $e');
      return (false, <Package>[]);
    }
  }
  Future<(bool, Transaction?)> getTransactionDetail(dynamic transactionId) async {
    final BaseResponse response = await ApiUtil.getInstance()!.get(
      url: ApiEndPoint.DOMAIN_WALLET_TRANSACTION_DETAIL(transactionId),
      headers: await _authHeader(),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return (true, Transaction.fromJson(data as Map<String, dynamic>));
      } catch (e) {
        print('❌ getTransactionDetail parse error: $e');
      }
    }
    return (false, null);
  }
  Future<(bool, TopUpResponse?)> requestTopUp({
    required num amount,
    required String paymentMethod,
  }) async {
    try {
      final BaseResponse response = await ApiUtil.getInstance()!.post(
        url: ApiEndPoint.DOMAIN_WALLET_TOP_UP,
        body: {
          'amount': amount,
          'payment_method': paymentMethod,
        },
        headers: await _authHeader(),
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'] ?? response.data;
        return (true, TopUpResponse.fromJson(data as Map<String, dynamic>));
      }

      return (false, null);
    } catch (e) {
      print('❌ requestTopUp error: $e');
      return (false, null);
    }
  }
}
