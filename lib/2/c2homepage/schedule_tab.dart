import 'package:flutter/material.dart';
import '../widgets/day_item.dart';
import '../widgets/appointment_card.dart';
import '../../3/nav_bar.dart';
import '../c1homepage/home_page.dart' as admin_home;
import '../c1homepage/admin_types.dart';
import '../c1homepage/admin_views/admin_profile_screen.dart';
import 'services_tab.dart';
import 'events_tab.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key, this.adminData, this.onUpdateAdminData});

  final AdminData? adminData;
  final Function(AdminData)? onUpdateAdminData;

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  int _selectedTab = 0;
  int _selectedDay = 0;
  String _selectedFilter = 'All';
  int _navBarIndex = 0;

  final List<String> _tabs = ['Our Schedule', 'Services', 'Events'];
  final List<IconData> _tabIcons = [
    Icons.calendar_today,
    Icons.favorite,
    Icons.event,
  ];
  // Weekdays and dates will be generated dynamically

  final List<String> _filters = ['All', 'Services', 'Events'];

  // Helper for weekday short name
  String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    // Generate the current week starting from today (7 days)
    List<DateTime> weekDates =
        List.generate(7, (i) => now.add(Duration(days: i)));
    List<String> weekdays =
        weekDates.map((d) => _weekdayShort(d.weekday)).toList();
    List<int> dates = weekDates.map((d) => d.day).toList();
    final todayLabel =
        '${months[now.month - 1]} ${now.day}, ${_weekdayShort(now.weekday)}';
    final screenWidth = MediaQuery.of(context).size.width;

    // List of schedules with type
    final List<Map<String, dynamic>> schedules = [
      {
        'type': 'Service',
        'card': AppointmentCard(
          title: 'Baptism',
          assignedTo: '@Pastor John',
          location: 'P. Sherman, 42 Wallaby Way',
          time: 'February 14, 2025 – 3:00 PM – 6:00 PM',
          borderColor: const Color(0xFFFF6B35),
          backgroundColor: const Color(0xFFFFF8F5),
        ),
      },
      {
        'type': 'Event',
        'card': AppointmentCard(
          title: 'Love! Live! Couples for Christ Community Night',
          assignedTo: '@Jake Sim',
          location: 'Paxton Hall, Yoshida Center',
          time: 'February 14, 2025 – 6:00 PM – 8:00 PM',
          borderColor: const Color(0xFF4CAF50),
          backgroundColor: const Color(0xFFF5FFF8),
        ),
      },
      {
        'type': 'Service',
        'card': AppointmentCard(
          title: 'Baptism',
          assignedTo: '@Pastor John',
          location: 'P. Sherman, 42 Wallaby Way',
          time: 'February 14, 2025 – 3:00 PM – 6:00 PM',
          borderColor: const Color(0xFFFF6B35),
          backgroundColor: const Color(0xFFFFF8F5),
        ),
      },
    ];

    // Filter schedules based on _selectedFilter
    List<Widget> filteredCards;
    if (_selectedFilter == 'All') {
      filteredCards = schedules.map((s) => s['card'] as Widget).toList();
    } else if (_selectedFilter == 'Events') {
      filteredCards = schedules
          .where((s) => s['type'] == 'Event')
          .map((s) => s['card'] as Widget)
          .toList();
    } else {
      filteredCards = schedules
          .where((s) => s['type'] == 'Service')
          .map((s) => s['card'] as Widget)
          .toList();
    }

    Widget content;
    if (_selectedTab == 0) {
      content = Column(
        children: [
          // Date and heading
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todayLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "What's for today?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          // Optimized horizontal date selector
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: weekdays.length,
              separatorBuilder: (context, i) => const SizedBox(width: 16),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => _selectedDay = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 64,
                  height: 88,
                  decoration: BoxDecoration(
                    color: _selectedDay == i
                        ? const Color(0xFF1E3A8A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _selectedDay == i
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    boxShadow: _selectedDay == i
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekdays[i],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedDay == i
                              ? Colors.white
                              : const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dates[i].toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _selectedDay == i
                              ? Colors.white
                              : const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: List.generate(_filters.length, (i) {
                final isSelected = _selectedFilter == _filters[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = _filters[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF1E3A8A) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.grey[200]!,
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.08),
                                  blurRadius: 8,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E3A8A),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Event/Service Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: filteredCards,
            ),
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      content = const ServicesTab();
    } else {
      content = const EventsTab();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // AppBar with solid dark blue
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 36,
              left: 20,
              right: 20,
              bottom: 12,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Custom Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_tabs.length, (i) {
                final isSelected = _selectedTab == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF1E3A8A) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.08),
                                  blurRadius: 8,
                                ),
                              ]
                            : [],
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.grey[200]!,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabIcons[i],
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E3A8A),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _tabs[i],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1E3A8A),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Main content area
          Expanded(child: content),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1, // Service page should highlight the Service icon
        onTap: (index) {
          if (index == 0) {
            // Navigate to admin homepage with fade transition
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const admin_home.AdminHomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          } else if (index == 1) {
            // Service (this page) - already here, do nothing
          } else if (index == 4) {
            // You (Profile) - go directly to profile if data is available
            if (widget.adminData != null && widget.onUpdateAdminData != null) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AdminProfileScreen(
                    adminData: widget.adminData!,
                    onUpdateAdminData: widget.onUpdateAdminData!,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            }
          }
          // Do nothing for other indices (Connect, Read)
        },
      ),
    );
  }
}
