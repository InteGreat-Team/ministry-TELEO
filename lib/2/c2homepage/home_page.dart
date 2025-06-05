import 'package:flutter/material.dart';
import '../c2spp/c2s6_inbox_page.dart';
import '../c2tabs/schedule_tab.dart';
import '../c2tabs/services_tab.dart';
import '../c2tabs/events_tab.dart';
import '../c2tabs/analytics_tab.dart';
import '../../Church_Admin_SPP/c2s6_inbox_page.dart';
import '../../widgets/footer_section.dart' as CustomFooter;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final double _headerHeight = 85.0; // Slightly reduced header height
  final double _minHeaderHeight = 56.0;
  final bool _isHeaderCollapsed = false;
  bool _isKeyboardVisible = false;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  int _selectedDayIndex = 0;
  String _selectedFilter = 'All';

  final List<String> _weekdays = [
    'Fri',
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
  ];
  final List<int> _dates = [14, 15, 16, 17, 18, 19, 20];
  final List<String> _filters = ['All', 'Services', 'Events'];

  // Tab data - Added Analytics tab
  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.settings, 'label': 'Schedule'},
    {'icon': Icons.favorite_outline, 'label': 'Services'},
    {'icon': Icons.calendar_today, 'label': 'Events'},
    {'icon': Icons.bar_chart, 'label': 'Analytics'}, // New Analytics tab
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4 tabs
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _selectedTabIndex) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  double _getHeaderHeight() {
    if (_isKeyboardVisible) {
      return _minHeaderHeight;
    }
    return _headerHeight; // Total header height
  }

  void _navigateToInbox() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const InboxPage()));

    // If a tab index was returned, switch to that tab
    if (result != null && result is int && result >= 0 && result < 4) {
      // Updated for 4 tabs
      setState(() {
        _selectedTabIndex = result;
      });
      _tabController.animateTo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final double headerHeight = _getHeaderHeight();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = screenWidth / 4; // Updated for 4 tabs

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: Stack(
            clipBehavior:
                Clip.none, // Allow content to overflow for the tab effect
            children: [
              // Background color - full dark navy background
              Container(color: const Color(0xFF000233)),

              // Content Section (White) - flat top edge
              Positioned(
                top: headerHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      // No top radius - completely flat top edge
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    // Remove any border that might be causing the green line
                  ),
                  child: Column(
                    children: [
                      // Tab content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Our Schedule Tab
                            ScheduleTab(
                              weekdays: _weekdays,
                              dates: _dates,
                              selectedDayIndex: _selectedDayIndex,
                              onDaySelected: (index) {
                                setState(() {
                                  _selectedDayIndex = index;
                                });
                              },
                              selectedFilter: _selectedFilter,
                              onFilterSelected: (filter) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                            ),

                            // Services Tab
                            const ServicesTab(),

                            // Events Tab
                            const EventsTab(),

                            // Analytics Tab - NEW
                            const AnalyticsTab(),
                          ],
                        ),
                      ),

                      // Footer
                      const CustomFooter.FooterSection(),
                    ],
                  ),
                ),
              ),

              // Tab bar with selected tab protruding from content area
              Positioned(
                top:
                    headerHeight - 36, // Position to protrude from content area
                left: 0,
                right: 0,
                height: 36, // Fixed height for tab bar
                child: Row(
                  children: List.generate(
                    _tabs.length,
                    (index) => _buildTab(index),
                  ),
                ),
              ),

              // Header Section with logo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight - 36, // Reduced to make room for tab bar
                child: Container(
                  color: const Color(0xFF000233),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo without close button - larger size to match Figma
                        Image.network(
                          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Teleo_logo-FIHQea5beht7CbAURlyiQ1TcgS4XeN.png',
                          height: 28,
                          fit: BoxFit.contain,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'Teleo',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                        // Simple mail icon without box - now with tap functionality
                        GestureDetector(
                          onTap: _navigateToInbox,
                          child: const Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Prayer button - updated to purple
              if (!_isKeyboardVisible)
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8A2BE2), // Changed to purple
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final bool isSelected = _selectedTabIndex == index;
    final Map<String, dynamic> tab = _tabs[index];

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          _tabController.animateTo(index);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background for selected tab
            if (isSelected)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),

            // Tab content
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tab['icon'],
                    size: 16,
                    color: isSelected ? const Color(0xFF000233) : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tab['label'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected ? const Color(0xFF333333) : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
