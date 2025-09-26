import 'package:flutter/material.dart';
import 'dart:io';
import 'models/event.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'services/event_service.dart';
import '../../backend/models/CHURCH_CREATEVENTS_VAR.dart';
import '../../backend/viewmodels/CHURCH_CREATEVENTS_FUNC.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> 
    with ChurchCreateVentsVar, ChurchCreateVentsFunc {

  @override
  void initState() {
    super.initState();
    initEventDetailsScreen(widget.event);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initEventDetailsScreenDependencies(context);
  }

  @override
  void dispose() {
    disposeEventDetailsScreen();
    super.dispose();
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
                    buildEventImage(screenHeight),

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
                          onTap: () => toggleLike(() => setState(() {})),
                          child: Row(
                            children: [
                              Icon(
                                hasLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: hasLiked ? Colors.red : navyBlue,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Likes $likeCount',
                                style: TextStyle(
                                  color: navyBlue,
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
                        buildInfoContainer(
                          backgroundColor: const Color(0xFFFEEBEB),
                          leading: Container(
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: navyBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.event.startDate != null
                                      ? monthFormatter.format(
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
                              formattedStartDate ?? 'Friday, April 25, 2025',
                          subtitle:
                              '${formattedStartTime ?? '1:03 AM'} - ${formattedEndTime ?? '6:00 PM'}',
                        ),

                        // Location Container
                        buildInfoContainer(
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
                        buildInfoContainer(
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
                        buildSectionTitle('About Event'),

                        // Event Description with See More/Less
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.description ??
                                  'No description provided.',
                              maxLines: isDescriptionExpanded ? null : 3,
                              overflow:
                                  isDescriptionExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () => toggleDescription(() => setState(() {})),
                              child: Text(
                                isDescriptionExpanded
                                    ? 'See Less'
                                    : 'See More',
                                style: TextStyle(
                                  color: navyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),

                        // Event Details
                        buildSectionTitle('Event Details'),
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
                                  buildParticipantsList(widget.event),
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
                        color: isRegistered ? Colors.grey[400] : Colors.amber,
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
                          onTap: isRegistered ? null : () => registerForEvent(() => setState(() {})),
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Text(
                              isRegistered ? 'Registered' : 'Register',
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
                        color: navyBlue,
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
                          onTap: () => navigateToEventsTab(context),
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
                      icon: Icon(Icons.chat_bubble_outline, color: navyBlue),
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
                      icon: Icon(Icons.share, color: navyBlue),
                      onPressed: () => showShareDialog(context, eventUrl),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Registration Success Notification
          if (showRegistrationNotification)
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
                        onPressed: () => dismissNotification(() => setState(() {})),
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
