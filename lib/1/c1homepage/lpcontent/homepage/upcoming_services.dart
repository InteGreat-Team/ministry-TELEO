import 'package:flutter/material.dart';

// Model for service data
class ServiceModel {
  final String id;
  final String title;
  final String time;
  final String? imageUrl;
  final String? description;
  final DateTime? date;
  final String? location;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.time,
    this.imageUrl,
    this.description,
    this.date,
    this.location,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      location: json['location'],
    );
  }
}

class UpcomingServices extends StatelessWidget {
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;
  final List<ServiceModel>? services;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final Function(ServiceModel)? onServiceTap;

  const UpcomingServices({
    super.key,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
    this.services,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = getResponsivePadding();
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        getResponsiveValue(24, 28, 32),
        horizontalPadding,
        getResponsiveValue(20, 24, 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Services',
                style: TextStyle(
                  fontSize: getResponsiveValue(18, 20, 22),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (error != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: Icon(
                    Icons.refresh,
                    size: getResponsiveValue(18, 20, 22),
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          SizedBox(height: getResponsiveValue(16, 18, 20)),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (error != null) {
      return _buildErrorState();
    }

    if (services == null || services!.isEmpty) {
      return _buildEmptyState();
    }

    return _buildServicesList();
  }

  Widget _buildLoadingState() {
    return Row(
      children: [
        Expanded(child: _buildLoadingCard()),
        SizedBox(width: getResponsiveValue(12, 14, 16)),
        Expanded(child: _buildLoadingCard()),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: getResponsiveValue(100, 110, 120),
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(getResponsiveValue(12, 14, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getResponsiveValue(14, 15, 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: getResponsiveValue(8, 9, 10)),
                Container(
                  height: getResponsiveValue(12, 13, 14),
                  width: 60,
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
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(getResponsiveValue(16, 18, 20)),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: getResponsiveValue(20, 22, 24),
          ),
          SizedBox(width: getResponsiveValue(8, 10, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to load services',
                  style: TextStyle(
                    fontSize: getResponsiveValue(13, 14, 15),
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(
                      fontSize: getResponsiveValue(11, 12, 13),
                      color: Colors.red.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(getResponsiveValue(24, 28, 32)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: getResponsiveValue(40, 45, 50),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: getResponsiveValue(8, 10, 12)),
            Text(
              'No upcoming services',
              style: TextStyle(
                fontSize: getResponsiveValue(14, 15, 16),
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    // For the main display, show max 2 services in a row
    final displayServices = services!.take(2).toList();
    
    return Row(
      children: [
        for (int i = 0; i < displayServices.length; i++) ...[
          if (i > 0) SizedBox(width: getResponsiveValue(12, 14, 16)),
          Expanded(
            child: _buildServiceCard(displayServices[i]),
          ),
        ],
        // Fill remaining space if only one service
        if (displayServices.length == 1) ...[
          SizedBox(width: getResponsiveValue(12, 14, 16)),
          Expanded(child: Container()),
        ],
      ],
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return GestureDetector(
      onTap: () => onServiceTap?.call(service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: getResponsiveValue(100, 110, 120),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: service.imageUrl != null
                    ? Image.network(
                        service.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      )
                    : _buildDefaultImage(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getResponsiveValue(12, 14, 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: getResponsiveValue(13, 14, 15),
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: getResponsiveValue(4, 5, 6)),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: getResponsiveValue(12, 13, 14),
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        service.time,
                        style: TextStyle(
                          fontSize: getResponsiveValue(11, 12, 13),
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  if (service.date != null) ...[
                    SizedBox(height: getResponsiveValue(2, 3, 4)),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: getResponsiveValue(12, 13, 14),
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatDate(service.date!),
                          style: TextStyle(
                            fontSize: getResponsiveValue(11, 12, 13),
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          // Background pattern or gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[100]!,
                  Colors.grey[200]!,
                  Colors.grey[300]!,
                ],
              ),
            ),
          ),
          // Icon overlay
          Center(
            child: Icon(
              Icons.church,
              size: getResponsiveValue(40, 45, 50),
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final serviceDate = DateTime(date.year, date.month, date.day);

    if (serviceDate == today) {
      return 'Today';
    } else if (serviceDate == tomorrow) {
      return 'Tomorrow';
    } else {
      // Format as "Jan 15" or similar
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }
}