// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../core/app_export.dart';
// import '../../widgets/custom_app_bar.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_icon_button.dart';
// import '../../widgets/custom_image_view.dart';
// import './bloc/intercity_vehicle_booking_bloc.dart';

// // Modified: Removed non-existent import
// //

// class IntercityVehicleBookingScreenInitialPage extends StatelessWidget {
//   const IntercityVehicleBookingScreenInitialPage({Key? key}) : super(key: key);

//   static Widget builder(BuildContext context) {
//     return BlocProvider.value(
//       value: BlocProvider.of<IntercityVehicleBookingBloc>(context),
//       child: IntercityVehicleBookingScreenInitialPage(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<
//       IntercityVehicleBookingBloc,
//       IntercityVehicleBookingState
//     >(
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: appTheme.gray_50,
//           appBar: CustomAppBar(
//             title: 'Xe đi tỉnh',
//             leadingIcon: ImageConstant.imgArrowLeft,
//             actionIcon: ImageConstant.imgButton,
//             onLeadingPressed: () => Navigator.pop(context),
//             onActionPressed: () {
//               // Handle notification press
//             },
//           ),
//           body: SingleChildScrollView(
//             child: Stack(
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgMapBackground,
//                   height: 1162.h,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color(0x00F9F9FC),
//                         appTheme.color66F9F9,
//                         appTheme.gray_50,
//                       ],
//                       stops: [0.0, 0.5, 1.0],
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildTripCard(context, state),
//                       _buildVehicleSelection(context, state),
//                       _buildPricingSection(context, state),
//                       _buildBookingButton(context, state),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTripCard(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, 0),
//       decoration: BoxDecoration(
//         color: appTheme.whiteCustom,
//         borderRadius: BorderRadius.circular(32.h),
//         boxShadow: [
//           BoxShadow(
//             color: appTheme.color1E141A,
//             blurRadius: 32.h,
//             offset: Offset(0, 8.h),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
//         child: Column(
//           children: [
//             SizedBox(height: 14.h),
//             Row(
//               children: [
//                 CustomIconButton(
//                   iconPath: ImageConstant.imgBackground,
//                   backgroundColor: appTheme.blue_50,
//                   size: 40.h,
//                   borderRadius: 20.h,
//                   padding: 10.h,
//                 ),
//                 SizedBox(width: 12.h),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Chuyến Đi Tỉnh',
//                         style: TextStyleHelper.instance.title20BoldInter,
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         'Kết nối mọi nẻo đường',
//                         style: TextStyleHelper.instance.body14MediumInter,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 22.h),
//             _buildLocationTimeline(context, state),
//             SizedBox(height: 8.h),
//             _buildDateTimeSelection(context, state),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationTimeline(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(16.h),
//           decoration: BoxDecoration(
//             color: appTheme.gray_100,
//             borderRadius: BorderRadius.circular(12.h),
//           ),
//           child: Row(
//             children: [
//               CustomImageView(
//                 imagePath: ImageConstant.imgMargin,
//                 height: 24.h,
//                 width: 20.h,
//               ),
//               SizedBox(width: 14.h),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ĐIỂM ĐÓN',
//                       style: TextStyleHelper.instance.label10BoldInter.copyWith(
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       'Vincom Center, Quận 1, TP.HCM',
//                       style: TextStyleHelper.instance.title16MediumInter
//                           .copyWith(color: appTheme.gray_900),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 17.h),
//         GestureDetector(
//           onTap: () {
//             context.read<IntercityVehicleBookingBloc>().add(
//               SelectDestinationEvent(),
//             );
//           },
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16.h),
//             decoration: BoxDecoration(
//               color: appTheme.gray_100,
//               borderRadius: BorderRadius.circular(12.h),
//             ),
//             child: Row(
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgMarginLime900,
//                   height: 24.h,
//                   width: 16.h,
//                 ),
//                 SizedBox(width: 14.h),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'ĐIỂM ĐẾN (TỈNH/THÀNH)',
//                         style: TextStyleHelper.instance.label10BoldInter
//                             .copyWith(letterSpacing: 1),
//                       ),
//                       SizedBox(height: 6.h),
//                       Text(
//                         state.intercityVehicleBookingModelObj?.destination ??
//                             'Bạn muốn đi đâu?',
//                         style: TextStyleHelper.instance.title16MediumInter
//                             .copyWith(
//                               color:
//                                   (state
//                                           .intercityVehicleBookingModelObj
//                                           ?.destination
//                                           ?.isEmpty ??
//                                       true)
//                                   ? Color(0x7F737784)
//                                   : appTheme.gray_900,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDateTimeSelection(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               _selectDate(context);
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
//               decoration: BoxDecoration(
//                 color: appTheme.gray_100,
//                 borderRadius: BorderRadius.circular(12.h),
//               ),
//               child: Row(
//                 children: [
//                   CustomImageView(
//                     imagePath: ImageConstant.imgIcon,
//                     height: 20.h,
//                     width: 18.h,
//                   ),
//                   SizedBox(width: 12.h),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'NGÀY ĐI',
//                           style: TextStyleHelper.instance.label10BoldInter,
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           state.intercityVehicleBookingModelObj?.selectedDate ??
//                               'Hôm nay,\n24/10',
//                           style: TextStyleHelper.instance.body14SemiBoldInter,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 12.h),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               _selectTime(context);
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 26.h),
//               decoration: BoxDecoration(
//                 color: appTheme.gray_100,
//                 borderRadius: BorderRadius.circular(12.h),
//               ),
//               child: Row(
//                 children: [
//                   CustomImageView(
//                     imagePath: ImageConstant.imgIconBlueGray800,
//                     height: 20.h,
//                     width: 20.h,
//                   ),
//                   SizedBox(width: 12.h),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'GIờ ĐÓN',
//                           style: TextStyleHelper.instance.label10BoldInter,
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           state.intercityVehicleBookingModelObj?.selectedTime ??
//                               '09:00 AM',
//                           style: TextStyleHelper.instance.body14SemiBoldInter,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVehicleSelection(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(16.h, 24.h, 16.h, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 8.h),
//             child: Text(
//               'CHỌN LOẠI XE',
//               style: TextStyleHelper.instance.body14BoldInter.copyWith(
//                 color: appTheme.gray_600,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           SizedBox(height: 14.h),
//           _buildSharedRideOption(context, state),
//           SizedBox(height: 14.h),
//           Row(
//             children: [
//               Expanded(child: _buildPrivateCarOption(context, state)),
//               SizedBox(width: 16.h),
//               Expanded(child: _buildFamilyCarOption(context, state)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSharedRideOption(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     bool isSelected =
//         state.intercityVehicleBookingModelObj?.selectedVehicleType == 'shared';

