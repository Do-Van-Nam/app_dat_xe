import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/main/data/model/goong/location.dart';

class CommonPopup extends StatelessWidget {
  const CommonPopup({
    super.key,
    required this.title,
    required this.option1Text,
    required this.option1OnTap,
    required this.option2Text,
    required this.option2OnTap,
    this.option1Color,
    this.option2Color,
    this.option1TextColor,
    this.option2TextColor,
    this.isShowOption1 = true,
  });

  /// Tiêu đề hiển thị ở đầu popup
  final String title;

  /// Text của lựa chọn 1 (bên trái / hành động phụ)
  final String option1Text;

  /// Callback khi nhấn lựa chọn 1
  final VoidCallback option1OnTap;

  /// Text của lựa chọn 2 (bên phải / hành động chính)
  final String option2Text;

  /// Callback khi nhấn lựa chọn 2
  final VoidCallback option2OnTap;

  /// Màu nền nút lựa chọn 1 (mặc định: xám nhạt)
  final Color? option1Color;

  /// Màu nền nút lựa chọn 2 (mặc định: AppColors.colorMain)
  final Color? option2Color;

  /// Màu chữ nút lựa chọn 1
  final Color? option1TextColor;

  /// Màu chữ nút lựa chọn 2
  final Color? option2TextColor;
  final bool? isShowOption1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title ──────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextFonts.poppinsRegular.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.color_1618,
              ),
            ),
            const SizedBox(height: 28),

            // ── Buttons ────────────────────────────────────
            Row(
              spacing: 12,
              children: [
                // Nút lựa chọn 1
                if (isShowOption1 ?? true)
                  Expanded(
                    child: GestureDetector(
                      onTap: option1OnTap,
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: option1Color ?? AppColors.color_E2E2E5,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          option1Text,
                          style: AppTextFonts.poppinsRegular.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: option1TextColor ?? AppColors.color_1618,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Nút lựa chọn 2
                Expanded(
                  child: GestureDetector(
                    onTap: option2OnTap,
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: option2Color ?? AppColors.colorMain,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        option2Text,
                        style: AppTextFonts.poppinsRegular.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: option2TextColor ?? Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Hàm show popup với nền mờ (dark overlay)
///
/// Ví dụ sử dụng:
/// ```dart
/// showCommonPopup(
///   context: context,
///   title: 'Bạn có chắc muốn huỷ?',
///   option1Text: 'Không',
///   option1OnTap: () => Navigator.pop(context),
///   option2Text: 'Huỷ chuyến',
///   option2OnTap: () { /* xử lý */ },
/// );
/// ```
void showCommonPopup({
  required BuildContext context,
  required String title,
  required String option1Text,
  required VoidCallback option1OnTap,
  required String option2Text,
  required VoidCallback option2OnTap,
  Color? option1Color,
  Color? option2Color,
  Color? option1TextColor,
  Color? option2TextColor,
  bool barrierDismissible = true,
  bool isShowOption1 = true,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'CommonPopup',
    // Nền phía sau tối + mờ
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return CommonPopup(
        title: title,
        option1Text: option1Text,
        option1OnTap: option1OnTap,
        option2Text: option2Text,
        option2OnTap: option2OnTap,
        option1Color: option1Color,
        option2Color: option2Color,
        option1TextColor: option1TextColor,
        option2TextColor: option2TextColor,
        isShowOption1: isShowOption1,
      );
    },
  );
}

void showPopup({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'CommonPopup',
    // Nền phía sau tối + mờ
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(child: Material(color: Colors.transparent, child: child));
    },
  );
}

/// Render 1 item gợi ý địa điểm trong dropdown.
Widget locationSuggestionTile(GoongLocation location) {
  final mainText = location.structuredFormatting.mainText.isNotEmpty
      ? location.structuredFormatting.mainText
      : location.description;
  final subText = location.structuredFormatting.secondaryText;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.color_E8E8EA,
          child: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mainText,
                style: AppTextFonts.poppinsMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.color_1618,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subText.isNotEmpty)
                Text(
                  subText,
                  style: AppTextFonts.poppinsRegular.copyWith(
                    fontSize: 12,
                    color: AppColors.color_8588,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
