import 'package:demo_app/core/app_export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

Widget dropdownField<T>({
  required String label,
  required T? value,
  required Map<T, String> items,
  required ValueChanged<T?> onChanged,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      const SizedBox(height: 8),
      DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 12),
              const Text('Chọn'),
            ],
          ),
          items: items.entries.map((e) {
            return DropdownMenuItem<T>(
              value: e.key,
              child: Row(
                children: [
                  Icon(icon, color: Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Text(e.value),
                ],
              ),
            );
          }).toList(),
          value: value,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.color_E2E2E5,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 56,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            offset: const Offset(0, -4), // Hiển thị ngay dưới nút
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    ],
  );
}
