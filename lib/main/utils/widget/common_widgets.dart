import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget commonButton({
  required String text,
  required VoidCallback? onPressed,
  Color color = Colors.red,
  Color textColor = Colors.white,
  bool isLoading = false,
  double borderRadius = 30.0,
  double fontSize = 18.0,
  double height = 50.0,
  double? width, // Nếu null → full width
  Widget? child, // Để linh hoạt truyền child tùy chỉnh
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: textColor, strokeWidth: 2.5)
          : child ??
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
    ),
  );
}

Widget viewAllHeader({
  required String title,
  required VoidCallback onViewAll,
  required BuildContext context,
  String? textAll,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            textAll ?? AppLocalizations.of(context)!.viewAll,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget supportIcon(String icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.pink[50],
          ),
          child: SvgPicture.asset(icon, width: 24, height: 24),
        ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextFonts.poppinsRegular.copyWith(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

Widget commonContainer({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10),
      ],
    ),
    child: child,
  );
}

Widget grayContainer({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.color_F7F7,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

Widget inputTextField({
  required String hintText,
  required int maxLine,
  required Function(String) onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.color_F7F7,
      borderRadius: BorderRadius.circular(16),
    ),
    child: TextField(
      maxLines: maxLine,
      decoration: InputDecoration(
        hintText: hintText, // "Nội dung chi tiết"
        hintStyle: AppTextFonts.poppinsRegular.copyWith(
          fontSize: 16,
          color: AppColors.color_8588,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (value) => onChanged(value),
      // => context
      //     .read<FeedbackBloc>()
      //     .add(ContentChanged(value)),
    ),
  );
}

class CustomDropdownButton3 extends StatelessWidget {
  const CustomDropdownButton3({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    super.key,
  });
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final String? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        //To avoid long text overflowing.
        isExpanded: true,
        hint: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.color_F7F7,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: hintAlignment,
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextFonts.poppinsRegular.copyWith(
              fontSize: 14,
              color: AppColors.color_8588,
            ),
          ),
        ),
        value: value,
        items: dropdownItems
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  alignment: valueAlignment,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 16,
                      color: AppColors.color_1618,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          //   height: buttonHeight ?? 40,
          width: buttonWidth ?? double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),

          decoration:
              buttonDecoration ??
              BoxDecoration(
                color: AppColors.color_F7F7,
                borderRadius: BorderRadius.circular(16),
              ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon != null
              ? SvgPicture.asset(
                  icon!,
                  width: iconSize ?? 20,
                  height: iconSize ?? 20,
                )
              : const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: iconSize ?? 20,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: dropdownHeight ?? 200,
          // width: dropdownWidth ?? double.infinity - 32,
          padding: dropdownPadding,
          decoration:
              dropdownDecoration ??
              BoxDecoration(
                color: AppColors.color_FFFF,
                borderRadius: BorderRadius.circular(14),
              ),
          elevation: dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: scrollbarRadius ?? const Radius.circular(40),
            thickness: scrollbarThickness != null
                ? MaterialStateProperty.all<double>(scrollbarThickness!)
                : null,
            thumbVisibility: scrollbarAlwaysShow != null
                ? MaterialStateProperty.all<bool>(scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: itemHeight ?? 40,
          padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

Widget commonSvgIcon({required String icon, required double width, required double height}) {
  return CircleAvatar(
    radius: 30,
    backgroundColor: Colors.pink[50],
    child: SvgPicture.asset(icon, width: width, height: height),
  );
}
  Widget datePickerField({
    required BuildContext context,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        // Mở DatePicker của hệ thống
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        print(picked);
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
      child: grayContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: AppTextFonts.poppinsRegular.copyWith(fontSize: 14),
            ),
            SvgPicture.asset(AppImages.icCalendarRed),
          ],
        ),
      ),
    );
  }
