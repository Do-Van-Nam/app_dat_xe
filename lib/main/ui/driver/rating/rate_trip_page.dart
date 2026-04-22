import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';

import 'bloc/rate_trip_bloc.dart';
import 'sections/earning_detail_section.dart';
import 'sections/hero_card_section.dart';
import 'sections/map_section.dart';
import 'sections/review_section.dart';
import 'sections/route_section.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class RateTripPage extends StatelessWidget {
  const RateTripPage({super.key, required this.rideId});
  final String rideId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RateTripBloc(rideId: rideId)..add(RateTripLoaded()),
      child: const _RateTripView(),
    );
  }
}

class _RateTripView extends StatelessWidget {
  const _RateTripView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<RateTripBloc, RateTripState>(
        listenWhen: (p, c) =>
            p.status != c.status || p.errorMessage != c.errorMessage,
        listener: (context, state) {
          if (state.status == RateTripStatus.error &&
              state.errorMessage != null) {
            AppToast.show(context, state.errorMessage!.message);
          }
          if (state.status == RateTripStatus.confirmed) {
            // TODO: navigate to home / ready-for-next-trip screen
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == RateTripStatus.loading || state.trip == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final trip = state.trip!;
          return Scaffold(
            backgroundColor: AppColors.colorBackground,
            appBar: _RateTripAppBar(title: l10n.hoanTatAppBarTitle),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroCardSection(trip: trip),
                        SizedBox(height: 20),
                        RouteSection(trip: trip),
                        SizedBox(height: 16),
                        MapSection(trip: trip),
                        SizedBox(height: 16),
                        EarningDetailSection(trip: trip),
                        SizedBox(height: 16),
                        ReviewSection(),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const _ConfirmButtonSection(),
              ],
            ),
          );
        });
  }
}
// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _RateTripAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _RateTripAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorAppBarBg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.colorAppBarTitle,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.colorAppBarTitle,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM – CONFIRM BUTTON
// ═══════════════════════════════════════════════════════════════

class _ConfirmButtonSection extends StatelessWidget {
  const _ConfirmButtonSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadowMd,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BlocBuilder<RateTripBloc, RateTripState>(
        buildWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          final isLoading = state.status == RateTripStatus.confirming;
          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<RateTripBloc>()
                      .add(const RateTripConfirmTapped()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorConfirmBtnBg,
                disabledBackgroundColor:
                    AppColors.colorConfirmBtnBg.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.colorConfirmBtnText,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.hoanTatConfirmButton,
                          style: AppStyles.inter16SemiBold.copyWith(
                            color: AppColors.colorConfirmBtnText,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          AppImages.icBolt,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.colorConfirmBtnText,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
