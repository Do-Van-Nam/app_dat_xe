import 'package:demo_app/core/app_export.dart';

import '../../bloc/driver_bloc.dart';
import '../../driver_widgets.dart';

class OnlineSection extends StatelessWidget {
  const OnlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DriverBloc>().state;

    return Stack(
      children: [
        // ── Full-screen map with driver marker ───────────────────────────
        // const Positioned.fill(child: MapBackground()),

        // ── Stats card ───────────────────────────────────────────────────
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
                      Text(
                        '${_fmt(state.todayIncome)}đ',
                        style: AppStyles.inter22Bold,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.totalTrips, style: AppStyles.inter11SemiBold),
                    const SizedBox(height: 4),
                    Text(
                      '${state.totalTrips}',
                      style: AppStyles.inter22Bold,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Stats chart icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.colorEBF3FF,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppImages.icChart,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color1A56DB, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Busy area card ───────────────────────────────────────────────
        Positioned(
          top: 112,
          left: 16,
          right: 16,
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.colorD4F5E2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppImages.icFire,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color27AE60, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.busyArea, style: AppStyles.inter15SemiBold),
                    Text(l10n.busyAreaSub, style: AppStyles.inter12Regular),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Promo / tip banner ───────────────────────────────────────────
        Positioned(
          bottom: 86,
          left: 16,
          right: 16,
          child: GestureDetector(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.colorF5A623,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icLightbulb,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_694600, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.promoHint,
                          style: AppStyles.inter11SemiBold
                              .copyWith(color: AppColors.color_694600),
                        ),
                        Text(
                          l10n.promoSub,
                          style: AppStyles.inter13Medium
                              .copyWith(color: AppColors.color_694600),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    AppImages.icChevronRight,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_694600, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── TẮT button ───────────────────────────────────────────────────
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: GestureDetector(
            onTap: () =>
                context.read<DriverBloc>().add(const ToggleOnlineStatus()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.colorFF3B30,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.icPower,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.colorFFFFFF, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.turnOff,
                      style: AppStyles.inter16Bold
                          .copyWith(color: AppColors.colorFFFFFF)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
