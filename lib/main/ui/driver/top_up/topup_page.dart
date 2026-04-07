import 'package:demo_app/core/app_export.dart';

import 'bloc/topup_bloc.dart';
import 'sections/amount_input_section.dart';
import 'sections/info_note_section.dart';
import 'sections/payment_method_section.dart';
import 'topup_widgets.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopUpBloc()..add(const TopUpInitialized()),
      child: const _TopUpView(),
    );
  }
}

class _TopUpView extends StatelessWidget {
  const _TopUpView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<TopUpBloc, TopUpState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == TopUpStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nạp tiền thành công! 🎉'),
              backgroundColor: AppColors.color1A56DB,
              duration: const Duration(seconds: 2),
            ),
          );
          context.push(PATH_PAYMENT_SUCCESS);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.colorF9F9FC,
          appBar: _buildAppBar(context, l10n),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // ── Scrollable body ─────────────────────────────────────
                Expanded(
                  child: BlocBuilder<TopUpBloc, TopUpState>(
                    buildWhen: (prev, curr) =>
                        prev.status != curr.status ||
                        prev.methods.length != curr.methods.length,
                    builder: (context, state) {
                      if (state.methods.isEmpty) {
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
                            // Section 1: Amount input
                            AmountInputSection(),
                            SizedBox(height: 24),

                            // Section 2: Payment method list
                            PaymentMethodSection(),
                            SizedBox(height: 20),

                            // Section 3: Info note
                            InfoNoteSection(),
                            SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Bottom CTA bar ──────────────────────────────────────
                _BottomBar(),
              ],
            ),
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
        onTap: () => Navigator.of(context).maybePop(),
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
        l10n.topUpTitle,
        style: AppStyles.inter18SemiBold,
      ),
      centerTitle: false,
    );
  }
}

// ── Bottom bar ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<TopUpBloc>().state;
    final isConfirming = state.status == TopUpStatus.confirming;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CTA button
            ConfirmTopUpButton(
              label: l10n.confirmTopUp,
              isLoading: isConfirming,
              onPressed: () =>
                  context.read<TopUpBloc>().add(const TopUpConfirmed()),
            ),

            const SizedBox(height: 10),

            // Secure SSL badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppImages.icShieldSecure,
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorSecureIcon,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  l10n.secureLabel,
                  style: AppStyles.inter10SemiBold,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
