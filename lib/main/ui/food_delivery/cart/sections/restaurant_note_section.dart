import 'package:demo_app/core/app_export.dart';

import '../bloc/cart_bloc.dart';

class RestaurantNoteSection extends StatelessWidget {
  const RestaurantNoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.restaurantNote, style: AppStyles.inter15SemiBold),
          const SizedBox(height: 8),
          _NoteTextField(),
        ],
      ),
    );
  }
}

class _NoteTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorF3F4F6,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          TextField(
            onChanged: (v) =>
                context.read<CartBloc>().add(RestaurantNoteChanged(v)),
            maxLines: 3,
            style: AppStyles.inter14Regular,
            decoration: InputDecoration(
              hintText: l10n.restaurantNoteHint,
              hintStyle: AppStyles.inter14Regular
                  .copyWith(color: AppColors.colorBDBDBD),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 36),
            ),
          ),
          // "GHI CHÚ" label at bottom-right
          Positioned(
            right: 12,
            bottom: 10,
            child: Text(
              l10n.noteLabel,
              style: AppStyles.inter11SemiBold
                  .copyWith(color: AppColors.color999999, letterSpacing: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
