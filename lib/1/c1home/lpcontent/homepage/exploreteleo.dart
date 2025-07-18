import 'package:flutter/material.dart';

// Model for TELEO service data
class TeleoServiceModel {
  final String id;
  final String title;
  final String description;
  final String badgeText;
  final String? iconUrl;
  final IconData? iconData;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? badgeColor;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  const TeleoServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeText,
    this.iconUrl,
    this.iconData,
    this.primaryColor,
    this.backgroundColor,
    this.badgeColor,
    this.actionUrl,
    this.metadata,
  });

  factory TeleoServiceModel.fromJson(Map<String, dynamic> json) {
    return TeleoServiceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      badgeText: json['badgeText'] ?? '',
      iconUrl: json['iconUrl'],
      iconData: _getIconFromName(json['iconName']),
      primaryColor: json['primaryColor'] != null 
          ? Color(int.parse(json['primaryColor'].toString().replaceFirst('#', '0xFF')))
          : null,
      backgroundColor: json['backgroundColor'] != null
          ? Color(int.parse(json['backgroundColor'].toString().replaceFirst('#', '0xFF')))
          : null,
      badgeColor: json['badgeColor'] != null
          ? Color(int.parse(json['badgeColor'].toString().replaceFirst('#', '0xFF')))
          : null,
      actionUrl: json['actionUrl'],
      metadata: json['metadata'],
    );
  }

  static IconData? _getIconFromName(String? iconName) {
    if (iconName == null) return null;
    
    final iconMap = {
      'visibility': Icons.visibility,
      'book': Icons.book,
      'event': Icons.event,
      'person': Icons.person,
      'church': Icons.church,
      'favorite': Icons.favorite,
      'group': Icons.group,
      'music_note': Icons.music_note,
      'schedule': Icons.schedule,
      'location_on': Icons.location_on,
    };
    
    return iconMap[iconName];
  }
}

class ExploreTELEO extends StatefulWidget {
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;
  final List<TeleoServiceModel>? services;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final Function(TeleoServiceModel)? onServiceTap;
  final String? title;
  final bool showDots;
  final Color? accentColor;

  const ExploreTELEO({
    super.key,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
    this.services,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onServiceTap,
    this.title,
    this.showDots = true,
    this.accentColor,
  });

  @override
  State<ExploreTELEO> createState() => _ExploreTELEOState();
}

class _ExploreTELEOState extends State<ExploreTELEO> {
  int _currentSlideIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.getResponsivePadding();
    
