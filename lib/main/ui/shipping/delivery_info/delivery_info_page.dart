import 'package:demo_app/core/app_export.dart';

import 'bloc/delivery_info_bloc.dart';
import 'delivery_widgets.dart';
import 'sections/banner_section.dart';
import 'sections/goods_type_section.dart';
import 'sections/receiver_section.dart';
import 'sections/sender_section.dart';
import 'sections/weight_section.dart';

class DeliveryInfoPage extends StatelessWidget {
  const DeliveryInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeliveryInfoBloc(),
      child: const _DeliveryInfoView(),
    );
  }
}

class _DeliveryInfoView extends StatelessWidget {
  const _DeliveryInfoView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<DeliveryInfoBloc, DeliveryInfoState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == DeliveryInfoStatus.success) {
          // Navigate to next screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tiếp tục thành công!')),
          );
        } else if (state.status == DeliveryInfoStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.colorE53E3E,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorF9F9FC,
        appBar: _buildAppBar(context, l10n),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SenderSection(),
                      SizedBox(height: 16),
                      ReceiverSection(),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: ShapeDecoration(
                          color: AppColors.colorFFFFFF,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            WeightSection(),
                            SizedBox(height: 16),
                            GoodsTypeSection(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      BannerSection(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _BottomContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      backgroundColor: AppColors.colorFFFFFF,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.close, color: AppColors.color333333, size: 22),
        ),
      ),
      title: Text(
        l10n.deliveryInfo,
        style: AppStyles.inter18SemiBold,
      ),
      centerTitle: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Continue Button
// ─────────────────────────────────────────────────────────────────────────────
class _BottomContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: AppColors.colorFFFFFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: PrimaryButton(
        label: l10n.continueBtn,
        trailing: const Icon(Icons.arrow_forward,
            color: AppColors.colorFFFFFF, size: 20),
        onPressed: () =>
            context.read<DeliveryInfoBloc>().add(const ContinueTapped()),
      ),
    );
  }
}
