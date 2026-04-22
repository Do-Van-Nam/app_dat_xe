import 'dart:async';

import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:flutter/material.dart';

/// Widget TextField có danh sách gợi ý phía dưới.
///
/// Generic [T]: kiểu model tùy ý (GoongLocation, User, Product, ...)
///
/// **Tham số bắt buộc:**
/// - [fetchSuggestions]: Hàm gọi API, nhận chuỗi nhập vào, trả về `List<T>`.
/// - [itemBuilder]: Builder để render từng item gợi ý.
/// - [onSelected]: Callback khi người dùng chọn 1 gợi ý.
///
/// **Tham số tùy chọn:**
/// - [controller]: TextEditingController từ bên ngoài.
/// - [focusNode]: FocusNode từ bên ngoài (để page state vẫn có thể kiểm tra hasFocus).
/// - [hintText]: Placeholder.
/// - [labelText]: Label hiển thị phía trên TextField.
/// - [prefixIcon]: Icon đầu trường nhập.
/// - [suffixIcon]: Icon cuối (hiển thị khi không có text và không có persistentTrailingWidget).
/// - [persistentTrailingWidget]: Widget trailing luôn hiển thị, thay thế nút xoá tự động.
///   Dùng cho trường hợp icon GPS / action luôn cần thấy.
/// - [onSubmitted]: Callback khi nhấn Enter / Done trên bàn phím.
/// - [debounceMs]: Thời gian debounce trước khi gọi API (ms, mặc định 400).
/// - [minChars]: Số ký tự tối thiểu để bắt đầu gợi ý (mặc định 1).
/// - [maxSuggestions]: Số gợi ý tối đa hiển thị (mặc định 5).
/// - [onChanged]: Callback mỗi khi text thay đổi.
/// - [onClear]: Callback khi nhấn nút xóa.
/// - [enabled]: Bật/tắt field.
/// - [backgroundColor]: Màu nền field.
/// - [borderRadius]: Bo góc field.
/// - [suggestionListHeight]: Chiều cao tối đa của danh sách gợi ý.
///
/// **Ví dụ sử dụng:**
/// ```dart
/// AutocompleteTextField<GoongLocation>(
///   hintText: 'Nhập địa chỉ...',
///   fetchSuggestions: (input) async {
///     final (ok, list) = await GoongRepository().getAutocompletePlaces(input: input);
///     return ok ? list : [];
///   },
///   itemBuilder: (context, location) => ListTile(
///     leading: const Icon(Icons.location_on_outlined),
///     title: Text(location.description ?? ''),
///   ),
///   onSelected: (location) {
///     print('Đã chọn: ${location.description}');
///   },
/// )
/// ```
class AutocompleteTextField<T> extends StatefulWidget {
  const AutocompleteTextField({
    super.key,
    required this.fetchSuggestions,
    required this.itemBuilder,
    required this.onSelected,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.persistentTrailingWidget,
    this.onSubmitted,
    this.debounceMs = 400,
    this.minChars = 1,
    this.maxSuggestions = 5,
    this.onChanged,
    this.onClear,
    this.enabled = true,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.suggestionListHeight = 260.0,
  });

  /// Hàm gọi API – nhận input, trả về danh sách model [T].
  final Future<List<T>> Function(String input) fetchSuggestions;

  /// Builder render từng dòng gợi ý.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Callback khi người dùng chọn 1 gợi ý.
  final void Function(T item) onSelected;

  final TextEditingController? controller;

  /// FocusNode bên ngoài. Khi truyền vào, widget KHÔNG tự dispose nó.
  final FocusNode? focusNode;

  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;

  /// Icon cuối – chỉ hiển thị khi không có text và [persistentTrailingWidget] == null.
  final Widget? suffixIcon;

  /// Widget trailing luôn hiển thị bất kể text có hay không.
  /// Khi truyền, nút xoá tự động bị ẩn; hãy tự xử lý clear nếu cần.
  final Widget? persistentTrailingWidget;

  /// Callback khi người dùng nhấn Enter / Done.
  final void Function(String value)? onSubmitted;

  final int debounceMs;
  final int minChars;
  final int maxSuggestions;
  final void Function(String value)? onChanged;
  final VoidCallback? onClear;
  final bool enabled;
  final Color? backgroundColor;
  final double borderRadius;
  final double suggestionListHeight;

