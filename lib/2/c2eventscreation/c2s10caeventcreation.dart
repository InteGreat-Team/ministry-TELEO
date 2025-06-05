import 'package:flutter/material.dart';
import 'dart:io';
import 'models/event.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'services/event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  // Other state variables
  bool _isDescriptionExpanded = false;
  late int _likeCount;
  bool _hasLiked = false;
  bool _showRegistrationNotification = false;
  bool _isRegistered = false;

  // Event URL for sharing - computed once
  late final String _eventUrl;

  // Formatters - create once and reuse
  final _dateFormatter = DateFormat('EEEE, MMMM d, yyyy');
  final _shortDateFormatter = DateFormat('MMM d');
  final _monthFormatter = DateFormat('MMM');

  // Cached values to avoid recalculation
  String? _formattedStartDate;
  String? _formattedStartTime;
  String? _formattedEndTime;

  // Image memory management
  ImageProvider? _cachedImage;
  bool _isImageLoading = true;

  // Screen size - initialized in didChangeDependencies
  late double _screenHeight;
  late double _screenWidth;
  bool _dependenciesInitialized = false;

  // Navy blue color used throughout the app
  final Color _navyBlue = const Color(0xFF0A0A4A);

  // Flag to track if event is saved to service
  bool _eventSaved = false;

  @override
  void initState() {
    super.initState();

    // Save the event to the EventService if not already saved
    _saveEventToService();

    // Initialize URL - do this once
    final urlTitle =
        widget.event.title != null
            ? widget.event.title!
                .toLowerCase()
                .replaceAll(' ', '-')
                .replaceAll(RegExp(r'[^\w-]'), '')
            : 'event';
    _eventUrl = 'https://churchapp.com/events/$urlTitle';

    // Initialize like count - do this once
    _likeCount = 50 + (DateTime.now().millisecondsSinceEpoch % 150);

    // Pre-calculate formatted dates and times
    if (widget.event.startDate != null) {
      _formattedStartDate = _dateFormatter.format(widget.event.startDate!);
    }

    if (widget.event.startTime != null) {
      _formattedStartTime = _formatTime(widget.event.startTime);
    }

    if (widget.event.endTime != null) {
      _formattedEndTime = _formatTime(widget.event.endTime);
    }
  }

  void _saveEventToService() {
    // Only save if not already saved
    if (!_eventSaved && widget.event.title != null) {
      // Check if event already exists in the service
      final eventService = EventService();

      // Only add the event if it doesn't already exist
      if (!eventService.eventExists(widget.event.title!)) {
        final eventMap = eventService.convertEventToMap(widget.event);
        final added = eventService.addEvent(eventMap);

        if (added) {
          setState(() {
            _eventSaved = true;
          });
        }
      } else {
        // Event already exists, just mark as saved
        setState(() {
          _eventSaved = true;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize screen dimensions here instead of in initState or build
    if (!_dependenciesInitialized) {
      final mediaQuery = MediaQuery.of(context);
      _screenHeight = mediaQuery.size.height;
      _screenWidth = mediaQuery.size.width;
      _dependenciesInitialized = true;

      // Pre-load image after dependencies are initialized
      _preloadImage();
    }
  }

  // Pre-load image with memory optimization
  void _preloadImage() {
    if (widget.event.imageBytes != null &&
        widget.event.imageBytes!.isNotEmpty) {
      _cachedImage = MemoryImage(widget.event.imageBytes!);
    } else if (widget.event.imageUrl != null &&
        widget.event.imageUrl!.isNotEmpty) {
      _cachedImage = NetworkImage(widget.event.imageUrl!);
    } else if (widget.event.imagePath != null && !kIsWeb) {
      _cachedImage = FileImage(File(widget.event.imagePath!));
    }

    if (_cachedImage != null) {
      // Precache image with reduced size
      precacheImage(_cachedImage!, context)
          .then((_) {
            if (mounted) {
              setState(() {
                _isImageLoading = false;
              });
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _isImageLoading = false;
                _cachedImage = null; // Clear on error
              });
            }
          });
    } else {
      _isImageLoading = false;
    }
  }

  @override
  void dispose() {
    // Clean up resources

    // Clear any cached data
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Clear cached image
    _cachedImage = null;

    super.dispose();
  }

  // Optimized date formatting - reuse formatters
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return _dateFormatter.format(date);
  }

  String _formatShortDate(DateTime? date) {
    if (date == null) return '';
    return _shortDateFormatter.format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void _toggleLike() {
    setState(() {
      if (_hasLiked) {
        _likeCount--;
      } else {
        _likeCount++;
        // Show a brief animation or feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You liked this event!'),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF0A0A4A),
          ),
        );
      }
      _hasLiked = !_hasLiked;
    });
  }

  void _toggleDescription() {
    setState(() {
      _isDescriptionExpanded = !_isDescriptionExpanded;
    });
  }

  // Function to register for the event
  void _registerForEvent() {
    setState(() {
      _isRegistered = true;
      _showRegistrationNotification = true;
    });

    // Auto-hide notification after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showRegistrationNotification = false;
        });
      }
    });
  }

  // Function to dismiss registration notification
  void _dismissNotification() {
    setState(() {
      _showRegistrationNotification = false;
    });
  }

  // Function to copy event URL to clipboard
  void _copyEventUrl() {
    Clipboard.setData(ClipboardData(text: _eventUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event URL copied to clipboard')),
    );
  }

  // Function to show share dialog - optimized to reduce memory usage
  void _showShareDialog() {
    // Use a lightweight dialog implementation
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Share Event', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event URL with copy button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _eventUrl,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          _copyEventUrl();
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Simplified sharing options
                const Text(
                  'Share via',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Simplified row of icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing via Facebook')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat, color: Colors.green),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing via WhatsApp')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.email, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing via Email')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.sms, color: Colors.orange),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing via SMS')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  // Function to navigate back to events tab
  void _navigateToEventsTab() {
    // Pop until we reach the main navigation screen
    Navigator.of(context).popUntil((route) => route.isFirst);

    // You might need to add additional logic here if your navigation is more complex
    // For example, if you need to switch to a specific tab in a bottom navigation bar
  }

  // Build the event image based on available sources - optimized for memory
  Widget _buildEventImage() {
    // Use const for placeholder dimensions to avoid recreating
    const int targetHeight = 300; // Reduced from 400
    const int targetWidth = 450; // Reduced from 600

    if (_isImageLoading) {
      return _buildPlaceholderImage(isLoading: true);
    }

    if (_cachedImage != null) {
      return Image(
        image: _cachedImage!,
        fit: BoxFit.cover,
        height: _screenHeight * 0.3, // Reduced from 0.5 to show more content
        width: double.infinity,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return _buildPlaceholderImage(isLoading: true);
          }
          return child;
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
        filterQuality:
            FilterQuality.low, // Use low quality for better performance
        gaplessPlayback: true, // Prevent flickering when image changes
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  // Build a placeholder image when no image is available - using const where possible
  Widget _buildPlaceholderImage({bool isLoading = false}) {
    return Container(
      height: _screenHeight * 0.3, // Match the height of the actual image
      color: Colors.grey[300],
      child: Center(
        child:
            isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  strokeWidth: 2.0,
                )
                : const Icon(Icons.image, size: 80, color: Colors.grey),
      ),
    );
  }

  // Extracted widget for event info container - reusable component
  Widget _buildInfoContainer({
    required Color backgroundColor,
    required Widget leading,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Leading widget
            leading,
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor ?? Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted widget for section title - reusable component
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Extracted widget for participant list - optimized for memory
  Widget _buildParticipantsList() {
    // Limit the number of items to display
    const int maxItemsToShow = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.event.expectedCapacity != null
                ? '${widget.event.expectedCapacity}+ attending'
                : '100+ attending',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        if (widget.event.inviteType == 'Open Invite')
          Text(
            'Open to everyone',
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          )
        else if (widget.event.invitedChurches.isNotEmpty ||
            widget.event.invitedGuests.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event.invitedChurches.isNotEmpty) ...[
                const Text(
                  'Invited Churches:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                // Use a more efficient approach for list rendering
                ...widget.event.invitedChurches
                    .take(maxItemsToShow)
                    .map(
                      (church) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• ${church.name}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                if (widget.event.invitedChurches.length > maxItemsToShow)
                  Text(
                    '+ ${widget.event.invitedChurches.length - maxItemsToShow} more',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
              if (widget.event.invitedGuests.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Invited Guests:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                // Use a more efficient approach for list rendering
                ...widget.event.invitedGuests
                    .take(maxItemsToShow)
                    .map(
                      (guest) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• ${guest.fullName}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                if (widget.event.invitedGuests.length > maxItemsToShow)
                  Text(
                    '+ ${widget.event.invitedGuests.length - maxItemsToShow} more',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ],
          )
        else
          Text(
            'No participants invited yet',
            style: TextStyle(
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get MediaQuery in build method, not as a class field
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            slivers: [
              // Event Image at the top
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Event Image
                    _buildEventImage(),

                    // Back Button
                    Positioned(
                      top: topPadding + 10,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    // Likes Button at top right
                    Positioned(
                      top: topPadding + 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: InkWell(
                          onTap: _toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                _hasLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _hasLiked ? Colors.red : _navyBlue,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Likes $_likeCount',
                                style: TextStyle(
                                  color: _navyBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content below the image
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        const SizedBox(height: 8),
                        Text(
                          widget.event.title ?? 'Untitled Event',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Organization name
                        Text(
                          'Church Name Organization',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Event tags
                        if (widget.event.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children:
                                widget.event.tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),

                        const SizedBox(height: 16),

                        // Date Container
                        _buildInfoContainer(
                          backgroundColor: const Color(0xFFFEEBEB),
                          leading: Container(
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _navyBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.event.startDate != null
                                      ? _monthFormatter.format(
                                        widget.event.startDate!,
                                      )
                                      : 'APR',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.event.startDate?.day.toString() ??
                                      '25',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title:
                              _formattedStartDate ?? 'Friday, April 25, 2025',
                          subtitle:
                              '${_formattedStartTime ?? '1:03 AM'} - ${_formattedEndTime ?? '6:00 PM'}',
                        ),

                        // Location Container
                        _buildInfoContainer(
                          backgroundColor: const Color(0xFFFFFBE6),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                          title:
                              widget.event.isOnline
                                  ? 'Online Event'
                                  : (widget.event.venueName ??
                                      'Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011'),
                          subtitle:
                              widget.event.isOnline
                                  ? (widget.event.eventLink ??
                                      'No link provided')
                                  : (widget.event.venueName ??
                                      'Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011'),
                          subtitleColor: Colors.blue,
                        ),

                        // Contact Information Container
                        _buildInfoContainer(
                          backgroundColor: const Color(0xFFE6F4FF),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                          title: 'Contact Information',
                          subtitle: widget.event.contactInfo ?? '09489258459',
                        ),

                        const SizedBox(height: 16),
                        const Divider(),

                        // About Event Section
                        _buildSectionTitle('About Event'),

                        // Event Description with See More/Less
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.description ??
                                  'No description provided.',
                              maxLines: _isDescriptionExpanded ? null : 3,
                              overflow:
                                  _isDescriptionExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: _toggleDescription,
                              child: Text(
                                _isDescriptionExpanded
                                    ? 'See Less'
                                    : 'See More',
                                style: TextStyle(
                                  color: _navyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),

                        // Event Details
                        _buildSectionTitle('Event Details'),
                        const SizedBox(height: 16),

                        // Simplified event details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column - Organizers and Participants
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Organizers',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A0A4A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Hardcoded organization name
                                  const Text(
                                    'Church Name Organization',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Special Thanks to the people',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  // Use contact info from event data
                                  Text(
                                    widget.event.contactInfo ?? '09228888111',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Participants',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A0A4A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Optimized participant list
                                  _buildParticipantsList(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Right column - Speakers/Guests and Dress code
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Speakers/Guests',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A0A4A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Display speakers from event data
                                  if (widget.event.speakers.isNotEmpty)
                                    ...widget.event.speakers
                                        .take(3)
                                        .map(
                                          (speaker) => Text(
                                            speaker,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        )
                                  else
                                    Text(
                                      'No speakers specified',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Dress code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A0A4A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.event.dressCode ?? 'Not specified',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Add extra padding at the bottom to ensure content isn't hidden behind buttons
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fixed overlay buttons at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Register Button
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isRegistered ? Colors.grey[400] : Colors.amber,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isRegistered ? null : _registerForEvent,
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Text(
                              _isRegistered ? 'Registered' : 'Register',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Go Home Button
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _navyBlue,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _navigateToEventsTab,
                          borderRadius: BorderRadius.circular(25),
                          child: const Center(
                            child: Text(
                              'Go Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Chat Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.chat_bubble_outline, color: _navyBlue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chat feature coming soon'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Share Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share, color: _navyBlue),
                      onPressed: _showShareDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Registration Success Notification
          if (_showRegistrationNotification)
            Positioned(
              top: topPadding + 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Successfully registered!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _dismissNotification,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
