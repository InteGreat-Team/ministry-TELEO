import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../prayer_wall/BE/models/prayer_post.dart';
import '../../../../prayer_wall/FE/widgets/prayer_homescreen/prayer_card.dart';
import 'dart:math' as math;

class HomeScreenWidgets {
  static Widget buildScaffold({
    required BuildContext context,
    required int selectedNavIndex,
    required bool isLoading,
    required List<PrayerPost> prayerPosts,
    required bool allCardsSwiped,
    required int currentCardIndex,
    required List<Color> cardColors,
    // Callbacks
    required Function(int) onNavItemTapped,
    required VoidCallback onAddPrayer,
    required VoidCallback refreshPrayerWall,
    required VoidCallback onLike,
    required Function(String?) onPray,
    required VoidCallback onComment,
    required Function(dynamic) onSwipe,
    VoidCallback? onHistoryTapped,
  }) {
    return Scaffold(
      backgroundColor: _buildBackgroundGradient(),
      appBar: _buildAppBar(selectedNavIndex, onNavItemTapped, onHistoryTapped),
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: _buildPrayersTab(
          context: context,
          isLoading: isLoading,
          prayerPosts: prayerPosts,
          allCardsSwiped: allCardsSwiped,
          currentCardIndex: currentCardIndex,
          cardColors: cardColors,
          refreshPrayerWall: refreshPrayerWall,
          onLike: onLike,
          onPray: onPray,
          onComment: onComment,
          onSwipe: onSwipe,
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A0A2A).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _safeCallCallback(context, onAddPrayer, 'Failed to open prayer creation'),
          backgroundColor: const Color(0xFF0A0A2A),
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white, size: 22),
          label: const Text(
            'Create Prayer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Add safe callback wrapper for error handling
  static void _safeCallCallback(BuildContext context, VoidCallback callback, String errorMessage) {
    try {
      callback();
    } catch (e) {
      _showErrorSnackBar(context, errorMessage);
    }
  }

  // ✅ Add safe callback wrapper for navigation
  static void _safeCallNavCallback(BuildContext context, Function(int) callback, int index, String errorMessage) {
    try {
      callback(index);
    } catch (e) {
      _showErrorSnackBar(context, errorMessage);
    }
  }

  // ✅ Add safe callback wrapper for history
  static void _safeCallHistoryCallback(BuildContext context, VoidCallback? callback, String errorMessage) {
    if (callback == null) return;
    try {
      callback();
    } catch (e) {
      _showErrorSnackBar(context, errorMessage);
    }
  }

  // ✅ Add error snackbar method
  static void _showErrorSnackBar(BuildContext context, String message) {
    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Handle snackbar errors silently
      debugPrint('Error showing error snackbar: $e');
    }
  }

  static Color _buildBackgroundGradient() {
    return const Color(0xFFFAFAFA);
  }

  static BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFDFDFD),
          Color(0xFFF8F9FA),
          Color(0xFFF5F6F8),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  static PreferredSizeWidget _buildAppBar(
    int selectedNavIndex,
    Function(int) onNavItemTapped,
    VoidCallback? onHistoryTapped,
  ) {
    return AppBar(
      backgroundColor: const Color(0xFF000233),
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.fish, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Teleo',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        if (onHistoryTapped != null)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => _safeCallHistoryCallback(
                  context, 
                  onHistoryTapped, 
                  'Failed to open prayer history'
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(Icons.history, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: const Color(0xFF000233),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Builder(
                builder: (context) => _buildNavItem(
                  context,
                  Icons.favorite_border,
                  'Prayers',
                  selectedNavIndex == 2,
                  () => _safeCallNavCallback(
                    context,
                    onNavItemTapped,
                    2,
                    'Failed to navigate to prayers'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Enhanced nav item with error handling
  static Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: Colors.blue, width: 3.0),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPrayersTab({
    required BuildContext context,
    required bool isLoading,
    required List<PrayerPost> prayerPosts,
    required bool allCardsSwiped,
    required int currentCardIndex,
    required List<Color> cardColors,
    required VoidCallback refreshPrayerWall,
    required VoidCallback onLike,
    required Function(String?) onPray,
    required VoidCallback onComment,
    required Function(dynamic) onSwipe,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        try {
          refreshPrayerWall();
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          _showErrorSnackBar(context, 'Failed to refresh prayer wall');
        }
      },
      color: const Color(0xFF000233),
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 50,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: isLoading
                      ? _buildLoadingIndicator()
                      : prayerPosts.isEmpty
                          ? _buildEmptyScreen(context, refreshPrayerWall)
                          : allCardsSwiped
                              ? _buildRefreshScreen(context, refreshPrayerWall)
                              : _buildPrayerCards(
                                  context: context,
                                  prayerPosts: prayerPosts,
                                  currentCardIndex: currentCardIndex,
                                  cardColors: cardColors,
                                  onLike: onLike,
                                  onPray: onPray,
                                  onComment: onComment,
                                  onSwipe: onSwipe,
                                ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000233)),
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Loading prayers...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ✅ Enhanced empty screen with error handling
  static Widget _buildEmptyScreen(BuildContext context, VoidCallback refreshPrayerWall) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF000233).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFF000233),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No prayers yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Be the first to share a prayer request\nor check back later for new ones.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildRefreshButton(
              context,
              () => _safeCallCallback(context, refreshPrayerWall, 'Failed to refresh prayer wall'),
              'Refresh Prayer Wall'
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Enhanced refresh screen with error handling
  static Widget _buildRefreshScreen(BuildContext context, VoidCallback refreshPrayerWall) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'All caught up!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ve seen all current prayer requests.\nRefresh to check for new ones.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildRefreshButton(
              context,
              () => _safeCallCallback(context, refreshPrayerWall, 'Failed to check for new prayers'),
              'Check for New Prayers'
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Enhanced refresh button with error handling
  static Widget _buildRefreshButton(BuildContext context, VoidCallback onPressed, String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000233).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000233),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded, size: 22),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ✅ Enhanced prayer cards with error handling
  static Widget _buildPrayerCards({
    required BuildContext context,
    required List<PrayerPost> prayerPosts,
    required int currentCardIndex,
    required List<Color> cardColors,
    required VoidCallback onLike,
    required Function(String?) onPray,
    required VoidCallback onComment,
    required Function(dynamic) onSwipe,
  }) {
    try {
      // Safety check for valid indices
      if (prayerPosts.isEmpty || currentCardIndex >= prayerPosts.length || currentCardIndex < 0) {
        return _buildErrorState(context, 'Invalid prayer data');
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background stack cards with subtle shadow
            for (int i = 0; i < math.min(3, prayerPosts.length - 1); i++)
              Positioned(
                child: Transform.scale(
                  scale: 0.88 - (0.04 * i),
                  child: Transform.rotate(
                    angle: (i % 2 == 0 ? 0.03 : -0.03),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: cardColors[
                            (currentCardIndex + i + 1) % cardColors.length],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08 - (0.02 * i)),
                            blurRadius: 15 - (3.0 * i),
                            offset: Offset(0, 6 - (1.0 * i)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            // Main prayer card with enhanced shadow and error handling
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  try {
                    onSwipe(details);
                  } catch (e) {
                    _showErrorSnackBar(context, 'Failed to process swipe gesture');
                  }
                },
                child: _buildSafePrayerCard(
                  context: context,
                  prayerPosts: prayerPosts,
                  currentCardIndex: currentCardIndex,
                  cardColors: cardColors,
                  onLike: onLike,
                  onPray: onPray,
                  onComment: onComment,
                  onSwipe: onSwipe,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildErrorState(context, 'Failed to load prayer cards');
    }
  }

  // ✅ Safe prayer card wrapper with error handling
  static Widget _buildSafePrayerCard({
    required BuildContext context,
    required List<PrayerPost> prayerPosts,
    required int currentCardIndex,
    required List<Color> cardColors,
    required VoidCallback onLike,
    required Function(String?) onPray,
    required VoidCallback onComment,
    required Function(dynamic) onSwipe,
  }) {
    try {
      return PrayerCard(
        post: prayerPosts[currentCardIndex],
        cardColor: cardColors[currentCardIndex % cardColors.length],
        nextCardColor: cardColors[(currentCardIndex + 1) % cardColors.length],
        onLike: () => _safeCallCallback(context, onLike, 'Failed to like prayer'),
        onPray: (prayerMessage) {
          try {
            onPray(prayerMessage);
          } catch (e) {
            _showErrorSnackBar(context, 'Failed to submit prayer');
          }
        },
        onComment: () => _safeCallCallback(context, onComment, 'Failed to open comments'),
        onSwipe: (details) {
          try {
            onSwipe(details);
          } catch (e) {
            _showErrorSnackBar(context, 'Failed to process swipe');
          }
        },
      );
    } catch (e) {
      return _buildErrorState(context, 'Failed to display prayer card');
    }
  }

  // ✅ Add error state widget
  static Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.shade200,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade400,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                try {
                  // Try to reload the page or go back
                  Navigator.of(context).pop();
                } catch (e) {
                  _showErrorSnackBar(context, 'Please restart the app');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000233),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}