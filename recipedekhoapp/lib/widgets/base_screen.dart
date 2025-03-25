import 'package:flutter/material.dart';
import 'package:recipedekhoapp/pages/auth_page.dart';
import 'package:recipedekhoapp/services/auth_service.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final String title;
  final bool showBottomNav;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  const BaseScreen({
    super.key,
    required this.child,
    required this.title,
    this.showBottomNav = true,
    this.floatingActionButton,
    this.onRefresh,
  });

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final AuthService authService = AuthService();
  String? userName;
  String? userEmail;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await authService.fetchUserProfile();
      if (userProfile != null) {
        setState(() {
          userName = userProfile['fullName'];
          userEmail = userProfile['email'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateSelectedIndex() {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    setState(() {
      if (currentRoute == "/home") {
        _selectedIndex = 0;
      } else if (currentRoute == "/my-recipes") {
        _selectedIndex = 1;
      }
    });
  }

  void _navigateToPage(int index) {
    if (index == _selectedIndex) return;

    String route = index == 0 ? "/home" : "/my-recipes";
    Navigator.pushReplacementNamed(context, route);
  }

  void _handleLogout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: const Text(
              "Confirm Logout",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to logout?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmLogout == true) {
      try {
        await authService.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF810081),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              width: double.infinity,
              color: const Color(0xFF810081),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome,",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isLoading ? "Guest" : "$userName",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isLoading
                        ? "Loading..."
                        : userEmail ?? "guest@example.com",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF272727),
                child: Column(
                  children: [
                    _buildDrawerItem(Icons.home, "Home", 0),
                    _buildDrawerItem(Icons.article, "My Recipes", 1),
                    const Divider(color: Colors.white),
                    _buildDrawerItem(
                      Icons.logout,
                      "Logout",
                      -1,
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body:
          widget.onRefresh != null
              ? RefreshIndicator(
                onRefresh: widget.onRefresh!,
                child: widget.child,
              )
              : widget.child,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar:
          widget.showBottomNav
              ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _navigateToPage,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                backgroundColor: const Color(0xFF810081),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article),
                    label: 'My Recipes',
                  ),
                ],
              )
              : null,
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    int index, {
    bool isLogout = false,
  }) {
    bool isSelected = _selectedIndex == index;
    return Container(
      color: isSelected ? Colors.white12 : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isLogout
                  ? Colors.red
                  : isSelected
                  ? const Color(0xFFFFABF3)
                  : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                isLogout
                    ? Colors.red
                    : isSelected
                    ? const Color(0xFFFFABF3)
                    : Colors.white, // Changes text color when selected
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: isLogout ? _handleLogout : () => _navigateToPage(index),
      ),
    );
  }
}