//     return GestureDetector(
//       onTap: () {
//         context.read<IntercityVehicleBookingBloc>().add(
//           SelectVehicleTypeEvent(vehicleType: 'shared'),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 20.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0x3369FF87) : appTheme.whiteCustom,
//           borderRadius: BorderRadius.circular(32.h),
//           boxShadow: [
//             BoxShadow(
//               color: appTheme.black_900_0c,
//               blurRadius: 2.h,
//               offset: Offset(0, 1.h),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               height: 64.h,
//               width: 56.h,
//               decoration: BoxDecoration(
//                 color: appTheme.whiteCustom,
//                 borderRadius: BorderRadius.circular(16.h),
//                 boxShadow: [
//                   BoxShadow(
//                     color: appTheme.black_900_0c,
//                     blurRadius: 2.h,
//                     offset: Offset(0, 1.h),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: CustomImageView(
//                   imagePath: ImageConstant.imgXeGhP,
//                   height: 48.h,
//                   width: 48.h,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16.h),
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'Xe Ghép',
//                         style: TextStyleHelper.instance.title16BoldInter
//                             .copyWith(color: appTheme.gray_900),
//                       ),
//                       Spacer(),
//                       CustomButton(
//                         text: 'Tiết kiệm',
//                         onPressed: () {},
//                         width: 80.h,
//                         height: 30.h,
//                         backgroundColor: appTheme.green_A200,
//                         textColor: appTheme.black_900,
//                         fontSize: 9.fSize,
//                         fontWeight: FontWeight.w800,
//                         textTransform: 'uppercase',
//                         borderRadius: 14.h,
//                         padding: EdgeInsets.all(8.h),
//                       ),
//                       SizedBox(width: 10.h),
//                       Text(
//                         '~250k',
//                         style: TextStyleHelper.instance.title18ExtraBoldInter,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4.h),
//                   Row(
//                     children: [
//                       Text(
//                         'Chia sẻ chuyến đi, giảm chi phí',
//                         style: TextStyleHelper.instance.body12MediumInter,
//                       ),
//                       Spacer(),
//                       Text(
//                         'GHẾ TRỐNG',
//                         style: TextStyleHelper.instance.label10BoldInter
//                             .copyWith(color: appTheme.green_900),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPrivateCarOption(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     bool isSelected =
//         state.intercityVehicleBookingModelObj?.selectedVehicleType == 'private';

