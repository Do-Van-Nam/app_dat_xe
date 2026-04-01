// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../core/app_export.dart';
// import './custom_image_view.dart';

// /**
//  * A customizable AppBar widget that provides flexible header functionality
//  * with support for leading icons, title text, action buttons, and custom styling.
//  * 
//  * This component implements PreferredSizeWidget and can be used as an AppBar
//  * replacement with enhanced customization options including background colors,
//  * custom icons, and responsive text styling.
//  * 
//  * @param height - Custom height for the AppBar
//  * @param backgroundColor - Background color of the AppBar
//  * @param leadingIcon - Path to the leading icon image
//  * @param title - Title text to display in the center
//  * @param titleStyle - Custom text style for the title
//  * @param actionIcon - Path to the action icon image
//  * @param onLeadingPressed - Callback when leading icon is pressed
//  * @param onActionPressed - Callback when action icon is pressed
//  * @param centerTitle - Whether to center the title text
//  */
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   CustomAppBar({
//     Key? key,
//     this.height,
//     this.backgroundColor,
//     this.leadingIcon,
//     this.title,
//     this.titleStyle,
//     this.actionIcon,
//     this.onLeadingPressed,
//     this.onActionPressed,
//     this.centerTitle,
//   }) : super(key: key);

//   /// Custom height for the AppBar
//   final double? height;

//   /// Background color of the AppBar
//   final Color? backgroundColor;

//   /// Path to the leading icon image
//   final String? leadingIcon;

//   /// Title text to display
//   final String? title;

//   /// Custom text style for the title
//   final TextStyle? titleStyle;

//   /// Path to the action icon image
//   final String? actionIcon;

//   /// Callback when leading icon is pressed
//   final VoidCallback? onLeadingPressed;

//   /// Callback when action icon is pressed
//   final VoidCallback? onActionPressed;

//   /// Whether to center the title text
//   final bool? centerTitle;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: backgroundColor ?? Color(0xFFF9F9FC),
//       automaticallyImplyLeading: false,
//       centerTitle: centerTitle ?? true,
//       titleSpacing: 0,
//       leading: leadingIcon != null
//           ? GestureDetector(
//               onTap: onLeadingPressed ?? () => Navigator.pop(context),
//               child: Container(
//                 padding: EdgeInsets.all(8.h),
//                 child: CustomImageView(
//                   imagePath: leadingIcon!,
//                   height: 16.h,
//                   width: 16.h,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             )
//           : null,
//       title: title != null
//           ? Text(
//               title!,
//               style: titleStyle ??
//                   TextStyleHelper.instance.title18BoldInter.copyWith(
//                     height: 1.22,
//                   ),
//             )
//           : null,
//       actions: actionIcon != null
//           ? [
//               GestureDetector(
//                 onTap: onActionPressed,
//                 child: Container(
//                   margin: EdgeInsets.only(right: 24.h),
//                   padding: EdgeInsets.all(4.h),
//                   child: CustomImageView(
//                     imagePath: actionIcon!,
//                     height: 32.h,
//                     width: 32.h,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ]
//           : null,
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(height ?? 68.h);
// }
