import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../3/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _selectedCategory = 0;
  int _currentNavIndex = 0;
  
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;
  
  double _scrollOffset = 0;
  
  // Initialize responsive dimensions with default values
  double _screenWidth = 375.0;
  double _screenHeight = 812.0;
  double _headerHeight = 320.0;
  EdgeInsets _screenPadding = EdgeInsets.zero;
  bool _isSmallScreen = false;
  bool _isLargeScreen = false;
  bool _dimensionsInitialized = false;
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  
  void _initializeControllers() {
    _scrollController = ScrollController();
    
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scrollController.addListener(_onScroll);
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
  
  void _updateResponsiveDimensions() {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _screenPadding = mediaQuery.padding;
    
    _isSmallScreen = _screenWidth < 360;
    _isLargeScreen = _screenWidth > 414;
    
    _headerHeight = (_screenHeight * 0.32).clamp(280.0, 360.0);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _onCategoryTap(int index) {
    if (_selectedCategory == index) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCategory = index;
    });
  }

  void _onNavTap(int index) {
    if (_currentNavIndex == index) return;
    
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF000233),
      body: Stack(
        children: [
          _buildMainContent(),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverHeader(),
        _buildSliverContent(),
      ],
    );
  }

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

  Widget _buildSliverContent() {
    return SliverToBoxAdapter(
      child: Container(
        constraints: BoxConstraints(
          minHeight: _screenHeight - _headerHeight + 100,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            _buildCategoryButtonsSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final horizontalPadding = _getResponsivePadding();
    
    return Container(
      width: double.infinity,
      height: _headerHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF000233),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding, 
            _getResponsiveValue(16, 20, 24),
            horizontalPadding, 
            _getResponsiveValue(24, 28, 32)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingRow(),
              SizedBox(height: _getResponsiveValue(32, 40, 48)),
              Expanded(
                child: _buildStatsRow(),
              ),
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
                    fontSize: _getResponsiveValue(22, 26, 30),
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  children: const [
                    TextSpan(text: 'Welcome, '),
                    TextSpan(
                      text: 'Juan',
                      style: TextStyle(
                        color: Color(0xFFFFB74D),
                      ),
                    ),
                    TextSpan(text: '!'),
                  ],
                ),
              ),
              SizedBox(height: _getResponsiveValue(4, 6, 8)),
              Text(
                'What\'s the agenda for today?',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: _getResponsiveValue(14, 16, 18),
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
    final buttonSize = _getResponsiveValue(44, 48, 52);
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // TODO: Implement search functionality
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.search,
          color: Colors.white.withValues(alpha: 0.9),
          size: _getResponsiveValue(20, 22, 24),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final cardSpacing = _getResponsiveValue(10, 14, 18);
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Daily Streak',
            '7 days',
            '+100%',
            Colors.green,
          ),
        ),
        SizedBox(width: cardSpacing),
        Expanded(
          child: _buildStatCard(
            'Lives Reached',
            '3,671',
            '-0.03%',
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String change, Color changeColor) {
    final cardPadding = _getResponsiveValue(16, 18, 20);
    final borderRadius = _getResponsiveValue(14, 16, 18);
    
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2156),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: _getResponsiveValue(10, 11, 12),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getResponsiveValue(20, 22, 24),
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: _getResponsiveValue(4, 5, 6)),
              Text(
                change,
                style: TextStyle(
                  color: changeColor.withValues(alpha: 0.9),
                  fontSize: _getResponsiveValue(10, 11, 12),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtonsSection() {
    final horizontalPadding = _getResponsivePadding();
    final verticalPadding = _getResponsiveValue(24, 28, 32);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, 0, verticalPadding),
      child: SizedBox(
        height: _getResponsiveValue(40, 44, 48),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHomeButton(),
            SizedBox(width: _getResponsiveValue(10, 12, 16)),
            _buildCategoryButton(1, Icons.calendar_today_outlined, 'Appointment'),
            SizedBox(width: _getResponsiveValue(10, 12, 16)),
            _buildCategoryButton(2, Icons.event_outlined, 'Events'),
            SizedBox(width: _getResponsiveValue(10, 12, 16)),
            _buildCategoryButton(3, Icons.menu_book_outlined, 'Reading'),
            SizedBox(width: horizontalPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton() {
    final buttonSize = _getResponsiveValue(40, 44, 48);
    
    return GestureDetector(
      onTap: () => _onCategoryTap(0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Only highlight animation
        curve: Curves.easeInOut,
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: _selectedCategory == 0
              ? const Color(0xFFFFB74D)
              : Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: _selectedCategory == 0 ? [
            BoxShadow(
              color: const Color(0xFFFFB74D).withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ] : null,
        ),
        child: Icon(
          Icons.home,
          color: _selectedCategory == 0
              ? Colors.white
              : Colors.grey[600],
          size: _getResponsiveValue(18, 20, 22),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(int index, IconData icon, String label) {
    final isSelected = _selectedCategory == index;
    final fontSize = _getResponsiveValue(11, 12, 13);
    final iconSize = _getResponsiveValue(16, 17, 18);
    final horizontalPadding = _getResponsiveValue(14, 16, 18);
    final verticalPadding = _getResponsiveValue(8, 10, 12);
    
    return GestureDetector(
      onTap: () => _onCategoryTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Only highlight animation
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, 
          vertical: verticalPadding
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF3949ab).withValues(alpha: 0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(
            color: const Color(0xFF3949ab).withValues(alpha: 0.8),
            width: 1,
          ) : Border.all(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF3949ab).withValues(alpha: 0.15),
              blurRadius: 3,
              offset: const Offset(0, 0.5),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF3949ab) 
                  : Colors.grey[500],
              size: iconSize,
            ),
            SizedBox(width: _getResponsiveValue(6, 8, 10)),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? const Color(0xFF3949ab) 
                    : Colors.grey[500],
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
      constraints: BoxConstraints(
        minHeight: _screenHeight - 500,
      ),
      color: Colors.white,
      child: _selectedCategory == 0 
          ? _buildHomeContent()
          : _buildCategoryContent(),
    );
  }

  Widget _buildHomeContent() {
    return const SizedBox.shrink();
  }

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

  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: NavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  double _getResponsiveValue(double small, double medium, double large) {
    if (_isSmallScreen) return small;
    if (_isLargeScreen) return large;
    return medium;
  }

  double _getResponsivePadding() {
    return _getResponsiveValue(18, 20, 24);
  }

  String _getCategoryTitle() {
    switch (_selectedCategory) {
      case 1: return 'Appointments';
      case 2: return 'Events';
      case 3: return 'Reading';
      default: return 'Home';
    }
  }

  IconData _getCategoryIcon() {
    switch (_selectedCategory) {
      case 1: return Icons.calendar_today;
      case 2: return Icons.event;
      case 3: return Icons.menu_book;
      default: return Icons.home;
    }
  }
}