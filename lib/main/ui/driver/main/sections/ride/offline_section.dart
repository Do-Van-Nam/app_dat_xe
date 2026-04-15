import 'package:demo_app/core/app_export.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_widgets.dart';

class OfflineSection extends StatelessWidget {
  const OfflineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DriverBloc>().state;

    return Stack(
      children: [
        // ── Full-screen map ──────────────────────────────────────────────
        // const Positioned.fill(child: MapBackground()),

        // ── Stats card (top) ─────────────────────────────────────────────
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.todayIncome, style: AppStyles.inter11SemiBold),
                      const SizedBox(height: 4),
                      Text('${_fmt(state.todayIncome)}đ',
                          style: AppStyles.inter24ExtraBold
                              .copyWith(color: AppColors.color1A1A1A)),
                    ],
                  ),
                ),
                const VerticalDivider(width: 32, color: AppColors.colorDivider),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalTrips, style: AppStyles.inter11SemiBold),
                    const SizedBox(height: 4),
                    Text('${state.totalTrips}',
                        style: AppStyles.inter24ExtraBold
                            .copyWith(color: AppColors.color1A1A1A)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Offline badge ────────────────────────────────────────────────
        Positioned(
          bottom: 160,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.color_E2E2E5,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppImages.icOfflineCloud,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_434653, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.youAreOffline,
                    style: AppStyles.inter13Medium
                        .copyWith(color: AppColors.color_434653),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── BẬT button ───────────────────────────────────────────────────
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () =>
                  context.read<DriverBloc>().add(const ToggleOnlineStatus()),
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color163172,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color1A56DB,
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.turnOn,
                  style: AppStyles.inter18Bold
                      .copyWith(color: AppColors.colorFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(int price) => price == 0
      ? '0'
      : price.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          );
}
