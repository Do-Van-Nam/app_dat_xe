import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/scheduled_rides/bloc/scheduled_ride_bloc.dart';

/// Trip card shown in both tabs.
/// [onAccept] is non-null for available trips.
/// [onCancel] is non-null for accepted trips.
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.typeLabel,
    this.onAccept,
    this.onCancel,
    this.isProcessing = false,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.acceptLabel,
    required this.cancelLabel,
  });

  final TripModel trip;
  final String typeLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final bool isProcessing;
  final String pickupLabel;
  final String destinationLabel;
  final String acceptLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorTripCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.colorTripCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: type badge + price ──────────────
            Row(
              children: [
                _TypeBadge(label: typeLabel, type: trip.type),
                const Spacer(),
                Text(
                  _formatPrice(trip.price),
                  style: AppStyles.inter16Bold.copyWith(
                    color: AppColors.colorTripPriceText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Route ───────────────────────────────────────
            _RouteSection(
              trip: trip,
              pickupLabel: pickupLabel,
              destinationLabel: destinationLabel,
            ),
            const SizedBox(height: 12),

            // ── Meta: date + time + distance ─────────────────
            _MetaRow(trip: trip),
            const SizedBox(height: 14),

            // ── Action button ────────────────────────────────
            if (onAccept != null)
              _AcceptButton(
                label: acceptLabel,
                onTap: onAccept!,
                isLoading: isProcessing,
              )
            else if (onCancel != null)
              _CancelButton(
                label: cancelLabel,
                onTap: onCancel!,
                isLoading: isProcessing,
              ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf}đ';
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.type});
  final String label;
  final TripType type;

  Color get _bg {
    switch (type) {
      case TripType.urban:
        return AppColors.colorTripTypeBadgeBg;
      case TripType.intercity:
        return AppColors.colorYellowLight;
      case TripType.airport:
        return AppColors.colorGreenLight;
    }
  }

  Color get _text {
    switch (type) {
      case TripType.urban:
        return AppColors.colorTripTypeBadgeText;
      case TripType.intercity:
        return AppColors.colorYellow;
      case TripType.airport:
        return AppColors.colorGreen;
    }
  }

  String get _iconPath {
    switch (type) {
      case TripType.urban:
        return AppImages.icCar;
      case TripType.intercity:
        return AppImages.icMapPin;
      case TripType.airport:
        return AppImages.icAirplane;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _iconPath,
            width: 13,
            height: 13,
            colorFilter: ColorFilter.mode(_text, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.inter12SemiBold.copyWith(color: _text),
          ),
        ],
      ),
    );
  }
}

class _RouteSection extends StatelessWidget {
  const _RouteSection({
    required this.trip,
    required this.pickupLabel,
    required this.destinationLabel,
  });
  final TripModel trip;
  final String pickupLabel;
  final String destinationLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _Dot(color: AppColors.colorTripDotPickup, isFill: true),
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.colorTripRouteLine,
                ),
                _Dot(color: AppColors.colorTripDotDestination, isFill: false),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pickupLabel,
                      style: AppStyles.inter11Regular.copyWith(
                          color: AppColors.colorTextSecondary,
                          letterSpacing: 0.3)),
                  Text(trip.pickupAddress,
                      style: AppStyles.inter13SemiBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Text(destinationLabel,
                      style: AppStyles.inter11Regular.copyWith(
                          color: AppColors.colorTextSecondary,
                          letterSpacing: 0.3)),
                  Text(trip.destinationAddress,
                      style: AppStyles.inter13SemiBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.isFill});
  final Color color;
  final bool isFill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFill ? color : Colors.transparent,
        border: isFill ? null : Border.all(color: color, width: 2),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.trip});
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final date =
        '${trip.departureDate.day}/${trip.departureDate.month}/${trip.departureDate.year}';
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _MetaChip(icon: AppImages.icCalendar, label: date),
        _MetaChip(icon: AppImages.icClock, label: trip.departureTime),
        if (trip.distance != null)
          _MetaChip(icon: AppImages.icLocationPin, label: trip.distance!),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon,
            width: 13,
            height: 13,
            colorFilter: const ColorFilter.mode(
                AppColors.colorTripMetaText, BlendMode.srcIn)),
        const SizedBox(width: 4),
        Text(label,
            style: AppStyles.inter12Regular
                .copyWith(color: AppColors.colorTripMetaText)),
      ],
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton(
      {required this.label, required this.onTap, required this.isLoading});
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorBtnAcceptBg,
          disabledBackgroundColor: AppColors.colorBtnAcceptBg.withOpacity(0.5),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.colorTextWhite))
            : Text(label,
                style: AppStyles.inter14SemiBold
                    .copyWith(color: AppColors.colorBtnAcceptText)),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton(
      {required this.label, required this.onTap, required this.isLoading});
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.colorBtnCancelBorder),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.colorBtnCancelText))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.icXCircle,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                          AppColors.colorBtnCancelText, BlendMode.srcIn)),
                  const SizedBox(width: 6),
                  Text(label,
                      style: AppStyles.inter14SemiBold
                          .copyWith(color: AppColors.colorBtnCancelText)),
                ],
              ),
      ),
    );
  }
}
