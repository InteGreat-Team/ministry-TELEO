import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:teleo_organized_new/3/models/prayer_post.dart';

// Define SwipeDirection enum to fix the undefined class error
enum SwipeDirection { right, left }

class PrayerCard extends StatefulWidget {
  final PrayerPost post;
  final Color cardColor;
  final Color nextCardColor;
  final VoidCallback onLike;
  final Function(String?) onPray; // Updated to accept a prayer message
  final VoidCallback onComment;
  final Function(SwipeDirection) onSwipe;

  const PrayerCard({
    super.key,
    required this.post,
    required this.cardColor,
    required this.nextCardColor,
    required this.onLike,
    required this.onPray,
    required this.onComment,
    required this.onSwipe,
  });

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showBackSide = false;
  double _dragStartX = 0;
  double _dragUpdateX = 0;
  bool _isDragging = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_showBackSide) {
      _controller.reverse().then((_) {
        setState(() {
          _showBackSide = false;
        });
      });
    } else {
      _controller.forward().then((_) {
        setState(() {
          _showBackSide = true;
        });
      });
    }
  }

  void _showPrayerOptions(BuildContext context) {
    _removeOverlay();
    final List<Map<String, dynamic>> prayerOptions = [
      {
        "text":
            "3 John 1:2 - 'Beloved, I pray that all may go well with you and that you may be in good health, as it goes well with your soul.'",
      },
      {
        "text":
            "Mark 11:24 - 'Therefore I tell you, whatever you ask in prayer, believe that you have received it, and it will be yours.'",
      },
      {
        "text":
            "Philippians 4:6 - 'Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God.'",
      },
      {
        "text":
            "Matthew 6:33 - 'But seek first the kingdom of God and his righteousness, and all these things will be added to you.'",
      },
      {
        "text":
            "Isaiah 41:10 - 'So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand.'",
      },
    ];

    // Get the render box of the button

    // Create a backdrop that will dismiss the menu when tapped
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Transparent backdrop for detecting taps outside the menu
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _removeOverlay,
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Dropdown menu positioned directly above the button
              Positioned(
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, -210), // Position directly above the button
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 280,
                        maxHeight:
                            MediaQuery.of(context).size.height *
                            0.4, // Limit height to 40% of screen
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Prayer options
                            ...prayerOptions
                                .map(
                                  (option) => InkWell(
                                    onTap: () {
                                      _removeOverlay();
                                      widget.onPray(option["text"]);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option["text"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            // Dropdown arrow at the bottom
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      onHorizontalDragStart: (details) {
        setState(() {
          _dragStartX = details.globalPosition.dx;
          _isDragging = true;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragUpdateX = details.globalPosition.dx - _dragStartX;
        });
      },
      onHorizontalDragEnd: (details) {
        final threshold = MediaQuery.of(context).size.width * 0.3;
        if (_dragUpdateX.abs() > threshold) {
          // Fix: Account for card flip state when determining swipe direction
          bool isSwipeRight;
          if (_showBackSide) {
            // When card is flipped, invert the swipe direction logic
            isSwipeRight = _dragUpdateX < 0; // Inverted for back side
          } else {
            // Normal logic for front side
            isSwipeRight = _dragUpdateX > 0;
          }

          widget.onSwipe(
            isSwipeRight ? SwipeDirection.right : SwipeDirection.left,
          );
        }
        setState(() {
          _dragStartX = 0;
          _dragUpdateX = 0;
          _isDragging = false;
        });
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;

          // Fix: Apply drag offset correctly based on card state
          double dragOffset = 0;
          if (_isDragging) {
            if (_showBackSide) {
              // When card is flipped, invert the drag offset
              dragOffset = -_dragUpdateX * 0.5;
            } else {
              // Normal drag offset for front side
              dragOffset = _dragUpdateX * 0.5;
            }
          }

          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle)
                ..translate(dragOffset, 0, 0); // Apply only X translation

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child:
                angle < math.pi / 2
                    ? _buildFrontSide()
                    : Transform(
                      transform: Matrix4.identity()..rotateY(math.pi),
                      alignment: Alignment.center,
                      child: _buildBackSide(),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.post.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(widget.post.userAvatar),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.post.timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Prayer content
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  widget.post.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like button
              InkWell(
                onTap: widget.onLike,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.post.hasLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.hasLiked ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
              ),
              // Pray button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CompositedTransformTarget(
                    link: _layerLink,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showPrayerOptions(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.front_hand_outlined, size: 18),
                      label: const Text(
                        'Pray',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Comment button
              InkWell(
                onTap: widget.onComment,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        16,
      ), // Fixed: Add clipping to ensure consistent corners
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 400,
        decoration: BoxDecoration(
          color: widget.post.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.antiAlias, // Fixed: Ensure proper clipping
          children: [
            // Subtle next card color hint (optional - can be removed if causing issues)
            Positioned(
              right: -10,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8,
                decoration: BoxDecoration(
                  color: widget.nextCardColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(widget.post.userAvatar),
                        radius: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            widget.post.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Prayer details - main content of the back side
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.post.details,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  // Action buttons - now with Like, Pray, and Comment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Like button
                      InkWell(
                        onTap: widget.onLike,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.post.hasLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.post.hasLiked
                                    ? Colors.red
                                    : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Pray button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CompositedTransformTarget(
                            link: _layerLink,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showPrayerOptions(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(
                                Icons.front_hand_outlined,
                                size: 18,
                              ),
                              label: const Text(
                                'Pray',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Comment button
                      InkWell(
                        onTap: widget.onComment,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
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
