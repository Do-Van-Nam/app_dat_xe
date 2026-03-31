// import 'package:demo_app/generated/app_localizations.dart';
// import 'package:demo_app/main/data/model/user_info_model.dart';
// import 'package:demo_app/main/data/share_preference/share_preference.dart';
// import 'package:demo_app/main/utils/constant.dart';
// import 'package:demo_app/main/utils/device_utils.dart';
// import 'package:demo_app/main/utils/logger.dart';
// import 'package:demo_app/main/utils/widget/image_widget.dart';
// import 'package:demo_app/res/app_colors.dart';
// import 'package:demo_app/res/app_fonts.dart';
// import 'package:demo_app/res/app_images.dart';
// import 'package:demo_app/router.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// import '../app_config.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isLoggedIn = UserInfoModel.instance.username.isNotEmpty;
//     AppLogger().logInfo("Drawer: ${UserInfoModel.instance.username}");

//     return Drawer(
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       child: Stack(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Image.asset(AppImages.imgDrawer, fit: BoxFit.cover),
//           ),
//           Column(
//             children: [
//               SizedBox(
//                 height: 200,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
//                   child: isLoggedIn
//                       ? _buildLoggedInHeader(context)
//                       : _buildGuestHeader(context),
//                 ),
//               ),

//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     if (isLoggedIn)
//                       ListTile(
//                         leading: SvgPicture.asset(
//                           AppImages.icQRCode,
//                           width: 24,
//                           height: 24,
//                         ),
//                         title: Text(
//                           AppLocalizations.of(context)!.qr_code,
//                           style: AppTextFonts.poppinsRegular.copyWith(
//                             fontSize: 14,
//                             color: AppColors.color_1618,
//                           ),
//                         ),
//                         onTap: () {},
//                       ),
//                     ListTile(
//                       leading: SvgPicture.asset(
//                         AppImages.icLanguage,
//                         width: 24,
//                         height: 24,
//                       ),
//                       title: Text(
//                         AppLocalizations.of(context)!.language,
//                         style: AppTextFonts.poppinsRegular.copyWith(
//                           fontSize: 14,
//                           color: AppColors.color_1618,
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.of(context).pop();
//                         context.push(PATH_LANGUAGE);
//                       },
//                     ),
//                     ListTile(
//                       leading: SvgPicture.asset(
//                         AppImages.icSetting,
//                         width: 24,
//                         height: 24,
//                       ),
//                       title: Text(
//                         AppLocalizations.of(context)!.setting,
//                         style: AppTextFonts.poppinsRegular.copyWith(
//                           fontSize: 14,
//                           color: AppColors.color_1618,
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     if (isLoggedIn)
//                       ListTile(
//                         leading: SvgPicture.asset(
//                           AppImages.icLogout,
//                           width: 24,
//                           height: 24,
//                         ),
//                         title: Text(
//                           AppLocalizations.of(context)!.logout,
//                           style: AppTextFonts.poppinsRegular.copyWith(
//                             fontSize: 14,
//                             color: AppColors.color_1618,
//                           ),
//                         ),
//                         onTap: () async {
//                           Navigator.of(context).pop();
//                           await SharePreferenceUtil.removeKey(
//                             ShareKey.KEY_USER_INFO,
//                           );
//                           await SharePreferenceUtil.removeKey(
//                             ShareKey.KEY_ACCESS_TOKEN,
//                           );
//                           await SharePreferenceUtil.removeKey(
//                             ShareKey.KEY_REFRESH_TOKEN,
//                           );
//                           await SharePreferenceUtil.removeKey(
//                             ShareKey.KEY_PHONE_NUMBER,
//                           );
//                           UserInfoModel.instance.clear();
//                           if (!context.mounted) return;
//                           context.go(PATH_LOGIN);
//                         },
//                       ),
//                   ],
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       AppImages.imgLogoDrawer,
//                       height: 115,
//                       width: 140,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "${AppLocalizations.of(context)!.version}: ${DeviceUtils.getVersion()}",
//                       style: AppTextFonts.poppinsMedium.copyWith(
//                         fontSize: 14,
//                         color: AppColors.color_1618,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       AppLocalizations.of(context)!.title_update_version,
//                       style: AppTextFonts.poppinsRegular.copyWith(
//                         fontSize: 12,
//                         color: AppColors.color_1618,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.color_E11B,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           AppLocalizations.of(context)!.update,
//                           style: AppTextFonts.poppinsSemiBold.copyWith(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoggedInHeader(BuildContext context) {
//     return Row(
//       children: [
//         SafeImage(
//           url: UserInfoModel.instance.avatar,
//           placeholder: AppImages.imgAvatarDefault,
//           errorAsset: AppImages.imgAvatarDefault,
//           isCircle: true,
//           width: 48,
//           height: 48,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//               context.push(PATH_HOME);
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   UserInfoModel.instance.fullName.isNotEmpty
//                       ? UserInfoModel.instance.fullName
//                       : Constant.normalizePhoneV2(
//                           UserInfoModel.instance.phoneNumber,
//                         ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextFonts.poppinsRegular.copyWith(
//                     fontSize: 12,
//                     color: AppColors.color_1618,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   Constant.normalizePhoneV2(UserInfoModel.instance.phoneNumber),
//                   style: AppTextFonts.poppinsSemiBold.copyWith(
//                     fontSize: 16,
//                     color: AppColors.color_1618,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SvgPicture.asset(
//           AppImages.icArrowRight,
//           width: 20,
//           height: 20,
//           colorFilter: const ColorFilter.mode(
//             AppColors.color_1618,
//             BlendMode.srcIn,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGuestHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset(AppImages.imgBGCamIDLogo, width: 143, height: 36),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _onLogin(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.color_E11B,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 elevation: 0,
//               ),
//               child: Text(
//                 AppLocalizations.of(context)!.login,
//                 style: AppTextFonts.poppinsSemiBold.copyWith(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _onLogin(BuildContext context) async {
//     // await SharePreferenceUtil.setBool(ShareKey.KEY_FIRST_OPEN_APP, false);
//     await SharePreferenceUtil.setBool(ShareKey.KEY_CHANGE_OPEN_APP, true);
//     context.push(PATH_LOGIN);
//   }
// }