  @override
  State<AutocompleteTextField<T>> createState() =>
      _AutocompleteTextFieldState<T>();
}

class _AutocompleteTextFieldState<T> extends State<AutocompleteTextField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  List<T> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  /// true nếu focusNode được tạo nội bộ → widget tự dispose
  bool _ownsFocusNode = false;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  // ── Handlers ─────────────────────────────────────────────────────────────

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _hideSuggestions();
    }
    // Rebuild để cập nhật màu viền
    if (mounted) setState(() {});
  }

  void _onTextChanged(String value) {
    widget.onChanged?.call(value);
    // Rebuild để cập nhật trailing (nút xóa)
    if (mounted) setState(() {});

    _debounce?.cancel();

    if (value.length < widget.minChars) {
      _hideSuggestions();
      return;
    }

    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      _fetchSuggestions(value);
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final results = await widget.fetchSuggestions(input);
      if (!mounted) return;
      _suggestions = results.length > widget.maxSuggestions
          ? results.sublist(0, widget.maxSuggestions)
          : results;
      _showSuggestions = _suggestions.isNotEmpty;
      _updateOverlay();
    } catch (_) {
      _hideSuggestions();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onItemSelected(T item) {
    widget.onSelected(item);
    _hideSuggestions();
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    _hideSuggestions();
    _focusNode.requestFocus();
    if (mounted) setState(() {});
  }

  // ── Overlay management ───────────────────────────────────────────────────

  void _updateOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (!_showSuggestions || _suggestions.isEmpty) return;

    final overlay = Overlay.of(context);
    _overlayEntry = _buildOverlayEntry();
    overlay.insert(_overlayEntry!);
    if (mounted) setState(() {});
  }

  void _hideSuggestions() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: _SuggestionDropdown<T>(
            suggestions: _suggestions,
            itemBuilder: widget.itemBuilder,
            onSelected: _onItemSelected,
            maxHeight: widget.suggestionListHeight,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.color_F7F7;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Label ────────────────────────────────────────────────────────
          if (widget.labelText != null) ...[
            Text(
              widget.labelText!,
              style: AppTextFonts.poppinsMedium.copyWith(
                fontSize: 13,
                color: AppColors.color_1618,
              ),
            ),
            const SizedBox(height: 6),
          ],

          // ── TextField ────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppColors.colorMain
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Prefix icon
                if (widget.prefixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: widget.prefixIcon!,
                  ),

                // Input
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      onChanged: _onTextChanged,
                      onSubmitted: widget.onSubmitted,
                      style: AppTextFonts.poppinsRegular.copyWith(
                        fontSize: 15,
                        color: AppColors.color_1618,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 15,
                          color: AppColors.color_8588,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: widget.prefixIcon != null ? 8 : 14,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Trailing
                _buildTrailing(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing() {
    // 1. API loading spinner
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.colorMain,
          ),
        ),
      );
    }

    // 2. Persistent trailing – luôn hiển thị, không bị thay bởi nút xoá
    if (widget.persistentTrailingWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: widget.persistentTrailingWidget!,
      );
    }

    // 3. Clear button khi có text
    final hasText = _controller.text.isNotEmpty;
    if (hasText) {
      return GestureDetector(
        onTap: _onClear,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            Icons.cancel_rounded,
            color: AppColors.color_8588,
            size: 20,
          ),
        ),
      );
    }

    // 4. Suffix icon khi không có text
    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: widget.suffixIcon!,
      );
    }

    return const SizedBox(width: 10);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dropdown gợi ý (OverlayEntry child)
// ─────────────────────────────────────────────────────────────────────────────

class _SuggestionDropdown<T> extends StatelessWidget {
  const _SuggestionDropdown({
    required this.suggestions,
    required this.itemBuilder,
    required this.onSelected,
    required this.maxHeight,
    required this.borderRadius,
  });

  final List<T> suggestions;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSelected;
  final double maxHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppColors.color_E2E2E5,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return InkWell(
                onTap: () => onSelected(item),
                splashColor: AppColors.colorMain.withOpacity(0.06),
                highlightColor: AppColors.color_F7F7,
                child: itemBuilder(context, item),
              );
            },
          ),
        ),
      ),
    );
  }
}
