import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../../../prayer_wall/BE/models/prayer_post.dart';
import '../../../../prayer_wall/BE/providers/read_prayer_provider.dart';
import 'package:intl/intl.dart';

enum SwipeDirection { right, left }

class PrayerCard extends StatefulWidget {
  final PrayerPost post;
  final Color cardColor;
  final Color nextCardColor;
  final VoidCallback onLike;
  final Function(String?) onPray;
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
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _swipeController;
  late AnimationController _likeController;
  late Animation<double> _flipAnimation;
  late Animation<double> _swipeAnimation;
  late Animation<double> _likeAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _showBackSide = false;
  double _dragStartX = 0;
  double _dragUpdateX = 0;
  bool _isDragging = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  
  // Track comment status - once commented, prayer is restricted
  bool _hasCommented = false;

  @override
  void initState() {
    super.initState();
    
    // Optimized animation controllers with better curves
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _flipController, 
      curve: Curves.easeInOutCubic,
    ));

    _swipeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.elasticOut,
    ));

    _likeAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _removeOverlay();
    _flipController.dispose();
    _swipeController.dispose();
    _likeController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_showBackSide) {
      _flipController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showBackSide = false;
          });
        }
      });
    } else {
      setState(() {
        _showBackSide = true;
      });
      _flipController.forward();
    }
  }

  void _animateLike() {
    _likeController.forward().then((_) {
      _likeController.reverse();
    });
  }

  void _showPrayerOptions(BuildContext context) {
    if (_hasCommented) {
      _showAlreadyPrayedMessage(context);
      return;
    }
    
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

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, -220),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Material(
                      elevation: 16.0,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 300,
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      color: widget.post.cardColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Choose a Prayer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: prayerOptions
                                        .map(
                                          (option) => InkWell(
                                            onTap: () {
                                              _removeOverlay();
                                              widget.onPray(option["text"]);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey.withOpacity(0.1),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 4,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: widget.post.cardColor.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      option["text"],
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Color(0xFF4A5568),
                                                        height: 1.4,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showAlreadyPrayedMessage(BuildContext context) {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, -100),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Material(
                      elevation: 16.0,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 250,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: widget.post.cardColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'You have prayed already!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C3E50),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    
    // Auto-remove the message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _removeOverlay();
    });
  }

  void _showAlreadyCommentedMessage(BuildContext context) {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, -100),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Material(
                      elevation: 16.0,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 250,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble,
                                  color: widget.post.cardColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'You have commented already!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C3E50),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    
    // Auto-remove the message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _removeOverlay();
    });
  }

  void _handleComment() {
    setState(() {
      _hasCommented = true;
    });
    widget.onComment();
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
        _swipeController.forward();
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragUpdateX = details.globalPosition.dx - _dragStartX;
        });
      },
      onHorizontalDragEnd: (details) async {
        final threshold = MediaQuery.of(context).size.width * 0.25;
        if (_dragUpdateX.abs() > threshold) {
          bool isSwipeRight;
          if (_showBackSide) {
            isSwipeRight = _dragUpdateX < 0;
          } else {
            isSwipeRight = _dragUpdateX > 0;
          }

          widget.onSwipe(
            isSwipeRight ? SwipeDirection.right : SwipeDirection.left,
          );

          if (isSwipeRight) {
            final provider =
                Provider.of<PrayerReadProvider>(context, listen: false);
            provider.markPrayerAsRead(widget.post.id.toString());
          }
        }
        
        _swipeController.reverse();
        setState(() {
          _dragStartX = 0;
          _dragUpdateX = 0;
          _isDragging = false;
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnimation, _swipeAnimation, _scaleAnimation]),
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          
          double dragOffset = 0;
          double rotationOffset = 0;
          
          if (_isDragging) {
            final normalizedDrag = _dragUpdateX / MediaQuery.of(context).size.width;
            if (_showBackSide) {
              dragOffset = -_dragUpdateX * 0.3;
              rotationOffset = normalizedDrag * 0.1;
            } else {
              dragOffset = _dragUpdateX * 0.3;
              rotationOffset = -normalizedDrag * 0.1;
            }
          }

          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle)
            ..rotateZ(rotationOffset)
            ..translate(dragOffset, 0, 0)
            ..scale(_scaleAnimation.value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle < math.pi / 2
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
    return Hero(
      tag: 'prayer_card_${widget.post.id}',
      child: Container(
        width: MediaQuery.of(context).size.width * 0.88,
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 40,
              spreadRadius: 0,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.post.cardColor,
                  widget.post.cardColor.withOpacity(0.85),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Subtle pattern overlay
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/prayer_pattern.png'),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.repeat,
                        ),
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
                      _buildUserInfo(),
                      const SizedBox(height: 28),
                      _buildPrayerContent(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
                // Subtle shine effect
                if (_isDragging)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(widget.post.userAvatar),
            radius: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.userName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.post.tags.join(' • '),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                DateFormat('MMM d, yyyy • hh:mm a').format(widget.post.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerContent() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              widget.post.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          icon: widget.post.hasLiked ? Icons.favorite : Icons.favorite_border,
          iconColor: widget.post.hasLiked ? Colors.red.shade400 : Colors.white,
          onTap: () {
            _animateLike();
            widget.onLike();
          },
          scale: _likeAnimation,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CompositedTransformTarget(
              link: _layerLink,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showPrayerOptions(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasCommented 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  icon: Icon(
                    Icons.front_hand_outlined, 
                    size: 18
                  ),
                  label: Text(
                    'Pray',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.white,
          onTap: _handleComment,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    Animation<double>? scale,
  }) {
    Widget button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );

    if (scale != null) {
      return AnimatedBuilder(
        animation: scale,
        builder: (context, child) {
          return Transform.scale(
            scale: scale.value,
            child: button,
          );
        },
      );
    }

    return button;
  }

  Widget _buildBackSide() {
    return Hero(
      tag: 'prayer_card_back_${widget.post.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          height: 420,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              // Enhanced gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.post.cardColor,
                      widget.post.cardColor.withOpacity(0.9),
                      widget.post.cardColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Subtle next card color hint
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.nextCardColor.withOpacity(0.4),
                        widget.nextCardColor.withOpacity(0.2),
                        widget.nextCardColor.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackUserInfo(),
                    const SizedBox(height: 28),
                    _buildDetailsContent(),
                    const SizedBox(height: 24),
                    _buildBackActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackUserInfo() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(widget.post.userAvatar),
            radius: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.userName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Prayer Details',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsContent() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Text(
            widget.post.details,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.6,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: widget.post.hasLiked ? Icons.favorite : Icons.favorite_border,
          iconColor: widget.post.hasLiked ? Colors.red.shade400 : Colors.white,
          onTap: () {
            _animateLike();
            widget.onLike();
          },
          scale: _likeAnimation,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _showPrayerOptions(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasCommented 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                icon: Icon(
                  Icons.front_hand_outlined, 
                  size: 18
                ),
                label: Text(
                  'Pray',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.white,
          onTap: _handleComment,
        ),
      ],
    );
  }
}
