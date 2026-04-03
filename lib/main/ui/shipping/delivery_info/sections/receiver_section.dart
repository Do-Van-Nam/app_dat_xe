import 'package:demo_app/core/app_export.dart';

import '../bloc/delivery_info_bloc.dart';
import '../delivery_widgets.dart';

class ReceiverSection extends StatelessWidget {
  const ReceiverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          label: l10n.receiver,
          iconPath: AppImages.icLocationFill,
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            // Address row
            Container(
              // padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: const Color(0x7FEFF6FF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFDBEAFE),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  _AddressRow(),
                  const Divider(height: 1, color: AppColors.colorEEEEEE),

                  // Delivery note input
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _DeliveryNoteField(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.colorEEEEEE),
            const SizedBox(
              height: 12,
            ),
            // Receiver name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWithRequired(label: l10n.receiverName),
                const SizedBox(height: 6),
                _ReceiverNameField(),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            // Receiver phone
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWithRequired(label: l10n.receiverPhone),
                const SizedBox(height: 6),
                _ReceiverPhoneField(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Address row widget ────────────────────────────────────────────────────────
class _AddressRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = context.select(
      (DeliveryInfoBloc b) => b.state.receiverAddress,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: AppTextField(
        hint: address,
        maxLines: 1,
        minLines: 1,
        onChanged: (v) =>
            context.read<DeliveryInfoBloc>().add(DeliveryNoteChanged(v)),
        suffix: GestureDetector(
          onTap: () =>
              context.read<DeliveryInfoBloc>().add(const ChangeAddressTapped()),
          child: Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Text(
              l10n.change,
              style: AppStyles.inter14Medium.copyWith(
                color: AppColors.color1A56DB,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Delivery note field ───────────────────────────────────────────────────────
class _DeliveryNoteField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppTextField(
      hint: l10n.addDeliveryNote,
      maxLines: 2,
      minLines: 2,
      onChanged: (v) =>
          context.read<DeliveryInfoBloc>().add(DeliveryNoteChanged(v)),
    );
  }
}

// ── Receiver name field ───────────────────────────────────────────────────────
class _ReceiverNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppTextField(
      hint: l10n.receiverNameHint,
      onChanged: (v) =>
          context.read<DeliveryInfoBloc>().add(ReceiverNameChanged(v)),
    );
  }
}

// ── Receiver phone field ──────────────────────────────────────────────────────
class _ReceiverPhoneField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppTextField(
      hint: l10n.receiverPhoneHint,
      keyboardType: TextInputType.phone,
      onChanged: (v) =>
          context.read<DeliveryInfoBloc>().add(ReceiverPhoneChanged(v)),
    );
  }
}
