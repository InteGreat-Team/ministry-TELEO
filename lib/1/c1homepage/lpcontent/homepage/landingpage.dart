//landingpage.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../nav_bar.dart';
import '../../sidebar.dart';
import './upcoming_services.dart';
import './exploreteleo.dart';
import './services.dart';
import './events.dart';
import '../../../../utils/app_navigator.dart'; // Import the new navigation helper
import '../../../c1homepage/sidebar.dart';
import '../../../../2/c2homepage/schedule_tab.dart';
import 'BE/models/landing_page_models.dart';
import 'BE/provider/landing_page_provider.dart';
import 'FE/widgets/stats_section.dart';
import 'FE/widgets/home_content_section.dart';
import 'FE/widgets/categories_section.dart';
import '../connect/prayer_wall/FE/prayerwall/home_screen.dart' as PrayerWall;
import 'package:firebase_auth/firebase_auth.dart';

// ✅ import your user provider
import 'BE/provider/user_provider.dart';

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
    
    // Improved responsive header height calculation
    double baseHeight = _screenHeight * 0.35;
    if (_isSmallScreen) {
      baseHeight = _screenHeight * 0.32;
    } else if (_isLargeScreen) {
      baseHeight = _screenHeight * 0.38;
    }
    
    _headerHeight = baseHeight.clamp(280.0, 400.0);
  }

  // Navigation functionality - updated to show popup for Services, Read, and You
  void _onNavTap(int index) async {
    if (mounted) {
      // Store the previous index to potentially revert back
      int previousIndex = _currentNavIndex;
      
      setState(() {
        _currentNavIndex = index;
      });

      switch (index) {
        case 1: // Services button
          await _showDevelopmentPopup(
            title: 'Services Coming Soon',
            icon: Icons.miscellaneous_services,
            iconColor: Colors.orange,
            message: 'The Services section is currently under development. We\'re working hard to bring you amazing features!\n\nStay tuned for updates.',
          );
          // Reset to homepage after popup is dismissed
          if (mounted) {
            setState(() {
              _currentNavIndex = 0;
            });
          }
          break;
        case 2: // Connect (Prayer Wall) - working feature
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrayerWall.HomeScreen(),
            ),
          );
          break;
        case 3: // Read button
          await _showDevelopmentPopup(
            title: 'Reading Features Coming Soon',
            icon: Icons.menu_book,
            iconColor: Colors.blue,
            message: 'The Reading section is being crafted with care. Soon you\'ll be able to access devotionals, scriptures, and inspiring content!\n\nWe appreciate your patience.',
          );
          // Reset to homepage after popup is dismissed
          if (mounted) {
            setState(() {
              _currentNavIndex = 0;
            });
          }
          break;
        case 4: // You button (Profile/Account)
          await _showDevelopmentPopup(
            title: 'Profile Features in Progress',
            icon: Icons.person,
            iconColor: Colors.purple,
            message: 'Your personal dashboard is under construction. Soon you\'ll have access to your profile, settings, and personalized content!\n\nExciting things are coming.',
          );
          // Reset to homepage after popup is dismissed
          if (mounted) {
            setState(() {
              _currentNavIndex = 0;
            });
          }
          break;
        default:
          navigateToMainPage(context, index);
          break;
      }
    }
  }

  // Enhanced development popup with customizable content
  Future<void> _showDevelopmentPopup({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String message,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _getResponsiveValue(300, 340, 380),
              minHeight: _getResponsiveValue(200, 220, 240),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue.shade50.withOpacity(0.3),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(_getResponsiveValue(20, 24, 28)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with animated container
                  Container(
                    width: _getResponsiveValue(60, 70, 80),
                    height: _getResponsiveValue(60, 70, 80),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: iconColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: _getResponsiveValue(30, 35, 40),
                    ),
                  ),
                  SizedBox(height: _getResponsiveValue(16, 20, 24)),
                  
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: _getResponsiveValue(18, 20, 22),
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _getResponsiveValue(12, 16, 20)),
                  
                  // Message
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: _getResponsiveValue(14, 15, 16),
                      height: 1.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _getResponsiveValue(20, 24, 28)),
                  
                  // Action button with gradient
                  Container(
                    width: double.infinity,
                    height: _getResponsiveValue(44, 48, 52),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppConfig.primaryColor,
                          Colors.blue.shade600,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConfig.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Text(
                            'Got it!',
                            style: TextStyle(
                              fontSize: _getResponsiveValue(16, 17, 18),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingPageViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final user = FirebaseAuth.instance.currentUser;
            final email = user?.email ?? "";
            return UserProvider()..fetchUserData(email);
          },
        ),
      ],
      child: Consumer2<LandingPageViewModel, UserProvider>(
        builder: (context, viewModel, userProvider, child) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
            },
            child: Scaffold(
              backgroundColor: AppConfig.primaryColor,
              drawer: const Sidebar(),
              drawerEdgeDragWidth: _getResponsiveValue(25, 30, 35),
              body: SafeArea(
                child: _buildMainContent(viewModel, userProvider),
              ),
              // ✅ FIXED: Use bottomNavigationBar instead of Positioned widget
              bottomNavigationBar: NavBar(
                currentIndex: _currentNavIndex, 
                onTap: _onNavTap
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
      LandingPageViewModel viewModel, UserProvider userProvider) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        _buildSliverHeader(viewModel, userProvider),
        _buildSliverContent(viewModel),
        // ✅ Add bottom padding to account for navbar
        SliverToBoxAdapter(
          child: SizedBox(height: _getResponsiveValue(80, 90, 100)),
        ),
      ],
    );
  }

  Widget _buildSliverHeader(
      LandingPageViewModel viewModel, UserProvider userProvider) {
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
                  child: _buildHeaderSection(viewModel, userProvider),
                ),
              );
            },
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeaderSection(
      LandingPageViewModel viewModel, UserProvider userProvider) {
    final horizontalPadding = _getResponsivePadding();
    return Container(
      width: double.infinity,
      height: _headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConfig.primaryColor,
            AppConfig.primaryColor.withBlue(
              (AppConfig.primaryColor.blue + 30).clamp(0, 255),
            ),
          ],
        ),
      ),
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
            _buildGreetingRow(userProvider),
            SizedBox(height: _getResponsiveValue(20, 28, 36)),
            Expanded(
              child: StatsSection(
                statCards: viewModel.statCards,
                getResponsiveValue: _getResponsiveValue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ updated greeting row to use UserProvider instead of viewModel
  Widget _buildGreetingRow(UserProvider userProvider) {
    if (userProvider.isLoading) {
      return Center(
        child: SizedBox(
          width: _getResponsiveValue(20, 24, 28),
          height: _getResponsiveValue(20, 24, 28),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (userProvider.errorMessage != null) {
      return Container(
        padding: EdgeInsets.all(_getResponsiveValue(12, 16, 20)),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Text(
          userProvider.errorMessage!,
          style: TextStyle(
            color: Colors.red.shade300,
            fontSize: _getResponsiveValue(14, 15, 16),
          ),
        ),
      );
    }

    final user = userProvider.userData;
    if (user == null) {
      return Text(
        "Welcome, Guest!",
        style: TextStyle(
          color: Colors.white,
          fontSize: _getResponsiveValue(20, 24, 28),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: constraints.maxWidth > 300 ? 4 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getResponsiveValue(18, 22, 26),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: 'Welcome, '),
                        TextSpan(
                          text: user.name.length > 15 
                              ? '${user.name.substring(0, 15)}...' 
                              : user.name,
                          style: TextStyle(
                            color: AppConfig.accentColor,
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const TextSpan(text: '!'),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: _getResponsiveValue(4, 6, 8)),
                  Text(
                    user.greeting,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: _getResponsiveValue(12, 14, 16),
                      height: 1.4,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: _getResponsiveValue(12, 16, 20)),
            _buildSearchButton(),
          ],
        );
      },
    );
  }

  Widget _buildSearchButton() {
    final buttonSize = _getResponsiveValue(42, 46, 50);
    return GestureDetector(
      onTap: _onSearchTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.blue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.search,
          color: Colors.white.withOpacity(0.9),
          size: _getResponsiveValue(20, 22, 24),
        ),
      ),
    );
  }

  void _onSearchTap() async {
    HapticFeedback.lightImpact();
    // Add search functionality here
  }

  Widget _buildSliverContent(LandingPageViewModel viewModel) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_getResponsiveValue(20, 24, 28)),
            topRight: Radius.circular(_getResponsiveValue(20, 24, 28)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
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
      constraints: BoxConstraints(
        minHeight: _getResponsiveValue(200, 250, 300),
      ),
      child: viewModel.selectedCategory == 0
          ? _buildHomeContent()
          : _buildCategoryContent(viewModel),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          // ✅ REMOVED: Bottom spacing since navbar is now properly positioned
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
      child: Container(
        padding: EdgeInsets.all(_getResponsivePadding()),
        constraints: BoxConstraints(
          minHeight: _getResponsiveValue(300, 350, 400),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _getResponsiveValue(80, 90, 100),
              height: _getResponsiveValue(80, 90, 100),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Icon(
                viewModel.getCategoryIcon(),
                size: _getResponsiveValue(40, 50, 60),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: _getResponsiveValue(16, 20, 24)),
            Text(
              messageText,
              style: TextStyle(
                fontSize: _getResponsiveValue(16, 18, 20),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _getResponsiveValue(8, 10, 12)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveValue(20, 30, 40),
              ),
              child: Text(
                'Content for ${viewModel.getCategoryTitle().toLowerCase()} will appear here',
                style: TextStyle(
                  fontSize: _getResponsiveValue(12, 13, 14),
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: _getResponsiveValue(24, 30, 36)),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: _getResponsiveValue(250, 280, 320),
              ),
              height: _getResponsiveValue(44, 48, 52),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppConfig.accentColor,
                    Colors.blue.shade400,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onButtonPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: _getResponsiveValue(14, 16, 18),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // ✅ REMOVED: Bottom spacing is now handled by the SliverToBoxAdapter
          ],
        ),
      ),
    );
  }

  // ✅ REMOVED: _buildBottomNavigation method since we're using bottomNavigationBar

  // Enhanced responsive value calculation
  double _getResponsiveValue(double small, double medium, double large) {
    if (_screenWidth < 340) return small * 0.9;
    if (_screenWidth < 360) return small;
    if (_screenWidth < 400) return medium * 0.95;
    if (_screenWidth < 430) return medium;
    return large;
  }

  // Enhanced responsive padding calculation
  double _getResponsivePadding() {
    if (_screenWidth < 340) return 14;
    if (_screenWidth < 360) return 16;
    if (_screenWidth < 400) return 18;
    if (_screenWidth < 430) return 20;
    return 24;
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: _getResponsiveValue(18, 20, 22),
            ),
            SizedBox(width: _getResponsiveValue(8, 10, 12)),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: _getResponsiveValue(14, 15, 16),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(_getResponsivePadding()),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}