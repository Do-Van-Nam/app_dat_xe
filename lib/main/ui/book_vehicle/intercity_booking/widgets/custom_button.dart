// import 'package:flutter/material.dart';

// import '../core/app_export.dart';

// /**
//  * CustomButton - A flexible button component supporting various styles including gradients, shadows, and text transformations
//  *
//  * @param text - The button text content
//  * @param onPressed - Callback function when button is pressed
//  * @param width - Button width, if not provided uses intrinsic width
//  * @param height - Button height
//  * @param backgroundColor - Solid background color
//  * @param gradient - Gradient background (takes priority over backgroundColor)
//  * @param borderRadius - Border radius for rounded corners
//  * @param padding - Internal padding of the button
//  * @param margin - External margin around the button
//  * @param textColor - Color of the button text
//  * @param fontSize - Size of the button text
//  * @param fontWeight - Weight of the button text
//  * @param textTransform - Text transformation (uppercase, lowercase, etc.)
//  * @param boxShadow - List of shadows for the button
//  * @param isEnabled - Whether the button is enabled or disabled
//  */
// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     required this.width,
//     this.height,
//     this.backgroundColor,
//     this.gradient,
//     this.borderRadius,
//     this.padding,
//     this.margin,
//     this.textColor,
//     this.fontSize,
//     this.fontWeight,
//     this.textTransform,
//     this.boxShadow,
//     this.isEnabled,
//   }) : super(key: key);

//   /// The text content displayed on the button
//   final String text;

//   /// Callback function triggered when button is pressed
//   final VoidCallback? onPressed;

//   /// Width of the button - required parameter for proper layout
//   final double width;

//   /// Height of the button
//   final double? height;

//   /// Solid background color of the button
//   final Color? backgroundColor;

//   /// Gradient background (takes priority over backgroundColor)
//   final Gradient? gradient;

//   /// Border radius for rounded corners
//   final double? borderRadius;

//   /// Internal padding of the button content
//   final EdgeInsets? padding;

//   /// External margin around the button
//   final EdgeInsets? margin;

//   /// Color of the button text
//   final Color? textColor;

//   /// Font size of the button text
//   final double? fontSize;

//   /// Font weight of the button text
//   final FontWeight? fontWeight;

//   /// Text transformation type
//   final String? textTransform;

//   /// List of box shadows for the button
//   final List<BoxShadow>? boxShadow;

//   /// Whether the button is enabled or disabled
//   final bool? isEnabled;

//   @override
//   Widget build(BuildContext context) {
//     final effectiveHeight = height ?? 48.h;
//     final effectiveBorderRadius = borderRadius ?? 8.h;
//     final effectivePadding =
//         padding ?? EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h);
//     final effectiveMargin = margin ?? EdgeInsets.zero;
//     final effectiveTextColor = textColor ?? appTheme.whiteCustom;
//     final effectiveFontSize = fontSize ?? 16.fSize;
//     final effectiveFontWeight = fontWeight ?? FontWeight.w500;
//     final effectiveIsEnabled = isEnabled ?? true;

//     String displayText = text;
//     if (textTransform == 'uppercase') {
//       displayText = text.toUpperCase();
//     } else if (textTransform == 'lowercase') {
//       displayText = text.toLowerCase();
//     }

//     return Container(
//       width: width,
//       height: effectiveHeight,
//       margin: effectiveMargin,
//       decoration: BoxDecoration(
//         color: gradient == null ? backgroundColor : null,
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(effectiveBorderRadius),
//         boxShadow: boxShadow,
//       ),
//       child: ElevatedButton(
//         onPressed: effectiveIsEnabled ? onPressed : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: appTheme.transparentCustom,
//           shadowColor: appTheme.transparentCustom,
//           padding: effectivePadding,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(effectiveBorderRadius),
//           ),
//           minimumSize: Size(width, effectiveHeight),
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         child: Text(displayText, style: TextStyleHelper.instance.bodyTextInter),
//       ),
//     );
//   }
// }
