import 'package:demo_app/core/app_export.dart';

import '../bloc/delivery_info_bloc.dart';
import '../delivery_widgets.dart';

class GoodsTypeSection extends StatelessWidget {
  const GoodsTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected =
        context.select((DeliveryInfoBloc b) => b.state.selectedGoodsType);

    final types = [
      _GoodsTypeItem(label: l10n.food, icon: AppImages.icFood),
      _GoodsTypeItem(label: l10n.packaging, icon: AppImages.icBox),
      _GoodsTypeItem(label: l10n.electronics, icon: AppImages.icElectronics),
      _GoodsTypeItem(label: l10n.other, icon: AppImages.icOther),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.goodsType, style: AppStyles.inter15SemiBold),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: types
                .map(
                  (t) => GoodsTypeChip(
                    label: t.label,
                    iconPath: t.icon,
                    selected: selected == t.label,
                    onTap: () => context
                        .read<DeliveryInfoBloc>()
                        .add(GoodsTypeSelected(t.label)),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _GoodsTypeItem {
  const _GoodsTypeItem({required this.label, required this.icon});
  final String label;
  final String icon;
}
