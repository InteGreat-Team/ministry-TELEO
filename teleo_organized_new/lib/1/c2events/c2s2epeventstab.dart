import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/event.dart';
import 'models/registered_event.dart';
import 'c2s3_1epeventstab.dart';
import 'c2s4epeventstab.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final bool isRegistered;

  const EventDetailsScreen({
    super.key,
    required this.event,
    this.isRegistered = false,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isRegistered = false;
  bool _isVolunteer = false;
  final DateFormat _dateFormatter = DateFormat('MMMM dd, yyyy');
  String _formattedStartDate = '';
  String _formattedStartTime = '';
  String _formattedEndTime = '';
  String _eventUrl = '';
  int _likeCount = 0;
  bool _showRegistrationNotification = false;
  bool _showVolunteerNotification = false;
  String _notificationMessage = '';
  static const Color _navyBlue = Color(0xFF000233);

  @override
  void initState() {
    super.initState();

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
    _likeCount = widget.event.likes;

    // Initialize registration status
    _isRegistered =
        widget.isRegistered ||
        RegisteredEventManager.isRegisteredAsAttendee(widget.event);
    _isVolunteer = RegisteredEventManager.isVolunteerForEvent(widget.event);

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

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _checkRegistrationStatus() {
    setState(() {
      _isRegistered = RegisteredEventManager.isRegisteredAsAttendee(
        widget.event,
      );
      _isVolunteer = RegisteredEventManager.isVolunteerForEvent(widget.event);
    });
  }

  void _navigateToRegistration() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: widget.event),
      ),
    );

    if (result == true) {
      setState(() {
        _isRegistered = true;
        _showRegistrationNotification = true;
        _notificationMessage = 'Successfully registered as attendee!';

        // Auto-hide notification after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showRegistrationNotification = false;
            });
          }
        });
      });
    }
  }

  // Function to navigate to volunteer form
  void _navigateToVolunteerForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolunteerFormScreen(event: widget.event),
      ),
    ).then((result) {
      // Check if volunteer status has changed
      setState(() {
        _isVolunteer = RegisteredEventManager.isVolunteerForEvent(widget.event);
        if (_isVolunteer) {
          _showVolunteerNotification = true;
          _notificationMessage = 'Successfully registered as volunteer!';

          // Auto-hide notification after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showVolunteerNotification = false;
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format date and time
    String formattedDate = '';
    String formattedTime = '';

    if (widget.event.startDate != null) {
      formattedDate = DateFormat(
        'EEEE, MMMM d, y',
      ).format(widget.event.startDate!);
    }

    if (widget.event.startTime != null && widget.event.endTime != null) {
      final startHour =
          widget.event.startTime!.hourOfPeriod == 0
              ? 12
              : widget.event.startTime!.hourOfPeriod;
      final startMinute = widget.event.startTime!.minute.toString().padLeft(
        2,
        '0',
      );
      final startPeriod =
          widget.event.startTime!.period == DayPeriod.am ? 'AM' : 'PM';

      final endHour =
          widget.event.endTime!.hourOfPeriod == 0
              ? 12
              : widget.event.endTime!.hourOfPeriod;
      final endMinute = widget.event.endTime!.minute.toString().padLeft(2, '0');
      final endPeriod =
          widget.event.endTime!.period == DayPeriod.am ? 'AM' : 'PM';

      formattedTime =
          '$startHour:$startMinute $startPeriod - $endHour:$endMinute $endPeriod';
    }

    final double topPadding = MediaQuery.of(context).padding.top;

    void dismissNotification() {
      setState(() {
        _showRegistrationNotification = false;
        _showVolunteerNotification = false;
      });
    }

    void showShareDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Share Event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Share this event with others:\n$_eventUrl')],
            ),
            actions: [
              TextButton(
                child: const Text('Copy Link'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with Event Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: widget.event.color,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: widget.event.color,
                    child: Center(
                      child: Text(
                        widget.event.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Event Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      Text(
                        widget.event.title ?? 'Untitled Event',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Event Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var tag in widget.event.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Add volunteer badge if event accepts volunteers
                      if (widget.event.allowsVolunteers == true)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.volunteer_activism,
                                color: Colors.green,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Volunteers Needed: ${widget.event.volunteersNeeded ?? ""}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Date and Time
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        title: 'Date',
                        content: formattedDate,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.access_time,
                        title: 'Time',
                        content: formattedTime,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        title: 'Location',
                        content:
                            widget.event.location ?? 'No location specified',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.business,
                        title: 'Venue',
                        content: widget.event.venueName ?? 'No venue specified',
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.event.description ?? 'No description available',
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Speakers
                      if (widget.event.speakers.isNotEmpty) ...[
                        const Text(
                          'Speakers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              widget.event.speakers.map((speaker) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        speaker,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Volunteer Roles Section (if applicable)
                      if (widget.event.allowsVolunteers == true &&
                          widget.event.volunteerRoles != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Volunteer Roles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A0A4A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.event.volunteerRoles!.map(
                          (role) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  role,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Additional Info
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.people,
                        title: 'Expected Capacity',
                        content:
                            widget.event.expectedCapacity?.toString() ??
                            'Not specified',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.style,
                        title: 'Dress Code',
                        content: widget.event.dressCode ?? 'Not specified',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.info_outline,
                        title: 'Invite Type',
                        content: widget.event.inviteType ?? 'Not specified',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.phone,
                        title: 'Contact',
                        content: widget.event.contactInfo ?? 'Not specified',
                      ),

                      // Add volunteer information if applicable
                      if (widget.event.allowsVolunteers) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Volunteer Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A0A4A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.volunteer_activism,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.event.volunteersNeeded ?? 0} Volunteers Needed',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Available Roles:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              if (widget.event.volunteerRoles != null &&
                                  widget.event.volunteerRoles!.isNotEmpty)
                                ...widget.event.volunteerRoles!.map(
                                  (role) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(role),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                const Text('No specific roles defined'),
                            ],
                          ),
                        ),
                      ],

                      // Registration Status Cards
                      if (_isRegistered || _isVolunteer) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Your Registration Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Attendee Registration Status
                      if (_isRegistered)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'You are registered as an attendee',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Check your appointments section for details',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Volunteer Registration Status
                      if (_isVolunteer)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.volunteer_activism,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'You are volunteering for this event',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Check your appointments section for details',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(
                        height: 100,
                      ), // Space for the bottom buttons
                    ],
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
                    flex: 1,
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
                          onTap: _isRegistered ? null : _navigateToRegistration,
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Text(
                              _isRegistered ? 'Registered' : 'Register',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Volunteer Button (only for events that allow volunteers)
                  if (widget.event.allowsVolunteers) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // Change color to grey if already volunteered
                          color: _isVolunteer ? Colors.grey[400] : Colors.green,
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
                            // Disable the button if already volunteered
                            onTap:
                                _isVolunteer ? null : _navigateToVolunteerForm,
                            borderRadius: BorderRadius.circular(25),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.volunteer_activism,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Volunteer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                      onPressed: showShareDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Registration Success Notification
          if (_showRegistrationNotification || _showVolunteerNotification)
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
                    color:
                        _showVolunteerNotification ? Colors.green : Colors.blue,
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
                      Icon(
                        _showVolunteerNotification
                            ? Icons.volunteer_activism
                            : Icons.check_circle,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _notificationMessage,
                        style: const TextStyle(
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
                        onPressed: dismissNotification,
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

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 2),
              Text(content, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
