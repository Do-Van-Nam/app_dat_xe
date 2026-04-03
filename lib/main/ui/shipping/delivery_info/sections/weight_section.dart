import 'package:demo_app/core/app_export.dart';

import '../bloc/delivery_info_bloc.dart';
import '../delivery_widgets.dart';

class WeightSection extends StatelessWidget {
  const WeightSection({super.key});

  static List<String> _weights(AppLocalizations l10n) => [
        l10n.weight0to5,
        l10n.weight5to10,
        l10n.weight10to15,
        l10n.weight15to20,
        l10n.weight20to25,
        l10n.weight25to30,
        l10n.weight30to50,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected =
        context.select((DeliveryInfoBloc b) => b.state.selectedWeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.orderWeight, style: AppStyles.inter15SemiBold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weights(l10n)
              .map(
                (w) => SelectableChip(
                  label: w,
                  selected: selected == w,
                  onTap: () =>
                      context.read<DeliveryInfoBloc>().add(WeightSelected(w)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