    if (_pageController == null) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        widget.getResponsiveValue(20, 24, 28),
        0,
        widget.getResponsiveValue(20, 24, 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? 'Explore TELEO',
                  style: TextStyle(
                    fontSize: widget.getResponsiveValue(18, 20, 22),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (widget.error != null)
                  IconButton(
                    onPressed: widget.onRefresh,
                    icon: Icon(
                      Icons.refresh,
                      size: widget.getResponsiveValue(18, 20, 22),
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: widget.getResponsiveValue(16, 18, 20)),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.error != null) {
      return _buildErrorState();
    }

    if (widget.services == null || widget.services!.isEmpty) {
      return _buildEmptyState();
    }

    return _buildServicesCarousel();
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SizedBox(
          height: widget.getResponsiveValue(160, 180, 200), // Reduced height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : widget.getResponsiveValue(8, 10, 12),
                  right: widget.getResponsiveValue(16, 18, 20),
                ),
                child: _buildLoadingCard(),
              );
            },
          ),
        ),
        if (widget.showDots) ...[
          SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
          _buildDotIndicator(3, 0),
        ],
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: widget.getResponsiveValue(200, 220, 240),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(widget.getResponsiveValue(16, 18, 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      width: widget.getResponsiveValue(60, 70, 80), // Reduced icon size
                      height: widget.getResponsiveValue(60, 70, 80), // Reduced icon size
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: widget.getResponsiveValue(16, 18, 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: widget.getResponsiveValue(6, 8, 10)),
                      Container(
                        height: widget.getResponsiveValue(12, 13, 14),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: widget.getResponsiveValue(4, 5, 6)),
                      Container(
                        height: widget.getResponsiveValue(12, 13, 14),
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: widget.getResponsiveValue(12, 14, 16),
            left: widget.getResponsiveValue(12, 14, 16),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.getResponsiveValue(8, 10, 12),
                vertical: widget.getResponsiveValue(4, 5, 6),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: widget.getResponsiveValue(40, 45, 50),
                height: widget.getResponsiveValue(10, 11, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: widget.getResponsiveValue(160, 180, 200), // Reduced height
      padding: EdgeInsets.all(widget.getResponsiveValue(16, 18, 20)),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: widget.getResponsiveValue(32, 36, 40), // Reduced icon size
            ),
            SizedBox(height: widget.getResponsiveValue(8, 10, 12)),
            Text(
              'Unable to load services',
              style: TextStyle(
                fontSize: widget.getResponsiveValue(16, 18, 20),
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            if (widget.error != null) ...[
              SizedBox(height: widget.getResponsiveValue(4, 5, 6)),
              Text(
                widget.error!,
                style: TextStyle(
                  fontSize: widget.getResponsiveValue(12, 13, 14),
                  color: Colors.red.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: widget.getResponsiveValue(160, 180, 200), // Reduced height
      padding: EdgeInsets.all(widget.getResponsiveValue(24, 28, 32)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_off,
              size: widget.getResponsiveValue(48, 56, 64), // Reduced icon size
              color: Colors.grey.shade400,
            ),
            SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
            Text(
              'No services available',
              style: TextStyle(
                fontSize: widget.getResponsiveValue(16, 18, 20),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: widget.getResponsiveValue(4, 5, 6)),
            Text(
              'Check back later for updates',
              style: TextStyle(
                fontSize: widget.getResponsiveValue(12, 13, 14),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCarousel() {
    return Column(
      children: [
        SizedBox(
          height: widget.getResponsiveValue(160, 180, 200), // Reduced height
          child: PageView.builder(
            controller: _pageController!,
            onPageChanged: (index) {
              setState(() {
                _currentSlideIndex = index;
              });
            },
            itemCount: widget.services!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : widget.getResponsiveValue(8, 10, 12),
                  right: widget.getResponsiveValue(16, 18, 20),
                ),
                child: _buildServiceCard(widget.services![index]),
              );
            },
          ),
        ),
        if (widget.showDots && widget.services!.length > 1) ...[
          SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
          _buildDotIndicator(widget.services!.length, _currentSlideIndex),
        ],
      ],
    );
  }

  Widget _buildDotIndicator(int count, int currentIndex) {
    return Padding(
      padding: EdgeInsets.only(right: widget.getResponsivePadding()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.getResponsiveValue(3, 4, 5),
            ),
            width: widget.getResponsiveValue(6, 7, 8),
            height: widget.getResponsiveValue(6, 7, 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? (widget.accentColor ?? const Color(0xFFFFB74D))
                  : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildServiceCard(TeleoServiceModel service) {
    final primaryColor = service.primaryColor ?? const Color(0xFF1A237E);
    final backgroundColor = service.backgroundColor ?? const Color(0xFFF5F5F0);
    final badgeColor = service.badgeColor ?? const Color(0xFFFFB74D);

    return GestureDetector(
      onTap: () => widget.onServiceTap?.call(service),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(widget.getResponsiveValue(16, 18, 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        width: widget.getResponsiveValue(60, 70, 80), // Reduced icon size
                        height: widget.getResponsiveValue(60, 70, 80), // Reduced icon size
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _buildServiceIcon(service, primaryColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: TextStyle(
                            fontSize: widget.getResponsiveValue(14, 16, 18),
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: widget.getResponsiveValue(6, 8, 10)),
                        Expanded(
                          child: Text(
                            service.description,
                            style: TextStyle(
                              fontSize: widget.getResponsiveValue(11, 12, 13),
                              color: Colors.black87,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2, // Reduced from 3 to 2 lines
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: widget.getResponsiveValue(12, 14, 16),
              left: widget.getResponsiveValue(12, 14, 16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.getResponsiveValue(8, 10, 12),
                  vertical: widget.getResponsiveValue(4, 5, 6),
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service.badgeText,
                  style: TextStyle(
                    fontSize: widget.getResponsiveValue(9, 10, 11),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(TeleoServiceModel service, Color primaryColor) {
    if (service.iconUrl != null) {
      return Container(
        width: widget.getResponsiveValue(40, 45, 50), // Reduced icon size
        height: widget.getResponsiveValue(40, 45, 50), // Reduced icon size
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            service.iconUrl!,
            width: widget.getResponsiveValue(20, 22, 24), // Reduced icon size
            height: widget.getResponsiveValue(20, 22, 24), // Reduced icon size
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultIcon(service.iconData ?? Icons.visibility);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              );
            },
          ),
        ),
      );
    }

    return _buildDefaultIcon(service.iconData ?? Icons.visibility);
  }

  Widget _buildDefaultIcon(IconData icon) {
    return Container(
      width: widget.getResponsiveValue(40, 45, 50), // Reduced icon size
      height: widget.getResponsiveValue(40, 45, 50), // Reduced icon size
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: widget.getResponsiveValue(20, 22, 24), // Reduced icon size
        color: Colors.white,
      ),
    );
  }
}