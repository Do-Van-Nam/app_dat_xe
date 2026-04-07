import 'package:demo_app/main/utils/custom_bottom_nav.dart';
import 'package:demo_app/main/utils/widget/drawer_widget.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget child; // ← Nhận child từ GoRouter

  const MainPage({
    super.key,
    required this.child,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Danh sách các route tương ứng với bottom nav
  final List<String> _routes = [
    PATH_HOME,
    PATH_ACTIVITY,
    PATH_PROFILE,
  ];

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String location = GoRouterState.of(context).uri.toString();

    final index = _routes.indexWhere((route) => location.contains(route));
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      body: widget.child, // ← Dùng child từ GoRouter
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
