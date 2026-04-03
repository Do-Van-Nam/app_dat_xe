import 'package:demo_app/core/app_export.dart';

import '../delivery_widgets.dart';

class SenderSection extends StatelessWidget {
  const SenderSection({super.key});

  // Sender info is typically static / fetched from user profile.
  static const String _senderName = 'Nam Huy';
  static const String _senderPhone = '+84964270626';
  static const String _senderAddress =
      '5 Ngách 3 Ngõ 58 Trần Vỹ, P. Mai Dịch, Q. Cầu Giấy, Hà Nội';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          label: l10n.sender,
          iconPath: AppImages.icLocationPin,
        ),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + Phone row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_senderName, style: AppStyles.inter16Bold),
                  Text(
                    _senderPhone,
                    style: AppStyles.inter14Medium.copyWith(
                      color: AppColors.color666666,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _senderAddress,
                style: AppStyles.inter13Regular.copyWith(
                  color: AppColors.color666666,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
