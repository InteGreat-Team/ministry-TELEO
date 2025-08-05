import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../3/nav_bar.dart';
import 'lpcontent/homepage/upcoming_services.dart';
import 'lpcontent/homepage/exploreteleo.dart';
import 'lpcontent/homepage/services.dart';
import 'lpcontent/homepage/events.dart';
import 'sidebar.dart'; // Import the new Sidebar

// Data Models
class UserData {
  final String name;
  final String greeting;
  const UserData({required this.name, required this.greeting});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? 'User',
      greeting: json['greeting'] ?? 'What\'s the agenda for today?',
    );
  }
}

class StatCard {
  final String title;
  final String
  value; // Keeping for data model consistency as per previous instruction
  final String
  change; // Keeping for data model consistency as per previous instruction
  final Color changeColor;
  final bool isPositive;
  const StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
    required this.isPositive,
  });

  factory StatCard.fromJson(Map<String, dynamic> json) {
    final changeValue = json['change'] ?? '+0%';
    final isPositive = !changeValue.startsWith('-');
    return StatCard(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      change: changeValue,
      changeColor: isPositive ? Colors.green : Colors.red,
      isPositive: isPositive,
    );
  }
}

class CategoryItem {
  final int id;
  final String label;
  final IconData icon;
  final bool isHome;
  const CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    this.isHome = false,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      icon: _getIconFromString(json['icon'] ?? 'home'),
      isHome: json['isHome'] ?? false,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'calendar':
        return Icons.calendar_today_outlined;
      case 'event':
        return Icons.event_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'appointment':
        return Icons.calendar_today_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      default:
        return Icons.home;
    }
  }
}

class ActionButton {
  final String title;
  final IconData icon;
  final String action;
  const ActionButton({
    required this.title,
    required this.icon,
    required this.action,
  });

  factory ActionButton.fromJson(Map<String, dynamic> json) {
    return ActionButton(
      title: json['title'] ?? '',
      icon: _getIconFromString(json['icon'] ?? 'home'),
      action: json['action'] ?? '',
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'announcement':
        return Icons.announcement;
      case 'favorite':
        return Icons.favorite;
      case 'forum':
        return Icons.forum;
      case 'bulletin':
        return Icons.announcement;
      case 'prayer':
        return Icons.favorite;
      case 'discussion':
        return Icons.forum;
      default:
        return Icons.home;
    }
  }
}

class AppConfig {
  static const Color primaryColor = Color(0xFF000233);
  static const Color secondaryColor = Color(0xFF1F2156);
  static const Color accentColor = Color(0xFFFFB74D);
  static const Color buttonColor = Color(0xFF3949ab);
  static const Color backgroundColor = Colors.white;
  static const Duration animationDuration = Duration(milliseconds: 400);
  static const Duration quickAnimationDuration = Duration(milliseconds: 150);
  // Adjusted header height values
  static const double maxHeaderHeight = 300.0;
  static const double minHeaderHeight = 220.0;
  static const double headerHeightRatio = 0.28;
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve quickCurve = Curves.easeInOut;
}

// API Service (Mock implementation - replace with actual API calls)
class ApiService {
  static Future<UserData> fetchUserData() async {
    // Mock API call - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 500));
    return UserData.fromJson({
      'name': 'Juan',
      'greeting': 'What\'s the agenda for today?',
    });
  }

