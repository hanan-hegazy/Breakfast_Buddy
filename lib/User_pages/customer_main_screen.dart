import 'package:breakfast_buddy/User_pages/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:breakfast_buddy/features/home/screens/home_screen.dart';
import 'package:breakfast_buddy/widgets/customer_bottom_nav.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const _PlaceholderPage(title: 'Search', icon: Icons.search),
    const _PlaceholderPage(title: 'Weekly Planner', icon: Icons.calendar_month),
    const _PlaceholderPage(title: 'Favorites', icon: Icons.favorite_border),
    const _PlaceholderPage(title: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 55, color: Colors.brown),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
