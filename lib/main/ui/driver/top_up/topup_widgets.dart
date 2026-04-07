import 'package:demo_app/core/app_export.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AmountChip — quick-select preset button
// ─────────────────────────────────────────────────────────────────────────────
class AmountChip extends StatelessWidget {
  const AmountChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.colorChipSelectedBg
              : AppColors.colorChipUnselectedBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.colorChipSelectedBg
                : AppColors.colorChipBorder,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.inter20SemiBold.copyWith(
            color: selected
                ? AppColors.colorChipSelectedText
                : AppColors.colorChipUnselectedText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GroupHeader — grey section row (e.g. "VÍ ĐIỆN TỬ")
// ─────────────────────────────────────────────────────────────────────────────
class GroupHeader extends StatelessWidget {
  const GroupHeader({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.colorGroupHeaderBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(label, style: AppStyles.inter11SemiBold),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EWalletMethodRow — payment row with radio button
// ─────────────────────────────────────────────────────────────────────────────
class EWalletMethodRow extends StatelessWidget {
  const EWalletMethodRow({
    super.key,
    required this.iconPath,
    required this.name,
    this.subLabel,
    required this.selected,
    required this.onTap,
    this.isLast = false,
  });

  final String iconPath;
  final String name;
  final String? subLabel;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.colorMethodRowBg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),

                // Name + sub
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppStyles.inter16Bold),
                      if (subLabel != null && subLabel!.isNotEmpty)
                        Text(subLabel!, style: AppStyles.inter12Regular),
                    ],
                  ),
                ),

                // Radio
                _RadioDot(selected: selected),
              ],
            ),
            if (!isLast)
              const Divider(
                height: 1,
                indent: 62,
                color: AppColors.colorMethodDivider,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BankMethodRow — bank row with chevron arrow
// ─────────────────────────────────────────────────────────────────────────────
class BankMethodRow extends StatelessWidget {
  const BankMethodRow({
    super.key,
    required this.iconPath,
    required this.name,
    required this.onTap,
    this.isLast = false,
  });

  final String iconPath;
  final String name;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.colorMethodRowBg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                // Icon in grey box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.colorMethodIconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.color1A56DB,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name
                Expanded(
                  child: Text(name, style: AppStyles.inter16Bold),
                ),

                // Chevron
                SvgPicture.asset(
                  AppImages.icChevronRight,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorChevronColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            if (!isLast)
              const Divider(
                height: 1,
                indent: 62,
                color: AppColors.colorMethodDivider,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RadioDot — custom radio indicator
// ─────────────────────────────────────────────────────────────────────────────
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.colorRadioActive
              : AppColors.colorRadioInactive,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorRadioActive,
                ),
              ),
            )
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// InfoNoteCard
// ─────────────────────────────────────────────────────────────────────────────
class InfoNoteCard extends StatelessWidget {
  const InfoNoteCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.colorInfoBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppImages.icInfoCircle,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.colorInfoIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.inter13Regular.copyWith(
                color: AppColors.colorInfoText,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ConfirmTopUpButton — orange CTA
// ─────────────────────────────────────────────────────────────────────────────
class ConfirmTopUpButton extends StatelessWidget {
  const ConfirmTopUpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rating,
          foregroundColor: AppColors.color_694600,
          disabledBackgroundColor: AppColors.colorCtaBg.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.colorCtaText,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppStyles.inter18Bold.copyWith(
                      color: AppColors.color_694600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppImages.icArrowRight,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.color_694600,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