//     return GestureDetector(
//       onTap: () {
//         context.read<IntercityVehicleBookingBloc>().add(
//           SelectVehicleTypeEvent(vehicleType: 'private'),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(16.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0xFFD9E2FF) : appTheme.gray_100,
//           borderRadius: BorderRadius.circular(32.h),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomImageView(
//               imagePath: ImageConstant.imgXe4Ch,
//               height: 96.h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 6.h),
//             Text('Xe 4 Chỗ', style: TextStyleHelper.instance.body14BoldInter),
//             SizedBox(height: 6.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Riêng tư',
//                   style: TextStyleHelper.instance.label10MediumInter,
//                 ),
//                 Text('~850k', style: TextStyleHelper.instance.title16BoldInter),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFamilyCarOption(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     bool isSelected =
//         state.intercityVehicleBookingModelObj?.selectedVehicleType == 'family';

//     return GestureDetector(
//       onTap: () {
//         context.read<IntercityVehicleBookingBloc>().add(
//           SelectVehicleTypeEvent(vehicleType: 'family'),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(16.h),
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0xFFD9E2FF) : appTheme.gray_100,
//           borderRadius: BorderRadius.circular(32.h),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomImageView(
//               imagePath: ImageConstant.imgXe7Ch,
//               height: 96.h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 6.h),
//             Text('Xe 7 Chỗ', style: TextStyleHelper.instance.body14BoldInter),
//             SizedBox(height: 6.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Gia đình',
//                   style: TextStyleHelper.instance.label10MediumInter,
//                 ),
//                 Text(
//                   '~1.2tr',
//                   style: TextStyleHelper.instance.title16BoldInter,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPricingSection(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(32.h, 32.h, 26.h, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 2.h),
//             child: Text(
//               'Giá dự kiến (trọn gói)',
//               style: TextStyleHelper.instance.title16MediumInter.copyWith(
//                 color: appTheme.blue_gray_800,
//               ),
//             ),
//           ),
//           Text(
//             state.intercityVehicleBookingModelObj?.estimatedPrice ??
//                 '~850.000đ',
//             style: TextStyleHelper.instance.headline24BlackInter,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingButton(
//     BuildContext context,
//     IntercityVehicleBookingState state,
//   ) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 182.h),
//       child: CustomButton(
//         text: 'Tìm xe đi tỉnh ngay',
//         onPressed: () {
//           context.read<IntercityVehicleBookingBloc>().add(BookVehicleEvent());
//         },
//         width: double.infinity,
//         height: 62.h,
//         gradient: LinearGradient(
//           colors: [Color(0xFF00357F), Color(0xFF004AAD)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         textColor: appTheme.whiteCustom,
//         fontSize: 18.fSize,
//         fontWeight: FontWeight.w700,
//         borderRadius: 34.h,
//         padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 20.h),
//         boxShadow: [
//           BoxShadow(
//             color: appTheme.color7F3F00,
//             blurRadius: 24.h,
//             offset: Offset(0, 12.h),
//           ),
//         ],
//       ),
//     );
//   }

//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );
//     if (picked != null) {
//       context.read<IntercityVehicleBookingBloc>().add(
//         SelectDateEvent(selectedDate: picked),
//       );
//     }
//   }

//   void _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       context.read<IntercityVehicleBookingBloc>().add(
//         SelectTimeEvent(selectedTime: picked),
//       );
//     }
//   }
// }
