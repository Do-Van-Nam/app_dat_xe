import 'package:demo_app/core/app_export.dart';
import 'book_for_family_bloc.dart';

// ═══════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════

class BookForFamilyPage extends StatelessWidget {
  const BookForFamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookForFamilyBloc(),
      child: const _BookForFamilyView(),
    );
  }
}

class _BookForFamilyView extends StatelessWidget {
  const _BookForFamilyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<BookForFamilyBloc, BookForFamilyState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == BookForFamilyStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.status == BookForFamilyStatus.success) {
          // TODO: navigate to success screen
          context.push(PATH_FINDING_DRIVER, extra: PATH_TRACKING);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: _BookForFamilyAppBar(title: l10n.datHoAppBarTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _BannerSection(),
              _ReceiverInfoSection(),
              _ServiceSection(),
              _RouteSection(),
              _DriverNoteSection(),
            ],
          ),
        ),
        bottomNavigationBar: const _ConfirmButton(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP BAR
// ═══════════════════════════════════════════════════════════════

class _BookForFamilyAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _BookForFamilyAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorWhite,
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
              AppColors.colorTextPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Text(title, style: AppStyles.inter18SemiBold),
      centerTitle: false,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 1 – BANNER
// ═══════════════════════════════════════════════════════════════

class _BannerSection extends StatelessWidget {
  const _BannerSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          colors: [Color(0xFF1A3FA4), Color(0xFF4C72D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Illustration placeholder (replace with real asset)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/img_family_banner.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(width: 160),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.colorWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.datHoBannerService,
                    style: AppStyles.inter11Regular.copyWith(
                      color: AppColors.colorTextWhite,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.datHoBannerHeadline,
                  style: AppStyles.inter20Bold.copyWith(
                    color: AppColors.colorTextWhite,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 2 – RECEIVER INFO
// ═══════════════════════════════════════════════════════════════

class _ReceiverInfoSection extends StatelessWidget {
  const _ReceiverInfoSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.datHoReceiverTitle, style: AppStyles.inter16SemiBold),
              const Spacer(),
              _BadgeLabel(label: l10n.datHoReceiverBadge),
            ],
          ),
          const SizedBox(height: 16),
          _InputField(
            label: l10n.datHoReceiverNameLabel,
            hint: l10n.datHoReceiverNameHint,
            iconPath: AppImages.icPerson,
            onChanged: (v) => context
                .read<BookForFamilyBloc>()
                .add(BookForFamilyReceiverNameChanged(v)),
          ),
          const SizedBox(height: 12),
          _InputField(
            label: l10n.datHoReceiverPhoneLabel,
            hint: l10n.datHoReceiverPhoneHint,
            iconPath: AppImages.icPhoneBook,
            iconBgColor: AppColors.colorYellow,
            keyboardType: TextInputType.phone,
            onChanged: (v) => context
                .read<BookForFamilyBloc>()
                .add(BookForFamilyReceiverPhoneChanged(v)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 3 – SERVICE SELECTION
// ═══════════════════════════════════════════════════════════════

class _ServiceSection extends StatelessWidget {
  const _ServiceSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.datHoServiceTitle, style: AppStyles.inter16SemiBold),
          const SizedBox(height: 16),
          BlocBuilder<BookForFamilyBloc, BookForFamilyState>(
            buildWhen: (p, c) => p.selectedService != c.selectedService,
            builder: (context, state) {
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _ServiceCard(
                        iconPath: AppImages.icCar,
                        label: l10n.datHoServiceCar,
                        subLabel: l10n.datHoServiceCarSub,
                        isSelected: state.selectedService ==
                            BookForFamilyServiceType.car,
                        onTap: () => context.read<BookForFamilyBloc>().add(
                            const BookForFamilyServiceSelected(
                                BookForFamilyServiceType.car)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ServiceCard(
                        iconPath: AppImages.icFood,
                        label: l10n.datHoServiceFood,
                        subLabel: l10n.datHoServiceFoodSub,
                        isSelected: state.selectedService ==
                            BookForFamilyServiceType.food,
                        onTap: () => context.read<BookForFamilyBloc>().add(
                            const BookForFamilyServiceSelected(
                                BookForFamilyServiceType.food)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 4 – ROUTE
// ═══════════════════════════════════════════════════════════════

class _RouteSection extends StatelessWidget {
  const _RouteSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(l10n.datHoRouteTitle, style: AppStyles.inter16SemiBold),
          const SizedBox(height: 16),
          _RouteInputRow(
            dotColor: AppColors.colorDotPickup.withValues(alpha: 0.2),
            label: l10n.datHoPickupLabel,
            hint: l10n.datHoPickupHint,
            iconPath: AppImages.icDotPickup,
            onChanged: (v) => context
                .read<BookForFamilyBloc>()
                .add(BookForFamilyPickupChanged(v)),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 14),
          //   child: Container(
          //     width: 1,
          //     height: 16,
          //     color: AppColors.colorBorder,
          //   ),
          // ),
          const SizedBox(height: 12),
          _RouteInputRow(
            dotColor: AppColors.colorDotDestination,
            label: l10n.datHoDestinationLabel,
            hint: l10n.datHoDestinationHint,
            iconPath: AppImages.icPinDestination,
            onChanged: (v) => context
                .read<BookForFamilyBloc>()
                .add(BookForFamilyDestinationChanged(v)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION 5 – DRIVER NOTE
// ═══════════════════════════════════════════════════════════════

class _DriverNoteSection extends StatelessWidget {
  const _DriverNoteSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.datHoNoteTitle, style: AppStyles.inter16SemiBold),
          const SizedBox(height: 12),
          BlocBuilder<BookForFamilyBloc, BookForFamilyState>(
            buildWhen: (p, c) => p.note != c.note,
            builder: (context, state) {
              return TextField(
                controller: TextEditingController(text: state.note)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: state.note.length),
                  ),
                maxLines: 3,
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.colorTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.datHoNoteHint,
                  hintStyle: AppStyles.inter13Regular,
                  filled: true,
                  fillColor: AppColors.colorCardBg,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => context
                    .read<BookForFamilyBloc>()
                    .add(BookForFamilyNoteChanged(v)),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _QuickTagChip(label: l10n.datHoNoteTagGate),
              const SizedBox(width: 8),
              _QuickTagChip(label: l10n.datHoNoteTagCall),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BOTTOM CONFIRM BUTTON
// ═══════════════════════════════════════════════════════════════

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BlocBuilder<BookForFamilyBloc, BookForFamilyState>(
        buildWhen: (p, c) =>
            p.status != c.status || p.isFormValid != c.isFormValid,
        builder: (context, state) {
          final isLoading = state.status == BookForFamilyStatus.loading;
          return SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<BookForFamilyBloc>()
                      .add(const BookForFamilyConfirmTapped()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorButtonPrimary,
                disabledBackgroundColor:
                    AppColors.colorButtonPrimary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.colorWhite,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.datHoConfirmButton,
                          style: AppStyles.inter16SemiBold.copyWith(
                            color: AppColors.colorButtonText,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.colorButtonText,
                          size: 20,
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

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// White card container wrapping each section.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Coloured badge (e.g. "BẮT BUỘC").
class _BadgeLabel extends StatelessWidget {
  const _BadgeLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.colorBadgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStyles.inter12SemiBold.copyWith(
          color: AppColors.colorBadgeText,
        ),
      ),
    );
  }
}

/// Generic labelled text input with optional trailing icon.
class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.iconPath,
    this.iconBgColor,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String hint;
  final String iconPath;
  final Color? iconBgColor;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.inter11Regular.copyWith(
            color: AppColors.colorTextSecondary,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.colorCardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.colorBorderInput),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: keyboardType,
                  style: AppStyles.inter14Regular.copyWith(
                    color: AppColors.colorTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppStyles.inter14Regular,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _IconBox(
                  iconPath: iconPath,
                  bgColor: iconBgColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Small icon container – transparent or coloured background.
class _IconBox extends StatelessWidget {
  const _IconBox({required this.iconPath, this.bgColor, this.size = 36});

  final String iconPath;
  final Color? bgColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconPath,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          bgColor != null ? AppColors.colorWhite : AppColors.colorTextSecondary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Service selection card (car / food).
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.iconPath,
    required this.label,
    required this.subLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.colorServiceSelectedBg
              : AppColors.colorServiceUnselectedBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.colorServiceSelectedBorder
                : AppColors.colorServiceUnselectedBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? AppColors.colorPrimary
                    : AppColors.colorTextSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppStyles.inter14SemiBold.copyWith(
                color: isSelected
                    ? AppColors.colorPrimary
                    : AppColors.colorTextPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: AppStyles.inter12Regular,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single route stop row (pickup or destination).
class _RouteInputRow extends StatelessWidget {
  const _RouteInputRow({
    required this.dotColor,
    required this.label,
    required this.hint,
    required this.iconPath,
    this.onChanged,
  });

  final Color dotColor;
  final String label;
  final String hint;
  final String iconPath;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: dotColor,
          child: SvgPicture.asset(
            iconPath,
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.inter11Regular.copyWith(
                  color: AppColors.colorTextSecondary,
                  letterSpacing: 0.4,
                ),
              ),
              TextField(
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.colorTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: AppStyles.inter14Regular,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                ),
                onChanged: onChanged,
              ),
              Divider(
                color: AppColors.colorBorder,
                thickness: 1,
                height: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Quick-note tag chip.
class _QuickTagChip extends StatelessWidget {
  const _QuickTagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<BookForFamilyBloc>()
          .add(BookForFamilyQuickTagTapped(label)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.color_E2E2E5,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.colorBorder),
        ),
        child: Text(
          label,
          style: AppStyles.inter12SemiBold.copyWith(
            color: AppColors.colorTagText,
          ),
        ),
      ),
    );
  }
}

// ── Extra style helpers not declared in app_styles.dart ──────
extension _AppStylesExt on TextStyle {
  // nothing here – all styles sourced from AppStyles
}
