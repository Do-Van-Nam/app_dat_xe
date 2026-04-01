// import 'package:flutter/material.dart';

// import '../core/app_export.dart';
// import './custom_image_view.dart';

// /// Custom icon button widget with configurable styling and tap handling
// ///
// /// Supports custom background colors, border radius, padding, and icon paths
// /// Provides tap functionality with ripple effect using InkWell
// ///
// /// Arguments:
// /// - [iconPath]: Path to the icon image (required)
// /// - [onTap]: Callback function for tap events (optional)
// /// - [backgroundColor]: Background color of the button (optional, defaults to light blue)
// /// - [size]: Width and height of the button (optional, defaults to 40)
// /// - [borderRadius]: Border radius for rounded corners (optional, defaults to 20)
// /// - [padding]: Internal padding around the icon (optional, defaults to 10)
// class CustomIconButton extends StatelessWidget {
//   CustomIconButton({
//     Key? key,
//     required this.iconPath,
//     this.onTap,
//     this.backgroundColor,
//     this.size,
//     this.borderRadius,
//     this.padding,
//   }) : super(key: key);

//   /// Path to the icon image
//   final String iconPath;

//   /// Callback function triggered when button is tapped
//   final VoidCallback? onTap;

//   /// Background color of the button
//   final Color? backgroundColor;

//   /// Width and height of the button
//   final double? size;

//   /// Border radius for rounded corners
//   final double? borderRadius;

//   /// Internal padding around the icon
//   final double? padding;

//   @override
//   Widget build(BuildContext context) {
//     final buttonSize = size ?? 40.h;
//     final buttonBorderRadius = borderRadius ?? 20.h;
//     final buttonPadding = padding ?? 10.h;
//     final buttonBackgroundColor = backgroundColor ?? Color(0xFFD9E2FF);

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(buttonBorderRadius),
//       child: Container(
//         width: buttonSize,
//         height: buttonSize,
//         decoration: BoxDecoration(
//           color: buttonBackgroundColor,
//           borderRadius: BorderRadius.circular(buttonBorderRadius),
//         ),
//         padding: EdgeInsets.all(buttonPadding),
//         child: CustomImageView(imagePath: iconPath, fit: BoxFit.contain),
//       ),
//     );
//   }
// }