  static Future<List<StatCard>> fetchStatCards() async {
    // Mock API call - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      StatCard.fromJson({
        'title': 'Daily Streak',
        'value': '7 days',
        'change': '+100%',
      }),
      StatCard.fromJson({
        'title': 'Lives Reached',
        'value': '3,671',
        'change': '-0.03%',
      }),
    ];
  }

  static Future<List<CategoryItem>> fetchCategories() async {
    // Mock API call - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      CategoryItem.fromJson({
        'id': 0,
        'label': 'Home',
        'icon': 'home',
        'isHome': true,
      }),
      CategoryItem.fromJson({
        'id': 1,
        'label': 'Appointment',
        'icon': 'calendar',
        'isHome': false,
      }),
      CategoryItem.fromJson({
        'id': 2,
        'label': 'Events',
        'icon': 'event',
        'isHome': false,
      }),
      CategoryItem.fromJson({
        'id': 3,
        'label': 'Reading',
        'icon': 'book',
        'isHome': false,
      }),
    ];
  }

  static Future<List<ActionButton>> fetchActionButtons() async {
    // Mock API call - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      ActionButton.fromJson({
        'title': 'Bulletin\nBoard',
        'icon': 'announcement',
        'action': 'bulletin_board',
      }),
      ActionButton.fromJson({
        'title': 'Prayer\nWall',
        'icon': 'favorite',
        'action': 'prayer_wall',
      }),
      ActionButton.fromJson({
        'title': 'Discussion\nBoard',
        'icon': 'forum',
        'action': 'discussion_board',
      }),
    ];
  }

  static Future<void> trackUserAction(
    String action,
    Map<String, dynamic> data,
  ) async {
    // Mock API call for analytics - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 100));
    // Use debugPrint instead of print for production code
    debugPrint('Action tracked: $action with data: $data');
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  // ==========================================
  // STATE VARIABLES
  // ==========================================
  int _selectedCategory = 0;
  int _currentNavIndex = 0;
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;
  // Data variables
  UserData? _userData;
  List<StatCard> _statCards = [];
  List<CategoryItem> _categories = [];
  List<ActionButton> _actionButtons = [];
  // Loading states
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  // Initialize responsive dimensions with default values
  double _screenWidth = 375.0;
  double _screenHeight = 812.0;
  double _headerHeight = 320.0;
  bool _isSmallScreen = false;
  bool _isLargeScreen = false;
  bool _dimensionsInitialized = false;

  @override
  bool get wantKeepAlive => true;

  // ==========================================
  // LIFECYCLE METHODS
  // ==========================================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeControllers();
    _loadData();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _headerAnimationController = AnimationController(
      duration: AppConfig.animationDuration,
      vsync: this,
    );
    _headerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: AppConfig.defaultCurve,
      ),
    );
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      // Load all data concurrently
      final results = await Future.wait([
        ApiService.fetchUserData(),
        ApiService.fetchStatCards(),
        ApiService.fetchCategories(),
        ApiService.fetchActionButtons(),
      ]);
      if (mounted) {
        setState(() {
          _userData = results[0] as UserData;
          _statCards = results[1] as List<StatCard>;
          _categories = results[2] as List<CategoryItem>;
          _actionButtons = results[3] as List<ActionButton>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load data: ${e.toString()}';
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateResponsiveDimensions();
    if (!_dimensionsInitialized) {
      _dimensionsInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _headerAnimationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  // ==========================================
  // HELPER METHODS
  // ==========================================
  void _updateResponsiveDimensions() {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _isSmallScreen = _screenWidth < 360;
    _isLargeScreen = _screenWidth > 414;
    _headerHeight = (_screenHeight * AppConfig.headerHeightRatio).clamp(
      AppConfig.minHeaderHeight,
      AppConfig.maxHeaderHeight,
    );
  }

  void _onCategoryTap(int index) async {
    if (_selectedCategory == index) return;
    HapticFeedback.lightImpact();
    // Track category selection
    await ApiService.trackUserAction('category_selected', {
      'category_id': index,
      'category_name': _getCategoryById(index)?.label ?? 'Unknown',
    });
    if (mounted) {
      setState(() {
        _selectedCategory = index;
      });
    }
  }

  void _onNavTap(int index) async {
    if (_currentNavIndex == index) return;
    // Track navigation
    await ApiService.trackUserAction('nav_selected', {'nav_index': index});
    if (mounted) {
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  void _onActionButtonTap(ActionButton button) async {
    HapticFeedback.lightImpact();
    // Track action button tap
    await ApiService.trackUserAction('action_button_tapped', {
      'action': button.action,
      'title': button.title,
    });
    // Handle different actions
    switch (button.action) {
      case 'bulletin_board':
        _showSuccessSnackBar('On-going Development Here');
        break;
      case 'prayer_wall':
        _showSuccessSnackBar('On-going Development Here');
        break;
      case 'discussion_board':
        _showSuccessSnackBar('On-going Development Here');
        break;
      default:
        // TODO: Handle unknown action
        break;
    }
  }

  void _onSearchTap() async {
    HapticFeedback.lightImpact();
    // Track search tap
    await ApiService.trackUserAction('search_tapped', {});
    // TODO: Implement search functionality
  }

  CategoryItem? _getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // MAIN BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return _buildLoadingScreen();
    }
    if (_hasError) {
      return _buildErrorScreen();
    }
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      drawer: const Sidebar(), // Added the Sidebar here
      drawerEdgeDragWidth:
          MediaQuery.of(context).size.width *
          0.5, // Make the swipe area wider (50% of screen width)
      body: Stack(children: [_buildMainContent(), _buildBottomNavigation()]),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: const Center(
        child: CircularProgressIndicator(color: AppConfig.accentColor),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [_buildSliverHeader(), _buildSliverContent()],
    );
  }

  // ==========================================
  // HEADER SECTION METHODS
  // ==========================================
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: _headerHeight,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - _headerAnimation.value)),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: _buildHeaderSection(),
                ),
              );
            },
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeaderSection() {
    final horizontalPadding = _getResponsivePadding();
    return Container(
      width: double.infinity,
      height: _headerHeight,
      decoration: const BoxDecoration(color: AppConfig.primaryColor),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            _getResponsiveValue(12, 16, 20),
            horizontalPadding,
            _getResponsiveValue(18, 22, 26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingRow(),
              SizedBox(height: _getResponsiveValue(24, 32, 40)),
              Expanded(child: _buildStatsRow()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getResponsiveValue(20, 24, 28),
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  children: [
                    const TextSpan(text: 'Welcome, '),
                    TextSpan(
                      text: _userData?.name ?? 'User',
                      style: const TextStyle(color: AppConfig.accentColor),
                    ),
                    const TextSpan(text: '!'),
                  ],
                ),
              ),
              SizedBox(height: _getResponsiveValue(3, 5, 7)),
              Text(
                _userData?.greeting ?? 'What\'s the agenda for today?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: _getResponsiveValue(13, 15, 17),
                  height: 1.3,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        _buildSearchButton(),
      ],
    );
  }

  Widget _buildSearchButton() {
    final buttonSize = _getResponsiveValue(40, 44, 48);
    return GestureDetector(
      onTap: _onSearchTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.search,
          color: Colors.white.withOpacity(0.9),
          size: _getResponsiveValue(18, 20, 22),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final cardSpacing = _getResponsiveValue(10, 14, 18);
    return Row(
      children:
          _statCards
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final card = entry.value;
                return [
                  Expanded(child: _buildStatCard(card)),
                  if (index < _statCards.length - 1)
                    SizedBox(width: cardSpacing),
                ];
              })
              .expand((widgets) => widgets)
              .toList(),
    );
  }

  Widget _buildStatCard(StatCard card) {
    // Reduced padding to make the card smaller
    final cardPadding = _getResponsiveValue(8, 10, 12);
    final borderRadius = _getResponsiveValue(10, 12, 14);
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppConfig.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            card.title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: _getResponsiveValue(14, 16, 18),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CONTENT SECTION METHODS
  // ==========================================
  Widget _buildSliverContent() {
    return SliverToBoxAdapter(
      child: Container(
        // Further adjusted minHeight to move the white part even higher
        constraints: BoxConstraints(
          minHeight:
              _screenHeight -
              _headerHeight -
              _getResponsiveValue(50, 60, 70), // Further reduced offset
        ),
        decoration: const BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [_buildCategoryButtonsSection(), _buildContentSection()],
        ),
      ),
    );
  }

  Widget _buildCategoryButtonsSection() {
    final horizontalPadding = _getResponsivePadding();
    final verticalPadding = _getResponsiveValue(24, 28, 32);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        0,
        verticalPadding,
      ),
      child: SizedBox(
        height: _getResponsiveValue(40, 44, 48),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children:
              [
                    ..._categories.map((category) {
                      if (category.isHome) {
                        return _buildHomeButton(category);
                      } else {
                        return _buildCategoryButton(category);
                      }
                    }),
                    SizedBox(width: horizontalPadding),
                  ]
                  .expand(
                    (widgets) => [
                      widgets,
                      SizedBox(width: _getResponsiveValue(10, 12, 16)),
                    ],
                  )
                  .toList()
                ..removeLast(),
        ),
      ),
    );
  }

  Widget _buildHomeButton(CategoryItem category) {
    final buttonSize = _getResponsiveValue(40, 44, 48);
    return GestureDetector(
      onTap: () => _onCategoryTap(category.id),
      child: AnimatedContainer(
        duration: AppConfig.quickAnimationDuration,
        curve: AppConfig.quickCurve,
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color:
              _selectedCategory == category.id
                  ? AppConfig.accentColor
                  : Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow:
              _selectedCategory == category.id
                  ? [
                    BoxShadow(
                      color: AppConfig.accentColor.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          category.icon,
          color:
              _selectedCategory == category.id
                  ? Colors.white
                  : Colors.grey[600],
          size: _getResponsiveValue(18, 20, 22),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(CategoryItem category) {
    final isSelected = _selectedCategory == category.id;
    final fontSize = _getResponsiveValue(11, 12, 13);
    final iconSize = _getResponsiveValue(16, 17, 18);
    final horizontalPadding = _getResponsiveValue(14, 16, 18);
    final verticalPadding = _getResponsiveValue(8, 10, 12);
    return GestureDetector(
      onTap: () => _onCategoryTap(category.id),
      child: AnimatedContainer(
        duration: AppConfig.quickAnimationDuration,
        curve: AppConfig.quickCurve,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppConfig.accentColor.withOpacity(0.08)
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? Border.all(
                    color: AppConfig.accentColor.withOpacity(0.8),
                    width: 1,
                  )
                  : Border.all(color: Colors.grey[200]!, width: 0.5),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppConfig.accentColor.withOpacity(0.15),
                      blurRadius: 3,
                      offset: const Offset(0, 0.5),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected ? AppConfig.accentColor : Colors.grey[500],
              size: iconSize,
            ),
            SizedBox(width: _getResponsiveValue(6, 8, 10)),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? AppConfig.accentColor : Colors.grey[500],
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: _screenHeight - 500),
      color: AppConfig.backgroundColor,
      child:
          _selectedCategory == 0
              ? _buildHomeContent()
              : _buildCategoryContent(),
    );
  }

  // HOME CONTENT - Main content sections from separate files
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Import content components from separate files
          UpcomingServices(
            getResponsiveValue: _getResponsiveValue,
            getResponsivePadding: _getResponsivePadding,
          ),
          ExploreTELEO(
            getResponsiveValue: _getResponsiveValue,
            getResponsivePadding: _getResponsivePadding,
          ),
          Services(
            getResponsiveValue: _getResponsiveValue,
            getResponsivePadding: _getResponsivePadding,
          ),
          Events(
            getResponsiveValue: _getResponsiveValue,
            getResponsivePadding: _getResponsivePadding,
          ),
          _buildActionButtons(),
          SizedBox(
            height: _getResponsiveValue(100, 120, 140),
          ), // Bottom padding for nav bar
        ],
      ),
    );
  }

  // ACTION BUTTONS SECTION
  Widget _buildActionButtons() {
    final horizontalPadding = _getResponsivePadding();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        _getResponsiveValue(20, 24, 28),
        horizontalPadding,
        _getResponsiveValue(20, 24, 28),
      ),
      child: Row(
        children:
            _actionButtons
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final button = entry.value;
                  return [
                    Expanded(child: _buildActionButton(button)),
                    if (index < _actionButtons.length - 1)
                      SizedBox(width: _getResponsiveValue(12, 14, 16)),
                  ];
                })
                .expand((widgets) => widgets)
                .toList(),
      ),
    );
  }

  Widget _buildActionButton(ActionButton button) {
    return GestureDetector(
      onTap: () => _onActionButtonTap(button),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _getResponsiveValue(12, 14, 16),
          horizontal: _getResponsiveValue(6, 8, 10),
        ),
        decoration: BoxDecoration(
          color: AppConfig.buttonColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppConfig.buttonColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              button.icon,
              color: Colors.white,
              size: _getResponsiveValue(20, 24, 28),
            ),
            SizedBox(height: _getResponsiveValue(6, 8, 10)),
            Text(
              button.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getResponsiveValue(10, 11, 12),
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY CONTENT - Placeholder for other categories
  Widget _buildCategoryContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getResponsivePadding()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(),
              size: _getResponsiveValue(50, 60, 70),
              color: Colors.grey[300],
            ),
            SizedBox(height: _getResponsiveValue(10, 12, 16)),
            Text(
              'No ${_getCategoryTitle().toLowerCase()} yet',
              style: TextStyle(
                fontSize: _getResponsiveValue(14, 16, 18),
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: _getResponsiveValue(4, 6, 8)),
            Text(
              'Content for ${_getCategoryTitle().toLowerCase()} will appear here',
              style: TextStyle(
                fontSize: _getResponsiveValue(11, 12, 14),
                color: Colors.grey[400],
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // NAVIGATION METHODS
  // ==========================================
  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: NavBar(currentIndex: _currentNavIndex, onTap: _onNavTap),
    );
  }

  // ==========================================
  // UTILITY METHODS
  // ==========================================
  double _getResponsiveValue(double small, double medium, double large) {
    if (_isSmallScreen) return small;
    if (_isLargeScreen) return large;
    return medium;
  }

  double _getResponsivePadding() {
    return _getResponsiveValue(18, 20, 24);
  }

  String _getCategoryTitle() {
    final category = _getCategoryById(_selectedCategory);
    return category?.label ?? 'Home';
  }

  IconData _getCategoryIcon() {
    final category = _getCategoryById(_selectedCategory);
    return category?.icon ?? Icons.home;
  }

  // ==========================================
  // ERROR HANDLING METHODS
  // ==========================================
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(_getResponsivePadding()),
      ),
    );
  }

  // ==========================================
  // ANALYTICS AND TRACKING METHODS
  // ==========================================
  void _trackScreenView() {
    ApiService.trackUserAction('screen_view', {
      'screen_name': 'home_page',
      'selected_category': _selectedCategory,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==========================================
  // WIDGET LIFECYCLE OPTIMIZATION
  // ==========================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _loadData();
        _trackScreenView();
        break;
      case AppLifecycleState.paused:
        // Track user engagement when app is paused
        ApiService.trackUserAction('user_engagement', {
          'session_duration': 0, // TODO: Calculate actual session duration
          'interactions': _selectedCategory,
          'timestamp': DateTime.now().toIso8601String(),
        });
        break;
      case AppLifecycleState.detached:
        // Cleanup is handled in dispose()
        break;
      default:
        break;
    }
  }

  // ==========================================
  // FINAL CLEANUP
  // ==========================================
  @override
  void deactivate() {
    // Track user engagement when widget is deactivated
    ApiService.trackUserAction('user_engagement', {
      'session_duration': 0, // TODO: Calculate actual session duration
      'interactions': _selectedCategory,
      'timestamp': DateTime.now().toIso8601String(),
    });
    super.deactivate();
  }
}
