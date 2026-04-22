import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/model/homepage/homepage.dart';
import 'package:demo_app/main/data/model/ride/ride.dart';
import 'package:demo_app/main/data/model/user/user.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/widget/app_toast_widget.dart';
import 'package:demo_app/main/utils/widget/popup_widgets.dart';
import 'package:demo_app/main/utils/widget/textfield_widgets.dart';
import 'home_bloc.dart';
import 'package:demo_app/core/app_export.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeLoaded()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
      if (state is HomeLoadFailure) {
        AppToast.show(context, state.error);
      }
    }, builder: (context, state) {
      if (state is HomeLoadFailure) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.error}'),
              OutlinedButton(
                  onPressed: () => context.go(PATH_LOGIN), child: Text("Login"))
            ],
          ),
        );
      }

      if (state is! HomeLoadSuccess) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final user = state.user;
      final homeData = state.homeData;
      final List<ServiceItem> services = homeData?.services ?? <ServiceItem>[];
      final List<BannerItem> banners = homeData?.banners ?? <BannerItem>[];
      final List<NewsPromotion> newsPromotions =
          homeData?.newsPromotions ?? <NewsPromotion>[];
      final RestaurantSuggestions restaurantSuggestions =
          homeData?.restaurantSuggestions ?? RestaurantSuggestions();
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(PATH_PROFILE),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=68'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.hello,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            user.phone,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () => context.push(PATH_NOTIFICATION),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => context.push(PATH_SEARCH_DESTINATION),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: l10n.whereDoYouWantToGo,
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.color_E2E2E5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                // const SizedBox(height: 20),
                // if (state.currentRide != null) ...[
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     child: GestureDetector(
                //       onTap: () => context.push(PATH_TRACKING,
                //           extra: {"ride": state.currentRide}),
                //       child: Container(
                //         padding: const EdgeInsets.all(16),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(12),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.05),
                //               blurRadius: 10,
                //               offset: const Offset(0, 2),
                //             ),
                //           ],
                //         ),
                //         child: Row(
                //           children: [
                //             Container(
                //               padding: const EdgeInsets.all(8),
                //               decoration: BoxDecoration(
                //                 color: Colors.blue.shade50,
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //               child: const Icon(
                //                 Icons.access_time,
                //                 color: Colors.blue,
                //                 size: 20,
                //               ),
                //             ),
                //             const SizedBox(width: 12),
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Chuyến đi đang diễn ra",
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 4),
                //                   Text(
                //                     "Đang chờ tài xế nhận chuyến",
                //                     style: TextStyle(
                //                       color: Colors.grey.shade600,
                //                       fontSize: 14,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             const Icon(
                //               Icons.arrow_forward_ios,
                //               size: 16,
                //               color: Colors.grey,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                //   const SizedBox(height: 16),
                // ],

                const SizedBox(height: 20),

                // Service Icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 0.95,
                    children: [
                      _buildServiceItem(AppImages.icBike, l10n.motorcycle,
                          Colors.blue.shade100, context,
                          path: PATH_SEARCH_DESTINATION),
                      _buildServiceItem(AppImages.icCar, l10n.car,
                          Colors.blue.shade100, context,
                          path: PATH_SEARCH_DESTINATION),
                      _buildServiceItem(AppImages.icFood, l10n.food,
                          Colors.orange.shade100, context,
                          path: PATH_FOOD),
                      _buildServiceItem(
                          AppImages.icTruck,
                          l10n.delivery,
                          Colors.green,
                          isSelected: true,
                          context,
                          path: PATH_SHIPPING),
                      _buildServiceItem(AppImages.icLocation, l10n.goAnywhere,
                          Colors.blue.shade100, context,
                          path: PATH_INTERPROVINCE_RIDE),
                      _buildServiceItem(AppImages.icPlane, l10n.airport,
                          Colors.blue.shade100, context,
                          path: PATH_AIRPORT_BOOKING),
                      _buildServiceItem(AppImages.icCar, l10n.drivingLicense,
                          Colors.amber, context,
                          path: PATH_RENT_DRIVER),
                      _buildServiceItem(AppImages.icCar, l10n.bookRide,
                          Colors.cyan.shade100, context,
                          path: PATH_BOOK_FOR_FAMILY),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Saved Addresses
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.savedAddresses,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children: [
                        IntrinsicHeight(
                          child: _buildSavedAddress(context, l10n.home,
                              Icons.home, state.homeAddress, "home"),
                        ),
                        IntrinsicHeight(
                          child: _buildSavedAddress(context, 'Công ty',
                              Icons.work, state.workAddress, "work"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Khuyến mãi hấp dẫn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.attractivePromotions,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.viewAll,
                        style: const TextStyle(
                            color: AppColors.colorMain,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPromoCard(
                        'Giảm 50% cho Đồ ăn',
                        'Áp dụng cho đơn hàng từ 100k',
                        'https://picsum.photos/id/1080/400/200',
                      ),
                      const SizedBox(width: 12),
                      _buildPromoCard(
                        'Đồ ăn & Uống',
                        'Giảm thêm 20k',
                        'https://picsum.photos/id/292/400/200',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Tin tức & Khuyến mãi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.newsAndPromotions,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                ...newsPromotions.map((e) => Column(
                      children: [
                        _buildNewsItem(
                          e.tag ?? '',
                          e.title ?? '',
                          e.description ?? '',
                          "https://picsum.photos/id/1080/400/200",
                        ),
                        const SizedBox(height: 12),
                      ],
                    )),

                const SizedBox(height: 28),

                // Gợi ý quán ngon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.suggestedRestaurants,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                _buildRestaurantItem(
                  'Phở Hùng - Nguyễn Trãi',
                  '4.8',
                  '15 phút',
                  '2.4 km',
                  'BÁN CHẠY',
                  'https://picsum.photos/id/1060/300/180',
                ),
                _buildRestaurantItem(
                  'The Burger Joint',
                  '4.5',
                  '25 phút',
                  '3.1 km',
                  'JU À ÁI %',
                  'https://picsum.photos/id/1080/300/180',
                  isSpecial: true,
                ),
                _buildRestaurantItem(
                  'Dimsum House',
                  '4.9',
                  '20 phút',
                  '1.8 km',
                  '',
                  'https://picsum.photos/id/292/300/180',
                ),

                const SizedBox(height: 20),

                // Banner hoàn tiền
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          bottom: -30,
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(Icons.local_offer,
                                size: 140, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.newOffer,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.cashback20,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // debug
                OutlinedButton(
                    onPressed: () => context.push(PATH_DRIVER_MAIN),
                    child: Text("Driver Main")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_WAITING_APPROVAL),
                    child: Text("Waiting Approval")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_MAP_SAMPLE),
                    child: Text("Map Sample")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_MAP_BG),
                    child: Text("Map background")),
                OutlinedButton(
                    onPressed: () async {
                      final User? user = await SharePreferenceUtil.getUser();
                      if (user != null) {
                        context.push(PATH_DRIVER_UPLOAD_RECORDS, extra: {
                          "phone": user.phone ?? "",
                          "fullName": user.fullName?.value ?? "test"
                        });
                      } else {
                        context.push(PATH_DRIVER_UPLOAD_RECORDS, extra: {
                          "phone": "961597099",
                          "fullName": "test Driver"
                        });
                      }
                    },
                    child: Text("Upload Records")),
                OutlinedButton(
                    onPressed: () {
                      context.push(PATH_FINDING_DRIVER, extra: {
                        "path": PATH_TRACKING,
                        "ride": Ride(
                          id: "160402426172027395",
                          customerId: "158637144988007679",
                          driverId: null,
                          pickupAddress: "Số 1 Đào Duy Anh, Đống Đa, Hà Nội",
                          pickupLat: "21.0072000",
                          pickupLng: "105.8428000",
                          destinationAddress:
                              "Vincom Mega Mall Ocean Park, Gia Lâm, Hà Nội",
                          destinationLat: "20.9944000",
                          destinationLng: "105.9458000",
                          distance: 5000,
                          duration: 600,
                          vehicleType: 1,
                          status: 2,
                          basePrice: "12000.00",
                          distancePrice: "20000.00",
                          totalPrice: "35000.00",
                          voucherId: null,
                          isPaid: false,
                          createdAt:
                              DateTime.parse("2026-04-18T03:37:58.000000Z"),
                          updatedAt:
                              DateTime.parse("2026-04-18T03:40:13.000000Z"),
                          deletedAt: null,
                          voucherCode: null,
                          discountAmount: "0.00",
                          cancelReason: null,
                          cancellationFee: "0.00",
                          timeFare: "3000.00",
                          // trackingStatus: null,
                          // driverAssignedAt: null,
                          // driverArrivedAt: null,
                          // trackingLastPingAt: null
                        )
                      });
                    },
                    child: Text("Finding driver")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_DRIVER_WALLET),
                    child: Text("Driver Wallet")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_DRIVER_MEMBERSHIP),
                    child: Text("Driver Membership")),
                OutlinedButton(
                    onPressed: () => context.push(PATH_RATE_TRIP,
                        extra: {'rideId': "161154110074588293"}),
                    child: Text("Rate Trip")),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildServiceItem(
      String icon, String label, Color bgColor, BuildContext context,
      {bool isSelected = false, String path = ''}) {
    return GestureDetector(
      onTap: () {
        context.push(path);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF22C55E) : bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SvgPicture.asset(icon,
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black87,
                    BlendMode.srcIn),
                width: 12,
                height: 12),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSavedAddress(BuildContext context, String title, IconData icon,
      String subtitle, String type) {
    final TextEditingController destinationController = TextEditingController();
    final FocusNode destinationFocus = FocusNode();
    destinationController.text = subtitle;
    return GestureDetector(
      onTap: () {
        // showPopup(
        //     context: context,
        //     child: CommonCard(
        //         child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text("dka"),
        //         Text("dka"),
        //       ],
        //     )));
        // return;
        showDialog(
            context: context,
            builder: (_) => Dialog(
                  insetPadding: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        AutocompleteTextField<GoongLocation>(
                          controller: destinationController,
                          focusNode: destinationFocus,
                          hintText: "nhap dia chi",
                          backgroundColor: Colors.white,
                          suffixIcon:
                              const Icon(Icons.map, color: Colors.orange),
                          fetchSuggestions: (input) async {
                            final (ok, list) = await GoongRepository()
                                .getAutocompletePlaces(input: input);
                            return ok ? list : [];
                          },
                          itemBuilder: (context, location) =>
                              locationSuggestionTile(location),
                          onSelected: (location) {
                            destinationController.text = location.description;
                            if (type == "home") {
                              context.read<HomeBloc>().add(
                                  UpdateHomeAddressEvent(location: location));
                            } else if (type == "work") {
                              context.read<HomeBloc>().add(
                                  UpdateWorkAddressEvent(location: location));
                            }
                          },
                          // Giữ nguyên logic nhấn Enter → submit booking
                          onSubmitted: (_) {},
                        ),
                        commonButton(
                            text: "Xac nhan",
                            onPressed: () {
                              context.pop();
                            })
                      ],
                    ),
                  ),
                ));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.color_F3F3F6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: AppColors.colorMain),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.grey[300]),
              )
            else
              Container(color: Colors.grey[300]),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(
      String tag, String title, String subtitle, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_F3F3F6,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return SvgPicture.asset(AppImages.icBag,
                          width: 90, height: 90);
                    },
                    placeholder: (context, url) {
                      return SvgPicture.asset(AppImages.icBag,
                          width: 90, height: 90);
                    },
                  )
                : SvgPicture.asset(AppImages.icBag, width: 90, height: 90),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tag == 'TIN MỚI'
                        ? AppColors.color_D9E2FF
                        : AppColors.color_FFDDB0,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(tag,
                      style: AppTextFonts.interBold.copyWith(
                          color: tag == 'TIN MỚI'
                              ? AppColors.colorMain
                              : AppColors.color_805600,
                          fontSize: 10)),
                ),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem(String name, String rating, String time,
      String distance, String badge, String imageUrl,
      {bool isSpecial = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.restaurant, color: Colors.grey),
                  )
                : Container(width: 80, height: 80, color: Colors.grey[200]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' $rating  •  $time  •  $distance',
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
                if (badge.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSpecial ? Colors.green : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(badge,
                        style: TextStyle(
                            fontSize: 11,
                            color: isSpecial ? Colors.white : Colors.black87)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
