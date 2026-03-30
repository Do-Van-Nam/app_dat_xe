import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_bloc.dart';

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
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/150?img=68'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.hello,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const Text(
                          'MAI VĂN HUY',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.whereDoYouWantToGo,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Service Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                  children: [
                    _buildServiceItem(Icons.motorcycle, l10n.motorcycle,
                        Colors.blue.shade100),
                    _buildServiceItem(
                        Icons.directions_car, l10n.car, Colors.blue.shade100),
                    _buildServiceItem(
                        Icons.restaurant, l10n.food, Colors.orange.shade100),
                    _buildServiceItem(
                        Icons.local_shipping, l10n.delivery, Colors.green,
                        isSelected: true),
                    _buildServiceItem(Icons.location_on, l10n.goAnywhere,
                        Colors.blue.shade100),
                    _buildServiceItem(
                        Icons.flight, l10n.airport, Colors.blue.shade100),
                    _buildServiceItem(
                        Icons.drive_eta, l10n.drivingLicense, Colors.amber),
                    _buildServiceItem(
                        Icons.home_work, l10n.bookRide, Colors.cyan.shade100),
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
                child: Row(
                  children: [
                    _buildSavedAddress(l10n.home, Icons.home, 'Thêm địa chỉ'),
                    const SizedBox(width: 12),
                    _buildSavedAddress(
                        'Công ty', Icons.work, 'Bitexco Financial'),
                  ],
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
                          color: Colors.blue, fontWeight: FontWeight.w600),
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
              _buildNewsItem(
                l10n.newTag,
                'Ra mắt dịch vụ "Đi tỉnh" giá siêu tiết kiệm cho mùa lễ',
                'Khám phá các điểm du lịch mới với ưu đãi...',
                'https://picsum.photos/id/201/300/180',
              ),
              _buildNewsItem(
                l10n.promotionTag,
                'Mời bạn mới, nhận ngay voucher 50k đặt đồ ăn',
                'Cùng bạn bè thưởng thức ẩm thực với giá 0đ...',
                'https://picsum.photos/id/292/300/180',
              ),

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

              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.history), label: l10n.activity),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: l10n.profile),
        ],
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label, Color bgColor,
      {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF22C55E) : bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon,
              color: isSelected ? Colors.white : Colors.black87, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSavedAddress(String title, IconData icon, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle,
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
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(
      String tag, String title, String subtitle, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl,
                width: 90, height: 90, fit: BoxFit.cover),
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
                    color: tag == 'TIN MỚI' ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10)),
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
            child: Image.network(imageUrl,
                width: 80, height: 80, fit: BoxFit.cover),
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
