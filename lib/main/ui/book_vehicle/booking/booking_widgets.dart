import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/book_vehicle/booking/booking_bloc.dart';

class PromoCodeButton extends StatelessWidget {
  final AppLocalizations l10n;

  const PromoCodeButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppImages.icVoucher),
            const SizedBox(width: 8),
            Text(l10n.promoCode, style: AppStyles.inter14Medium),
          ],
        ),
      ),
    );
  }
}

class VehicleOptionCard extends StatelessWidget {
  final VehicleOption vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleOptionCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : AppColors.color_F3F3F6,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(vehicle.icon, height: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (vehicle.tag.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: Container(
                            // width: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: vehicle.tagColor?.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              vehicle.tag,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: vehicle.tagColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      SvgPicture.asset(AppImages.icClock, height: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        flex: 1,
                        child: Text(vehicle.time,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "${vehicle.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSection extends StatefulWidget {
  final AppLocalizations l10n;

  const PaymentMethodSection({required this.l10n});

  @override
  State<PaymentMethodSection> createState() => PaymentMethodSectionState();
}

class PaymentMethodSectionState extends State<PaymentMethodSection> {
  String _selectedMethod = "Tiền mặt";

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đổi phương thức thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.color_F3F3F6,
                  child: SvgPicture.asset(AppImages.icMoney, height: 16),
                ),
                title: const Text("Tiền mặt",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedMethod == "Tiền mặt"
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedMethod = "Tiền mặt";
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.color_F3F3F6,
                  child:
                      Icon(Icons.account_balance, color: Colors.blue, size: 20),
                ),
                title: const Text("Chuyển khoản",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedMethod == "Chuyển khoản"
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedMethod = "Chuyển khoản";
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPaymentMethodSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.color_F3F3F6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: _selectedMethod == "Tiền mặt"
                  ? SvgPicture.asset(AppImages.icMoney, height: 16)
                  : const Icon(Icons.account_balance,
                      color: Colors.blue, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_selectedMethod,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const Text(
              "THAY ĐỔI",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final int totalAmount;
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  const _ConfirmButton({
    required this.totalAmount,
    required this.l10n,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = totalAmount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        "${l10n.confirmBooking} →",
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
