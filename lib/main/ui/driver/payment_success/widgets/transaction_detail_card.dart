import 'package:demo_app/core/app_export.dart';

/// White card showing transaction detail rows with header + status badge.
class TransactionDetailCard extends StatelessWidget {
  const TransactionDetailCard({
    super.key,
    required this.sectionLabel,
    required this.statusBadgeLabel,
    required this.rows,
  });

  final String sectionLabel;
  final String statusBadgeLabel;
  final List<TxDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.colorTxCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colorTxCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: section label + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionLabel,
                style: AppStyles.inter11SemiBold.copyWith(
                  color: AppColors.colorTxSectionLabel,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.colorSuccessBadgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusBadgeLabel,
                  style: AppStyles.inter11SemiBold.copyWith(
                    color: AppColors.colorSuccessBadgeText,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Detail rows with dividers
          ...rows.asMap().entries.expand((entry) {
            final isLast = entry.key == rows.length - 1;
            return [
              _TxRow(row: entry.value),
              if (!isLast)
                const Divider(height: 20, color: AppColors.colorTxDivider),
            ];
          }),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.row});
  final TxDetailRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: AppStyles.inter14Regular.copyWith(
              color: AppColors.colorTxLabelText,
            ),
          ),
        ),
        // Optional leading widget (e.g. MoMo logo)
        if (row.leadingWidget != null) ...[
          row.leadingWidget!,
          const SizedBox(width: 6),
        ],
        Text(
          row.value,
          style: row.valueStyle ??
              AppStyles.inter14SemiBold.copyWith(
                color: AppColors.colorTxValueText,
              ),
        ),
      ],
    );
  }
}

/// Data model for a single transaction detail row.
class TxDetailRow {
  const TxDetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.leadingWidget,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Widget? leadingWidget;
}
