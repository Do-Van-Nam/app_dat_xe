import 'package:demo_app/core/app_export.dart';

import 'bloc/membership_bloc.dart';
import 'membership_widgets.dart';
import 'sections/info_note_section.dart';
import 'sections/plan_list_section.dart';
import 'sections/total_payment_section.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MembershipBloc()..add(const MembershipLoaded()),
      child: const _MembershipView(),
    );
  }
}

class _MembershipView extends StatelessWidget {
  const _MembershipView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<MembershipBloc, MembershipState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == MembershipStatus.registered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng ký thành công! 🎉'),
              backgroundColor: AppColors.color27AE60,
              duration: const Duration(seconds: 2),
            ),
          );
          context.push(PATH_DRIVER_TOPUP);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: _buildAppBar(context, l10n),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // ── Scrollable content ─────────────────────────────────────
              Expanded(
                child: BlocBuilder<MembershipBloc, MembershipState>(
                  builder: (context, state) {
                    if (state.status == MembershipStatus.loading ||
                        state.status == MembershipStatus.initial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.color1A56DB,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        children: const [
                          // Section 1: Plan list
                          PlanListSection(),
                          SizedBox(height: 20),

                          // Section 2: Info note
                          InfoNoteSection(),
                          SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Bottom bar: total + CTA ────────────────────────────────
              _BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          context.read<MembershipBloc>().add(const BackTapped());
          Navigator.of(context).maybePop();
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SvgPicture.asset(
            AppImages.icArrowBack,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.color1A56DB,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(
        l10n.membershipTitle,
        style: AppStyles.inter18SemiBold.copyWith(
          color: AppColors.color1A56DB,
        ),
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppImages.icBell,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppColors.color1A1A1A,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ── Bottom bar ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRegistering = context.select(
      (MembershipBloc b) => b.state.status == MembershipStatus.registering,
    );

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total payment row
          const TotalPaymentSection(),
          const SizedBox(height: 14),

          // Register CTA
          RegisterButton(
            label: l10n.registerNow,
            isLoading: isRegistering,
            onPressed: () =>
                context.read<MembershipBloc>().add(const RegisterTapped()),
          ),
        ],
      ),
    );
  }
}
