import 'package:demo_app/core/app_export.dart';

import '../bloc/membership_bloc.dart';

class TotalPaymentSection extends StatelessWidget {
  const TotalPaymentSection({super.key});

  String _fmt(int price) =>
      price.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          ) +
      'đ';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = context.select((MembershipBloc b) => b.state.selectedPlan);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.totalPayment,
          style: AppStyles.inter16Bold,
        ),
        Text(
          selected != null ? _fmt(selected.price) : '—',
          style: AppStyles.inter32ExtraBold,
        ),
      ],
    );
  }
}
