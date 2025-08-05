import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Event model for backend integration
class Event {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime? date;
  final String? location;
  final bool isTicketRequired;
  final String? ticketUrl;
  final EventStatus status;

  const Event({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.date,
    this.location,
    this.isTicketRequired = false,
    this.ticketUrl,
    this.status = EventStatus.active,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      location: json['location'],
      isTicketRequired: json['isTicketRequired'] ?? false,
      ticketUrl: json['ticketUrl'],
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.active,
      ),
    );
  }
}

enum EventStatus { active, inactive, upcoming, past }

class Events extends StatefulWidget {
  final double Function(double, double, double) getResponsiveValue;
  final double Function() getResponsivePadding;
  final List<Event> events;
  final Function(Event)? onEventTap;
  final Function(Event)? onGetTicket;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const Events({
    super.key,
    required this.getResponsiveValue,
    required this.getResponsivePadding,
    this.events = const [],
    this.onEventTap,
    this.onGetTicket,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.getResponsivePadding();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        widget.getResponsiveValue(20, 24, 28),
        horizontalPadding,
        widget.getResponsiveValue(20, 24, 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(),
          SizedBox(height: widget.getResponsiveValue(16, 18, 20)),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      'Events',
      style: TextStyle(
        fontSize: widget.getResponsiveValue(18, 20, 22),
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.errorMessage != null) {
      return _buildErrorState();
    }

    if (widget.events.isEmpty) {
      return _buildEmptyState();
    }

    return _buildEventsList();
  }

  Widget _buildLoadingState() {
    return Container(
      height: widget.getResponsiveValue(200, 220, 240),
      decoration: _getCardDecoration(),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(widget.getResponsiveValue(16, 18, 20)),
      decoration: _getCardDecoration(),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: widget.getResponsiveValue(50, 60, 70),
            color: Colors.red[400],
          ),
          SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
          Text(
            widget.errorMessage ?? 'Failed to load events',
            style: TextStyle(
              fontSize: widget.getResponsiveValue(14, 15, 16),
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onRetry != null) ...[
            SizedBox(height: widget.getResponsiveValue(16, 18, 20)),
            ElevatedButton(onPressed: widget.onRetry, child: Text('Retry')),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final horizontalPadding = widget.getResponsivePadding();
    return Container(
      height: 220.0, // Match ServicesConfig default cardHeight
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.all(widget.getResponsiveValue(32, 36, 40)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: widget.getResponsiveValue(40, 50, 60),
              color: Colors.grey[400],
            ),
            SizedBox(height: widget.getResponsiveValue(12, 14, 16)),
            Text(
              'No events available',
              style: TextStyle(
                fontSize: widget.getResponsiveValue(14, 15, 16),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Column(
      children: widget.events.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.getResponsiveValue(12, 14, 16)),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildEventImage(event), _buildEventDetails(event)],
      ),
    );
  }

  Widget _buildEventImage(Event event) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        height: widget.getResponsiveValue(140, 160, 180),
        width: double.infinity,
        child:
            event.imageUrl != null && event.imageUrl!.isNotEmpty
                ? Image.network(
                  event.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => _buildPlaceholderImage(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholderImage();
                  },
                )
                : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.event,
        size: widget.getResponsiveValue(50, 60, 70),
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    return Padding(
      padding: EdgeInsets.all(widget.getResponsiveValue(16, 18, 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: TextStyle(
              fontSize: widget.getResponsiveValue(16, 18, 20),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (event.description != null) ...[
            SizedBox(height: widget.getResponsiveValue(8, 10, 12)),
            Text(
              event.description!,
              style: TextStyle(
                fontSize: widget.getResponsiveValue(14, 15, 16),
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (event.date != null) ...[
            SizedBox(height: widget.getResponsiveValue(8, 10, 12)),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: widget.getResponsiveValue(16, 18, 20),
                  color: Colors.grey[600],
                ),
                SizedBox(width: widget.getResponsiveValue(4, 6, 8)),
                Text(
                  _formatDate(event.date!),
                  style: TextStyle(
                    fontSize: widget.getResponsiveValue(12, 13, 14),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
          if (event.location != null) ...[
            SizedBox(height: widget.getResponsiveValue(4, 6, 8)),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: widget.getResponsiveValue(16, 18, 20),
                  color: Colors.grey[600],
                ),
                SizedBox(width: widget.getResponsiveValue(4, 6, 8)),
                Expanded(
                  child: Text(
                    event.location!,
                    style: TextStyle(
                      fontSize: widget.getResponsiveValue(12, 13, 14),
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: widget.getResponsiveValue(16, 18, 20)),
          _buildEventActions(event),
        ],
      ),
    );
  }

  Widget _buildEventActions(Event event) {
    return Row(
      children: [
        if (event.isTicketRequired) ...[
          Expanded(
            child: ElevatedButton(
              onPressed:
                  event.status == EventStatus.active
                      ? () {
                        HapticFeedback.lightImpact();
                        widget.onGetTicket?.call(event);
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3949ab),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: widget.getResponsiveValue(12, 14, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                _getTicketButtonText(event.status),
                style: TextStyle(
                  fontSize: widget.getResponsiveValue(14, 15, 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        if (widget.onEventTap != null) ...[
          if (event.isTicketRequired)
            SizedBox(width: widget.getResponsiveValue(8, 10, 12)),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onEventTap?.call(event);
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: widget.getResponsiveValue(12, 14, 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Color(0xFF3949ab)),
              ),
              child: Text(
                'Learn More',
                style: TextStyle(
                  fontSize: widget.getResponsiveValue(14, 15, 16),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3949ab),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(date.year, date.month, date.day);

    if (eventDate == today) {
      return 'Today at ${_formatTime(date)}';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getTicketButtonText(EventStatus status) {
    switch (status) {
      case EventStatus.active:
        return 'Get Ticket';
      case EventStatus.upcoming:
        return 'Coming Soon';
      case EventStatus.past:
        return 'Event Ended';
      case EventStatus.inactive:
        return 'Unavailable';
    }
  }
}

// Usage example:
/*
Events(
  getResponsiveValue: (small, medium, large) => medium,
  getResponsivePadding: () => 16.0,
  events: [
    Event(
      id: '1',
      title: 'Celebration of Christ the King',
      description: 'Join us for this special celebration...',
      date: DateTime.now().add(Duration(days: 7)),
      location: 'Main Church',
      isTicketRequired: true,
      status: EventStatus.active,
    ),
  ],
  onGetTicket: (event) {
    // Handle ticket purchase
  },
  onEventTap: (event) {
    // Handle event details view
  },
  isLoading: false,
  errorMessage: null,
  onRetry: () {
    // Handle retry
  },
)
*/
