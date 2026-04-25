import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/ui/driver/scheduled_rides/bloc/scheduled_ride_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Horizontal scrollable filter bar for the "Tất cả chuyến đi" tab.
class FilterBar extends StatefulWidget {
  const FilterBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.onReset,
    required this.labelDate,
    required this.labelTime,
    required this.labelType,
    required this.labelPriceMin,
    required this.labelPriceMax,
    required this.labelApply,
    required this.labelReset,
    required this.labelUrban,
    required this.labelIntercity,
    required this.labelAirport,
    required this.priceHint,
  });

  final TripFilter filter;
  final ValueChanged<TripFilter> onFilterChanged;
  final VoidCallback onReset;
  final String labelDate;
  final String labelTime;
  final String labelType;
  final String labelPriceMin;
  final String labelPriceMax;
  final String labelApply;
  final String labelReset;
  final String labelUrban;
  final String labelIntercity;
  final String labelAirport;
  final String priceHint;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late TripFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.filter;
  }

  @override
  void didUpdateWidget(FilterBar old) {
    super.didUpdateWidget(old);
    if (old.filter != widget.filter) _draft = widget.filter;
  }

  String _formatDate(DateTime? d) =>
      d == null ? '' : DateFormat('dd/MM/yyyy').format(d);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _draft = _draft.copyWith(date: picked));
      widget.onFilterChanged(_draft);
    }
  }

  Future<void> _pickTime() async {
    final init = _draft.time != null
        ? TimeOfDay(
            hour: int.parse(_draft.time!.split(':')[0]),
            minute: int.parse(_draft.time!.split(':')[1]),
          )
        : TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: init);
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() => _draft = _draft.copyWith(time: formatted));
      widget.onFilterChanged(_draft);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorFilterBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Date chip
                _FilterChip(
                  icon: AppImages.icCalendar,
                  label: _draft.date != null
                      ? _formatDate(_draft.date)
                      : widget.labelDate,
                  isActive: _draft.date != null,
                  onTap: _pickDate,
                  onClear: _draft.date != null
                      ? () {
                          setState(
                              () => _draft = _draft.copyWith(clearDate: true));
                          widget.onFilterChanged(_draft);
                        }
                      : null,
                ),
                const SizedBox(width: 8),

                // Time chip
                _FilterChip(
                  icon: AppImages.icClock,
                  label: _draft.time ?? widget.labelTime,
                  isActive: _draft.time != null,
                  onTap: _pickTime,
                  onClear: _draft.time != null
                      ? () {
                          setState(
                              () => _draft = _draft.copyWith(clearTime: true));
                          widget.onFilterChanged(_draft);
                        }
                      : null,
                ),
                const SizedBox(width: 8),

                // Type chips
                ...TripType.values.map((type) {
                  final label = type == TripType.urban
                      ? widget.labelUrban
                      : type == TripType.intercity
                          ? widget.labelIntercity
                          : widget.labelAirport;
                  final isActive = _draft.tripType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: label,
                      isActive: isActive,
                      onTap: () {
                        setState(() => _draft = _draft.copyWith(
                            tripType: isActive ? null : type,
                            clearType: isActive));
                        widget.onFilterChanged(_draft);
                      },
                    ),
                  );
                }),

                // Price range
                _PriceChip(
                  labelMin: widget.labelPriceMin,
                  labelMax: widget.labelPriceMax,
                  hint: widget.priceHint,
                  currentMin: _draft.priceMin,
                  currentMax: _draft.priceMax,
                  onApply: (min, max) {
                    setState(() =>
                        _draft = _draft.copyWith(priceMin: min, priceMax: max));
                    widget.onFilterChanged(_draft);
                  },
                ),

                if (_draft.hasActiveFilter) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() => _draft = const TripFilter());
                      widget.onReset();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.colorRedLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.labelReset,
                        style: AppStyles.inter12SemiBold.copyWith(
                          color: AppColors.colorTextRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.colorDivider),
        ],
      ),
    );
  }
}

// ── Filter chip ────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
    this.onClear,
  });

  final String? icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.colorFilterChipBgActive
              : AppColors.colorFilterChipBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.colorFilterChipBorderActive
                : AppColors.colorFilterChipBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon!,
                width: 13,
                height: 13,
                colorFilter: ColorFilter.mode(
                  isActive
                      ? AppColors.colorFilterChipTextActive
                      : AppColors.colorFilterChipText,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppStyles.inter12SemiBold.copyWith(
                color: isActive
                    ? AppColors.colorFilterChipTextActive
                    : AppColors.colorFilterChipText,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: SvgPicture.asset(
                  AppImages.icClose,
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorFilterChipTextActive,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Price chip (opens bottom sheet) ───────────────────────────

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.labelMin,
    required this.labelMax,
    required this.hint,
    required this.currentMin,
    required this.currentMax,
    required this.onApply,
  });

  final String labelMin;
  final String labelMax;
  final String hint;
  final int? currentMin;
  final int? currentMax;
  final void Function(int? min, int? max) onApply;

  bool get _isActive => currentMin != null || currentMax != null;

  String get _label {
    if (!_isActive) return 'Giá';
    if (currentMin != null && currentMax != null) {
      return '${_fmt(currentMin!)} - ${_fmt(currentMax!)}đ';
    }
    if (currentMin != null) return '≥ ${_fmt(currentMin!)}đ';
    return '≤ ${_fmt(currentMax!)}đ';
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return _FilterChip(
      icon: AppImages.icMoney,
      label: _label,
      isActive: _isActive,
      onTap: () => _showPriceSheet(context),
      onClear: _isActive ? () => onApply(null, null) : null,
    );
  }

  void _showPriceSheet(BuildContext context) {
    final minCtrl = TextEditingController(
        text: currentMin != null ? currentMin.toString() : '');
    final maxCtrl = TextEditingController(
        text: currentMax != null ? currentMax.toString() : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Khoảng giá', style: AppStyles.inter16SemiBold),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: labelMin,
                          filled: true,
                          fillColor: AppColors.colorFilterInputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.colorFilterInputBorder),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('–'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: maxCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: labelMax,
                          filled: true,
                          fillColor: AppColors.colorFilterInputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.colorFilterInputBorder),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onApply(
                        minCtrl.text.isNotEmpty
                            ? int.tryParse(minCtrl.text)
                            : null,
                        maxCtrl.text.isNotEmpty
                            ? int.tryParse(maxCtrl.text)
                            : null,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                    ),
                    child: Text('Áp dụng',
                        style: AppStyles.inter14SemiBold
                            .copyWith(color: AppColors.colorTextWhite)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
