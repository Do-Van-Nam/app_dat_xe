import 'package:demo_app/core/app_export.dart';

class PaymentDetails extends StatelessWidget {
  final int baseFare;
  final int serviceFee;
  final int discount;
  final int totalAmount;
  final AppLocalizations l10n;

  const PaymentDetails({
    super.key,
    required this.baseFare,
    required this.serviceFee,
    required this.discount,
    required this.totalAmount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBase = _formatPrice(baseFare);
    final formattedService = _formatPrice(serviceFee);
    final formattedDiscount = _formatPrice(discount);
    final formattedTotal = _formatPrice(totalAmount);

    return CommonCard(
      color: AppColors.colorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CHI TIẾT THANH TOÁN",
            style: AppStyles.inter16SemiBold,
          ),
          const SizedBox(height: 16),
          _PaymentRow("Giá cước cơ bản", "$formattedBaseđ"),
          _PaymentRow("Phí dịch vụ", "$formattedServiceđ"),
          _PaymentRow(
            "Giảm giá (Ưu đãi đi làm)",
            "-$formattedDiscountđ",
            valueColor: Colors.green,
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/ic_wallet.svg',
                      width: 20), // Bạn có thể thay icon
                  const SizedBox(width: 8),
                  Text("Tổng cộng", style: AppStyles.inter16SemiBold),
                ],
              ),
              Text(
                "$formattedTotalđ",
                style: AppStyles.inter20Bold
                    .copyWith(color: AppColors.primaryBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PaymentRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.inter14Medium),
          Text(
            value,
            style: AppStyles.inter14Medium.copyWith(
              color: valueColor ?? Colors.black87,
              fontWeight:
                  valueColor != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
