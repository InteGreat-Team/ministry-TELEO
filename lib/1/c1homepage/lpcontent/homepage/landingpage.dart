import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../nav_bar.dart';
import './upcoming_services.dart';
import './exploreteleo.dart';
import './services.dart';
import './events.dart';
import '../../../../utils/app_navigator.dart'; // Import the new navigation helper
import '../../../c1homepage/sidebar.dart';
import 'BE/models/landing_page_models.dart';
import 'BE/provider/landing_page_provider.dart';
import 'FE/widgets/stats_section.dart';
import 'FE/widgets/home_content_section.dart';
import 'FE/widgets/categories_section.dart';
import '../connect/prayer_wall/FE/prayerwall/home_screen.dart' as PrayerWall;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  // Navigation state
  int _currentNavIndex = 0;

  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  double _screenWidth = 375.0;
  double _screenHeight = 812.0;
  double _headerHeight = 320.0;
  bool _isSmallScreen = false;
  bool _isLargeScreen = false;
  bool _dimensionsInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeControllers();
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

  // Navigation functionality from original
  void _onNavTap(int index) async {
    // Track navigation - from original
    // await ApiService.trackUserAction('nav_selected', {'nav_index': index});

    if (mounted) {
      setState(() {
        _currentNavIndex = index;
      });

      // Handle Connect button (index 2) to navigate to Prayer Wall
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrayerWall.HomeScreen(),
          ),
        );
      } else {
        // Use the global navigation helper for other tabs
        navigateToMainPage(context, index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => LandingPageViewModel(),
      child: Consumer<LandingPageViewModel>(
        builder: (context, viewModel, child) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
            },
            child: Scaffold(
              backgroundColor: AppConfig.primaryColor,
              drawer: const Sidebar(),
              drawerEdgeDragWidth: 30.0,
              body: Stack(
                children: [
                  _buildMainContent(viewModel),
                  _buildBottomNavigation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Main content - always shows the home content structure
  Widget _buildMainContent(LandingPageViewModel viewModel) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [_buildSliverHeader(viewModel), _buildSliverContent(viewModel)],
    );
  }

  Widget _buildSliverHeader(LandingPageViewModel viewModel) {
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
                  child: _buildHeaderSection(viewModel),
                ),
              );
            },
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeaderSection(LandingPageViewModel viewModel) {
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
              _buildGreetingRow(viewModel),
              SizedBox(height: _getResponsiveValue(24, 32, 40)),
              Expanded(
                child: StatsSection(
                  statCards: viewModel.statCards,
                  getResponsiveValue: _getResponsiveValue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow(LandingPageViewModel viewModel) {
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
                      text: viewModel.userData.name,
                      style: const TextStyle(color: AppConfig.accentColor),
                    ),
                    const TextSpan(text: '!'),
                  ],
                ),
              ),
              SizedBox(height: _getResponsiveValue(3, 5, 7)),
              Text(
                viewModel.userData.greeting,
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
        // Search button from original
        _buildSearchButton(),
      ],
    );
  }

  // Search button from original
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

  // Search tap handler from original
  void _onSearchTap() async {
    HapticFeedback.lightImpact();
    // Track search tap - from original
    // await ApiService.trackUserAction('search_tapped', {});
    // TODO: Implement search functionality
  }

  Widget _buildSliverContent(LandingPageViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            CategoriesSection(
              categories: viewModel.categories,
              selectedCategory: viewModel.selectedCategory,
              onCategoryTap: viewModel.selectCategory,
              getResponsiveValue: _getResponsiveValue,
              getResponsivePadding: _getResponsivePadding,
            ),
            _buildContentSection(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(LandingPageViewModel viewModel) {
    return Container(
      width: double.infinity,
      color: AppConfig.backgroundColor,
      child: viewModel.selectedCategory == 0
          ? _buildHomeContent() // Use original home content structure
          : _buildCategoryContent(viewModel),
    );
  }

  // HOME CONTENT - Main content sections from original
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Import content components from separate files - from original
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
          SizedBox(
            height: _getResponsiveValue(100, 120, 140),
          ), // Bottom padding for nav bar
        ],
      ),
    );
  }

  Widget _buildCategoryContent(LandingPageViewModel viewModel) {
    String buttonText;
    String messageText;
    VoidCallback onButtonPressed;

    switch (viewModel.selectedCategory) {
      case 1:
        buttonText = 'Schedule an Appointment';
        messageText = 'There are no upcoming appointments';
        onButtonPressed =
            () => _showSuccessSnackBar('Schedule Appointment tapped!');
        break;
      case 2:
        buttonText = 'Explore Events';
        messageText = 'There are no upcoming events';
        onButtonPressed = () => _showSuccessSnackBar('Explore Events tapped!');
        break;
      case 3:
        buttonText = 'Start Reading';
        messageText = 'There are no upcoming readings';
        onButtonPressed = () => _showSuccessSnackBar('Start Reading tapped!');
        break;
      default:
        buttonText = 'Explore';
        messageText = 'No ${viewModel.getCategoryTitle().toLowerCase()} yet';
        onButtonPressed = () => _showSuccessSnackBar('Explore tapped!');
        break;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(_getResponsivePadding()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              viewModel.getCategoryIcon(),
              size: _getResponsiveValue(50, 60, 70),
              color: Colors.grey[300],
            ),
            SizedBox(height: _getResponsiveValue(10, 12, 16)),
            Text(
              messageText,
              style: TextStyle(
                fontSize: _getResponsiveValue(14, 16, 18),
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: _getResponsiveValue(4, 6, 8)),
            Text(
              'Content for ${viewModel.getCategoryTitle().toLowerCase()} will appear here',
              style: TextStyle(
                fontSize: _getResponsiveValue(11, 12, 14),
                color: Colors.grey[400],
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _getResponsiveValue(20, 24, 28)),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsiveValue(24, 28, 32),
                  vertical: _getResponsiveValue(12, 14, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: _getResponsiveValue(14, 16, 18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: _getResponsiveValue(100, 120, 140)),
          ],
        ),
      ),
    );
  }

  // Bottom navigation from original
  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: NavBar(currentIndex: _currentNavIndex, onTap: _onNavTap),
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
}
