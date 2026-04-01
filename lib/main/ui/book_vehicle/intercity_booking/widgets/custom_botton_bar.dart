// import 'package:flutter/material.dart';

// import '../core/app_export.dart';
// import './custom_image_view.dart';

// /**
//  * CustomBottomBar - A reusable bottom navigation bar component with shadow effect and rounded top corners
//  * 
//  * Features:
//  * - Support for multiple navigation items with icons and labels
//  * - Active/inactive state management with visual feedback
//  * - Shadow effect and rounded top corners
//  * - Responsive design with proper spacing
//  * - Navigation callback support
//  * 
//  * @param bottomBarItemList List of navigation items to display
//  * @param selectedIndex Currently selected tab index
//  * @param onChanged Callback function when tab is tapped
//  */
// class CustomBottomBar extends StatelessWidget {
//   CustomBottomBar({
//     Key? key,
//     required this.bottomBarItemList,
//     required this.onChanged,
//     this.selectedIndex = 0,
//   }) : super(key: key);

//   /// List of bottom bar items with their properties
//   final List<CustomBottomBarItem> bottomBarItemList;

//   /// Current selected index of the bottom bar
//   final int selectedIndex;

//   /// Callback function triggered when a bottom bar item is tapped
//   final Function(int) onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.maxFinite,
//       padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Color(0xFFCCF9F9).withAlpha(252),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24.h),
//           topRight: Radius.circular(24.h),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x0F1A1C1E).withAlpha(31),
//             offset: Offset(0, -8.h),
//             blurRadius: 24.h,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(bottomBarItemList.length, (index) {
//           final isSelected = selectedIndex == index;
//           final item = bottomBarItemList[index];

//           return Expanded(
//             child: InkWell(
//               onTap: () => onChanged(index),
//               borderRadius: BorderRadius.circular(16.h),
//               child: _buildBottomBarItem(item, isSelected),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   /// Builds individual bottom bar item widget
//   Widget _buildBottomBarItem(CustomBottomBarItem item, bool isSelected) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       decoration: BoxDecoration(
//         color: isSelected ? Color(0xFFD9E2FF) : appTheme.transparentCustom,
//         borderRadius: BorderRadius.circular(16.h),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CustomImageView(
//             imagePath: isSelected ? (item.activeIcon ?? item.icon) : item.icon,
//             height: 18.h,
//             width: 18.h,
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             item.title ?? '',
//             style: TextStyleHelper.instance.label11MediumInter.copyWith(
//               color: isSelected ? Color(0xFF00357F) : appTheme.blue_gray_500,
//               height: 1.27,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Item data model for custom bottom bar
// class CustomBottomBarItem {
//   CustomBottomBarItem({
//     required this.icon,
//     this.activeIcon,
//     required this.title,
//     required this.routeName,
//   });

//   /// Path to the default/inactive state icon
//   final String icon;

//   /// Path to the active state icon (optional, uses icon if not provided)
//   final String? activeIcon;

//   /// Title text shown below the icon
//   final String title;

//   /// Route name for navigation
//   final String routeName;
// }
