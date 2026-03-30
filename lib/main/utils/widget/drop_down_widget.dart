import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdownButton2<T> extends StatelessWidget {
  const CustomDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    required this.itemTitle,
    required this.itemIcon,
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
    this.valueColor,
    this.iconColor,
    required this.isFtth,
    required this.valueTextStyle,
    super.key,
  });

  final String hint;
  final List<T> dropdownItems;
  final T? value;
  final ValueChanged<T?>? onChanged;

  final String Function(T) itemTitle;
  final String Function(T) itemIcon;

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
  final Color? valueColor;
  final Color? iconColor;
  final bool isFtth;
  final TextStyle valueTextStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Container(
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
        items: dropdownItems.map((T item) {
          final bool selected = value == item;

          if (isFtth) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  SvgPicture.asset(
                    itemIcon(item),
                    width: iconSize ?? 24,
                    height: iconSize ?? 24,
                    colorFilter: ColorFilter.mode(
                      selected
                          ? AppColors.color_E11B
                          : AppColors.color_1618,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      itemTitle(item),
                      overflow: TextOverflow.ellipsis,
                      style: valueTextStyle.copyWith(
                        fontSize: 14,
                        color: selected
                            ? AppColors.color_E11B
                            : AppColors.color_1618,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    selected
                        ? AppImages.icRadioSelected
                        : AppImages.icRadioUnselected,
                    width: iconSize ?? 24,
                    height: iconSize ?? 24,
                  ),
                ],
              ),
            );
          }

          return DropdownMenuItem(
            value: item,
            child: Row(
              children: [
                SvgPicture.asset(itemIcon(item), width: 20, height: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    itemTitle(item),
                    overflow: TextOverflow.ellipsis,
                    style: valueTextStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.color_1618,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        onChanged: onChanged,
        selectedItemBuilder: isFtth
            ? (context) {
          return dropdownItems.map((item) {
            return Container(
              alignment: valueAlignment,
              child: Row(
                children: [
                  SvgPicture.asset(
                    itemIcon(item),
                    width: iconSize ?? 24,
                    height: iconSize ?? 24,
                    colorFilter: ColorFilter.mode(
                      iconColor ?? AppColors.color_E11B,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      itemTitle(item),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: valueTextStyle.copyWith(
                        fontSize: 14,
                        color: valueColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        }
            : selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight ?? 40,
          width: buttonWidth ?? 140,
          padding: buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
          decoration: buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black45),
              ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon != null
              ? SvgPicture.asset(
            icon!,
            width: iconSize ?? 20,
            height: iconSize ?? 20,
            colorFilter: ColorFilter.mode(
              iconColor ?? AppColors.color_8588,
              BlendMode.srcIn,
            ),
          )
              : const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: iconSize ?? 20,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: dropdownHeight ?? 200,
          width: dropdownWidth ?? 140,
          padding: dropdownPadding,
          decoration: dropdownDecoration ??
              BoxDecoration(
                color: AppColors.color_FFFF,
                borderRadius: BorderRadius.circular(14),
              ),
          elevation: dropdownElevation ?? 8,
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
