import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teleo_organized_new/3/models/prayer_post.dart';
import 'package:teleo_organized_new/3/widgets/prayer_homescreen/prayer_card.dart';
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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(selectedNavIndex, onNavItemTapped, onHistoryTapped),
      body: _buildPrayersTab(
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
      floatingActionButton: FloatingActionButton(
        onPressed: onAddPrayer,
        backgroundColor: const Color(0xFF0A0A2A),
        child: const Icon(Icons.add, color: Colors.white),
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
        // History button available for all users
        if (onHistoryTapped != null)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: onHistoryTapped,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
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
              _buildNavItem(
                Icons.favorite_border,
                'Prayers',
                selectedNavIndex == 2,
                () => onNavItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNavItem(
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
          border:
              isSelected
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : prayerPosts.isEmpty
              ? _buildEmptyScreen(refreshPrayerWall)
              : allCardsSwiped
              ? _buildRefreshScreen(refreshPrayerWall)
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
    );
  }

  static Widget _buildEmptyScreen(VoidCallback refreshPrayerWall) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh,
                color: Color(0xFF1A4B9C),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No prayers available',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A0E2D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'There are no prayer requests at the moment. Check back later or refresh.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: refreshPrayerWall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003B7A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Refresh Prayer Wall',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildRefreshScreen(VoidCallback refreshPrayerWall) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh,
                color: Color(0xFF1A4B9C),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'You\'ve seen all prayers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A0E2D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Check back later or refresh to see if there are new prayer requests.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: refreshPrayerWall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003B7A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Refresh Prayer Wall',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < math.min(3, prayerPosts.length - 1); i++)
          Positioned(
            child: Transform.scale(
              scale: 0.85 - (0.05 * i),
              child: Transform.rotate(
                angle: (i % 2 == 0 ? 0.05 : -0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        cardColors[(currentCardIndex + i + 1) %
                            cardColors.length],
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            onSwipe(details);
          },
          child: PrayerCard(
            post: prayerPosts[currentCardIndex],
            cardColor: cardColors[currentCardIndex % cardColors.length],
            nextCardColor:
                cardColors[(currentCardIndex + 1) % cardColors.length],
            onLike: onLike,
            onPray: onPray,
            onComment: onComment,
            onSwipe: onSwipe,
          ),
        ),
      ],
    );
  }
}
