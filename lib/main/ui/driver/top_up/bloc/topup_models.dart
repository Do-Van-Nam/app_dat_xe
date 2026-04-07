enum PaymentMethodId { momo, zalopay, atm, bankTransfer }

enum PaymentMethodGroup { eWallet, bank }

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
    required this.group,
    required this.iconPath,
    this.subLabel,
    this.hasArrow = false,
  });

  final PaymentMethodId id;
  final String name;
  final PaymentMethodGroup group;
  final String iconPath;
  final String? subLabel;   // e.g. "Miễn phí giao dịch"
  final bool hasArrow;      // bank rows show a chevron instead of radio
}
